/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   fdc.c -- emulation of 1772 FDC
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

#ifndef __FDC_H
#define __FDC_H

// registers
#define FDC_SR 0
#define FDC_CR 0
#define FDC_TRACK 1
#define FDC_SECTOR 2
#define FDC_DATA 3

#include <stdint.h>

int fdc_init();
void fdc_destroy();
void fdc_run();
uint8_t fdc_rreg(int reg);
void fdc_wreg(int reg, uint8_t val);

struct {
	uint8_t sr;
	uint8_t cr;
	uint8_t trk_r;
	uint8_t sec_r;
	uint8_t data_r;
} fdc;

#endif

