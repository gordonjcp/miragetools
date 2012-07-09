/* int6809.c -- 6809 hardware interrupts
   Copyright (C) 1998 Jerome Thoen

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

#include "config.h"
#include "emu6809.h"
#include "calc6809.h"

void reset(void)
{
  rdp = 0;
  ccf = cci = 0;
  rpc = get_memw(0xfffe);
}

void irq(void)
{
  if (!cci) {
    cce = 1;
    do_psh(&rs, &ru, 0xff);
    cci = 1;
    rpc = get_memw(0xfff8);
    nbcycle = 21;
  }
}

void firq(void)
{
  if (!ccf) {
    cce = 0;
    do_psh(&rs, &ru, 0x81);
    cci = ccf = 1;
    rpc = get_memw(0xfff6);
    nbcycle = 12;
  }
}



