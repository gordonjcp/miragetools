/* misc.c -- 6809 misc
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

static const char ccbits[] = "EFHINZVC";

char hexdigit(tt_u16 v)
{
  v &= 0xf;
  if (v <= 9)
    return '0' + v;
  else
    return 'A' - 10 + v;
}

char *hex8str(tt_u8 v)
{
  static char tmpbuf[3] = "  ";

  tmpbuf[1] = hexdigit(v);
  tmpbuf[0] = hexdigit(v >> 4);

  return tmpbuf;
}

char *hex16str(tt_u16 v)
{
  static char tmpbuf[5] = "    ";

  tmpbuf[3] = hexdigit(v);
  v >>= 4;
  tmpbuf[2] = hexdigit(v);
  v >>= 4;
  tmpbuf[1] = hexdigit(v);
  v >>= 4;
  tmpbuf[0] = hexdigit(v);

  return tmpbuf;
}

char *bin8str(tt_u8 val)
{
  static char tmpbuf[9] = "        ";
  int i;

  for(i = 0; i < 8; i++) {
    if(val & 0x80)
      tmpbuf[i] = '1';
    else
      tmpbuf[i] = '0';
    val <<= 1;
  }

  return tmpbuf;
}

char *ccstr(tt_u8 val)
{
  static char tempbuf[9] = "        ";
  int i;

  for (i = 0; i < 8; i++) {
    if (val & 0x80)
      tempbuf[i] = ccbits[i];
    else
      tempbuf[i] = '.';
    val <<= 1;
  }

  return tempbuf;
}
