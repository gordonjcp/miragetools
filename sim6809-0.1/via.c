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
TODO: implement everything

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

tt_u8 via_rreg(int reg) {

	tt_u8 val;

	if (reg == 0x00) {
		val = (via.orb & 0x1f) | 0x40;  // force disk ready
	}
	printf("pc: %04x via_rreg(%d, 0x%02x)\n", rpc, reg, val);
	return val;
}

void via_wreg(int reg, tt_u8 val) {
	//if (rpc!=0xf376)
	printf("pc: %04x via_wreg(%d, 0x%02x)\n", rpc, reg, val);
	if (reg == 0x00) {
		via.orb = val;
	}
	
}
