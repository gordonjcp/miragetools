/* vim: set noexpandtab ai ts=4 sw=4 tw=4: */
/* fdc.c -- emulation of 1772 FDC
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

/* quick technical rundown of the FDC in the Mirage
DRQ is inverted and drives /IRQ
INTRQ is inverted and drives /NMI

So to read data we wait for an interrupt and loop until NMI
At least, this is how the Mirage ROM does it
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "config.h"
#include "fdc.h"
#include "emu6809.h"

int fdc_init() {
	return 0;
}
void fdc_destroy() {
}
void fdc_run() {
}

