/* vim: set noexpandtab ai ts=4 sw=4 tw=4: */
/* acia.h -- emulation of 6850 ACIA
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

#ifndef __ACIA_H
#define __ACIA_H

#include "emu6809.h"

#define ACIA_CR 0
#define ACIA_SR 0
#define ACIA_TDR 1
#define ACIA_RDR 1

// at 31250bps there will be 320 clocks between characters
#define ACIA_CLK 320

int acia_init(int device);
void acia_destroy();
void (*acia_run)();
tt_u8 acia_rreg(int reg);
void acia_wreg(int reg, tt_u8 val);

struct {
	tt_u8 cr;
	tt_u8 sr;
	tt_u8 tdr;
	tt_u8 rdr;
} acia;

#endif
