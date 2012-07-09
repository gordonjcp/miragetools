/* intel.c -- Intel HEX support 
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

#define READC (*(*ptr)++)
#define GETB (xdigitconv(READC) * 16 + xdigitconv(READC))

static char linebuf[80];
static unsigned char checksum;

static int xdigitconv(char c)
{
  if (c >= '0' && c <= '9')
    return c - '0';
  else if (c >= 'a' && c <= 'f')
    return c - 'a' + 10;
  else
    return c - 'A' + 10;
}

static unsigned char read_byte(char **ptr)
{
  unsigned char val = GETB;

  checksum += val;
  return val;
}

static unsigned int read_word(char **ptr)
{
  unsigned int val1 = GETB;
  unsigned int val2 = GETB;

  checksum += val1;
  checksum += val2;

  return val1 * 256 + val2;
}
						 
static int read_line(void)
{
  char *strptr = linebuf;
  int len, i;
  tt_u16 addr;
  unsigned char type;

  if (*strptr++ != ':') {
    printf("Bad record\n");
    return 1;
  }

  checksum = 0;

  len = read_byte(&strptr);
  addr = read_word(&strptr);
  type = read_byte(&strptr);

  for (i = 1; i <= len; i++)
    set_memb(addr++, read_byte(&strptr));

  read_byte(&strptr);

  if (checksum != 0) {
    printf("Bad checksum\n");
    return 1;
  }

  if (type == 1)
    return 1;
  else
    return 0;
}

void load_intelhex(char *filename)
{
  FILE *fp;
  int end = 0;

  fp = fopen(filename, "r");

  if (!fp) {
    printf("Could not open file %s\n", filename);
    return;
  }

  while (fgets(linebuf, 80, fp) != NULL && !end)
    end = read_line();

}

