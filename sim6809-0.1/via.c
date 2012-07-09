/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   acia.c -- emulation of 6522 VIA
   Copyright (C) 2012 Gordon JC Pearce
	
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

#include "config.h"
#include "via.h"
#include "emu6809.h"

/*
VIA is clocked at 2MHz
T2 is programmed to divide by 5000

Register maps
Port A					Port B
0 LED segment			bank 0/1
1 LED segment			upper/lower
2 LED segment			mic/line
3 anode 1 active low	sample/play
4 anode 2 active low	drive select/motor on (active low)
5 keypad row 0			DOC CA3 input
6 keypad row 1			disk ready
7 keypad row 2			(not used, clock to ACIA)

*/

static long via_cycles, via_t2=0;

void via_run() {
	if (cycles < via_cycles) return; // not ready yet
	
	if (via.ier & 0x20) {
		via.ifr |= 0xa0;	// timer 2 interrupt, interrupt flag
		irq();  // fire interrupt
	}
	via_cycles = cycles + (via_t2>>2);  // half, because the clock frequency is 2MHz
}

tt_u8 via_rreg(int reg) {

	tt_u8 val;

	switch(reg) {
		case 0:
			val = (via.orb & 0x1f) | 0x40; // fake disk ready
			break;
		case 10:
			printf("pc: %04x via_rreg read shift register unhandled\n", last_rpc);
			val = 0;
			break;
		case 12:
			val = via.pcr;
			break;
		case 13:
			val = via.ifr;
			break;
		case 14:
			val = via.ier;
			break;	
		case 15:
			printf("pc: %04x via_rreg read IRA no handshake unhandled\n", last_rpc);
			val = 0;
			break;
		default:
			printf("pc: %04x via_rreg(%d, 0x%02x)\n", last_rpc, reg, val);
		}

	return val;
}

void via_wreg(int reg, tt_u8 val) {
	int bc;

	switch(reg) {
		case 0:

			bc = val ^ via.orb;
			printf("%04x: %02x portb ", last_rpc, bc);
			if (bc == 0) printf("no change");
			if (bc & 0x01) printf("bank=%s ", (val & 0x10)?"1":"0");
			if (bc & 0x02) printf("half=%s ", (val & 0x10)?"upper":"lower");
			if (bc & 0x04) printf("input=%s ", (val & 0x10)?"mic":"line");
			if (bc & 0x08) printf("mode=%s ", (val & 0x10)?"sample":"play");
			if (bc & 0x10) printf("fdc=%s ", (val & 0x10)?"off":"on");
			printf("\n");
			via.orb = val;
			return;
		case 1: // port A only used for keypad and display
			return;
		case 2:
			printf("%04x: ddrb=%02x\n", last_rpc, val);
			via.ddrb = val;
			break;
		case 3:
			printf("%04x: ddra=%02x\n", last_rpc, val);
			via.ddra = val;
			break;
		case 4:
		case 5:
		case 6:
		case 7:
			printf("%04x: timer/counter 1 %02x=%02x\n", last_rpc, reg, val);
			break;
		case 8:
			via.t2l = val;
			via_t2 = via.t2l | (via.t2h<<8);
			via_cycles = cycles + (via_t2>>2);  // half, because the clock frequency is 2MHz
			printf("%-4x: t2 = %04x\n", last_rpc, (int) via_t2);
			break;
		case 9:
			via.t2h = val;
			via_t2 = via.t2l | (via.t2h<<8);
			via_cycles = cycles + (via_t2>>2);  // half, because the clock frequency is 2MHz
			//printf("%-4x: t2 = %04x\n", last_rpc, (int) via_t2);
			break;
		case 10:
			printf("%04x: sr<=%02x\n", last_rpc, val);
			break;
		case 11:
			printf("%04x: acr<=%02x\n", last_rpc, val);
			break;
		case 12:
			via.pcr = val;
			printf("%04x: pcr<=%02x\n", last_rpc, val);
			break;
		case 13:
			val &= 0x7f;
			via.ifr &= ~val;
			printf("%04x: val=%02x ier<=%02x\n", last_rpc, val, via.ifr);
			break;
		case 14:
			// okay, this is a funny one.  If bit 7 is set, the remaining bits
			// that are high are set high in IER.  If it is unset, the remaining
			// bits that are high are cleared.
			
			if (val & 0x80) via.ier |= (val & 0x7f);
				else via.ier &= (~val);
			
			printf("%04x: val=%02x ier=%02x\n", last_rpc, val, via.ier);
			
			break;
		case 15:
			printf("%04x: ora<=%02x\n", last_rpc, val);
			break;
		default:
			printf("pc: %04x via_wreg(%d, 0x%02x)\n", last_rpc, reg, val);	
	}
}
