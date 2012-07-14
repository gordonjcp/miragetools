/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   acia.c -- emulation of 6850 ACIA
   Copyright (C) 2012 Gordon JC Pearce

	TODO: implement interrupts

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pty.h>
#include <fcntl.h>
#include <alsa/asoundlib.h>

#include "config.h"
#include "emu6809.h"
#include "acia.h"

/*
   The 6850 ACIA in the Mirage is mapped at $E100
   registers are:
   $e100 control register / status register
   $e101 transmit register / receive register
   I only intend to implement CR7 RX interrupt and CR5 TX interrupt in the control
   and SR0 RD full, SR1 TX empty, and SR7 IRQ
   maybe for robustness testing I will implement a way to signal errors
   RTS, CTS and DCD are not used, with the latter two held grounded
*/

static long acia_cycles;

static int master, slave;
static snd_rawmidi_t *m_out = NULL;
static snd_rawmidi_t *m_in = NULL;

static void acia_run_pty();
static void acia_run_midi();

void (*acia_run)() = NULL;

static int midi_init() {
	int i;
	if ((i = snd_rawmidi_open(&m_in, &m_out, "virtual", SND_RAWMIDI_SYNC | SND_RAWMIDI_NONBLOCK)) < 0) {
		printf("Couldn't open MIDI port: %s", snd_strerror(i));
		return -1;
	}
	acia_run = &acia_run_midi;
	return 0;
}

static int pty_init() {
	// configure a PTY and print its name on the console
	int i;

	pid_t pid = openpty(&master, &slave, NULL, NULL, NULL);
	if (pid == -1) {
		printf("openpty failed");
		exit(1);
	}   // FIXME better error handling
	
	if(pid == 0){
		printf("ACIA port: %s\n", ttyname(slave));
		// Ensure that the echo is switched off 
		struct termios orig_termios;
		if (tcgetattr (master, &orig_termios) < 0) {
			perror ("ERROR getting current terminal's attributes");
			return -1;
		}
		
		orig_termios.c_lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON);
		orig_termios.c_oflag &= ~(ONLCR);
		orig_termios.c_cc[VTIME] = 0;
		orig_termios.c_cc[VMIN] = 0;
		
		i = fcntl(master, F_GETFL, 0);
		
		fcntl(master, F_SETFL, i | O_NONBLOCK);
		
		if (tcsetattr (master, TCSANOW, &orig_termios) < 0) {
			perror ("ERROR setting current terminal's attributes");
			return -1;
		}

		acia_run = &acia_run_pty;
		return master; //Return the file descriptor
	}
	
	printf("something failed\n");

	return -1;
}


int acia_init(int device) {

	// tx register empty
	acia.sr = 0x02;
	
	if (device == 0) { // MIDI
		return midi_init();
	} else {
		return pty_init();
	}
	return -1;
}

void acia_destroy() {
	if (master) close(master);
	if (slave) close(slave);

	if (m_in) snd_rawmidi_close(m_in);
	if (m_out) snd_rawmidi_close(m_out);	

}

static void acia_run_pty() {
	// call this every time around the loop
	int i;
	char buf;

	if (cycles < acia_cycles) return;  // nothing to do yet
	acia_cycles = cycles + ACIA_CLK;	// nudge timer
	// read a character?
	i =read(master, &buf, 1);
	if(i != -1) {
		acia.rdr = buf;
		acia.sr |= 0x01;
		if (acia.cr & 0x80) {
			acia.sr |= 0x80;
			firq();
		}
	}
	
	// got a character to send?
	if (!(get_memb(0xe100) & 0x02)) {
		buf = acia.tdr;
		write(master, &buf, 1);
		acia.sr |= 0x02;
		if ((acia.cr & 0x60) == 0x20) {
			acia.sr |= 0x80;
			firq();
		}
	}
}

static void acia_run_midi() {
	// call this every time around the loop
	int i;
	char buf;

	if (cycles < acia_cycles) return;  // nothing to do yet
	acia_cycles = cycles + ACIA_CLK;	// nudge timer
	// read a character?
	i =snd_rawmidi_read(m_in, &buf, 1);
	if(i != -1) {
		acia.rdr = buf;
		acia.sr |= 0x01;
		if (acia.cr & 0x80) {
			acia.sr |= 0x80;
			firq();
		}
	}
	
	// got a character to send?
	if (!(get_memb(0xe100) & 0x02)) {
		buf = acia.tdr;
		snd_rawmidi_write(m_out, &buf, 1);
		acia.sr |= 0x02;
		if ((acia.cr & 0x60) == 0x20) {
			acia.sr |= 0x80;
			firq();
		}
	}
}


tt_u8 acia_rreg(int reg) {
	// handle reads from ACIA registers
	switch (reg & 0x01) {   // not fully mapped
		case ACIA_SR:
			return acia.sr;
		case ACIA_RDR:
			acia.sr &= 0x7e;	// clear IRQ, RDRF
			return acia.rdr;
	}
	return 0xff;	// maybe the bus floats
}
void acia_wreg(int reg, tt_u8 val) {
	// handle writes to ACIA registers
	switch (reg & 0x01) {   // not fully mapped
		case ACIA_CR:
			acia.cr = val;
			break;
		case ACIA_TDR:
			acia.tdr = val;
			acia.sr &= 0x7d;	// clear IRQ, TDRE
			break;
	}
}

