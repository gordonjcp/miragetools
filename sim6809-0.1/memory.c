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

tt_u8 *ramdata;    /* 64 kb of ram */

static int protect_rom = 0;

int memory_init(void) {
	// allocate RAM and fetch ROM from disk
	FILE *in;
	
	ramdata = (tt_u8 *)malloc(65536); // FIXME is this ever actually free()ed?
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
	return 1;
}

tt_u8 get_memb(tt_u16 adr) {
	// fetch bytes from memory, or dispatch a call to the device handler
	switch (adr & 0xff00) {
		case 0xe100:	// ACIA
			return acia_rreg(adr & 0xff);
		default:
			#ifdef DEBUGDEV
			// FIXME needs last rpc, not this rpc
			printf("$%04x: unhandled hardware device %04x\n", rpc, adr);
			#endif
			break;
	}
	return ramdata[adr];
}

tt_u16 get_memw(tt_u16 adr)
{
  return (tt_u16)get_memb(adr) << 8 | (tt_u16)get_memb(adr + 1);
}

void set_memb(tt_u16 adr, tt_u8 val) {
	// write byte to memory, or dispatch a call to the device handler
	switch (adr & 0xff00) {
		case 0xe100:	// ACIA
			acia_wreg(adr & 0xff, val);
			break;
	}
	if (adr>0xf000) {
		#ifdef DEBUGROM
		printf("$%04x: write to ROM %04x=%02x\n", rpc, adr, val);
		#endif
		if (protect_rom) return;
	}
	ramdata[adr] = val;
}

void set_memw(tt_u16 adr, tt_u16 val)
{
  set_memb(adr, (tt_u8)(val >> 8));
  set_memb(adr + 1, (tt_u8)val);
}


