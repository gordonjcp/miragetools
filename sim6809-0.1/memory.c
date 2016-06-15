/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   memory.c -- Memory emulation
   Copyright (C) 1998 Jerome Thoen
   Copyright (C) 2012 Gordon JC Pearce <gordonjcp@gjcp.net>
   
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

#include "config.h"
#include "emu6809.h"
#include "console.h"
#include "acia.h"
#include "fdc.h"
#include "via.h"

//#define DEBUGDEV

uint8_t *ramdata;    /* 64 kb of ram */

static int protect_rom = 0;

int memory_init(void) {
	// allocate RAM and fetch ROM from disk
	FILE *in;
	
	ramdata = (uint8_t *)malloc(65536); // FIXME is this ever actually free()ed?
	if (!ramdata) {
		fprintf(stderr, "Failed to allocate RAM area\n");
		abort();
	}

	// fetch the ROM
	in = fopen("miragerom.bin", "r");   // FIXME allow filename from cli
	if (in) {
		fread(ramdata + 0xf000, sizeof(char), 4096, in);
		protect_rom = 1;	// do not allow the ROM to be overwritten
		fclose(in);
	} else {
		fprintf(stderr, "warning: Could not open ROM image\n");
	}
	
	// if we run off the end of "normal" RAM, die
	ramdata[0xc000] = 0x86;
	ramdata[0xc001] = 0x00;
	ramdata[0xc002] = 0x3f;
	ramdata[0x0000] = 0x86;
	ramdata[0x0001] = 0x00;
	ramdata[0x0002] = 0x3f;
	
	return 1;
}

uint8_t get_memb(uint16_t adr) {
	// fetch bytes from memory, or dispatch a call to the device handler
	
	//if (last_rpc <0x8000 && activate_console==0) activate_console=1;
#if 0
	// crappy breakpoint ;-)
	if(adr == 0x893c && activate_console==0) {
		printf("break \n");
		activate_console=1;
	}
#endif
	if ((adr & 0xf000) != 0xe000) return ramdata[adr];  // device map
	if (adr == 0xece2 && last_rpc==0xf5c7) return 0xa0;
	if (adr == 0xece2) return 0x40;
	switch (adr & 0xff00) {
		case 0xe100:	// ACIA
			return acia_rreg(adr & 0xff);
		case 0xe800:	// FDC
			return fdc_rreg(adr & 0xff);
		case 0xe200:	// VIA
			return via_rreg(adr & 0xff);
		default:
			#ifdef DEBUGDEV
			// FIXME needs last rpc, not this rpc
			printf("$%04x: unhandled hardware device %04x\n", last_rpc, adr);
			#endif
			break;
	}
	 return ramdata[adr];
}

uint16_t get_memw(uint16_t adr)
{
  return (uint16_t)get_memb(adr) << 8 | (uint16_t)get_memb(adr + 1);
}

void set_memb(uint16_t adr, uint8_t val) {
	// write byte to memory, or dispatch a call to the device handler

	if (last_rpc<0x8000 && activate_console==0) activate_console=1;

	if (adr>0xf000) {
		#ifdef DEBUGROM
		printf("$%04x: write to ROM %04x=%02x\n", last_rpc, adr, val);
		#endif
		if (protect_rom) return;
	}
	
	if ((adr & 0xf000) != 0xe000) { // device map
		ramdata[adr] = val;
		return;
	}

	switch (adr & 0xff00) {
		case 0xe100:	// ACIA
			acia_wreg(adr & 0xff, val);
			break;
		case 0xe800:	// FDC
			fdc_wreg(adr & 0xff, val);
			break;
		case 0xe200:	// VIA
			via_wreg(adr & 0xff, val);
			break;
		case 0xec00:
			printf("$%04x: DOC %04x set to %02x\n", last_rpc, adr, val);
			break;
		case 0xe400:
			//printf("$%04x: mux %04x set to %02x\n", last_rpc, adr, val);
			break;
		default:
			#ifdef DEBUGDEV
			// FIXME needs last rpc, not this rpc
			printf("$%04x: unhandled hardware device %04x\n", last_rpc, adr);
			#endif
			break;
	}

}

void set_memw(uint16_t adr, uint16_t val)
{
  set_memb(adr, (uint8_t)(val >> 8));
  set_memb(adr + 1, (uint8_t)val);
}


