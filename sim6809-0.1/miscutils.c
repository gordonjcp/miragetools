/* miscutils.c -- misc utils
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
#include <stdlib.h>
#include <unistd.h>

#include "config.h"

void *mmalloc(size_t n) 
{
  void *p;

  p = (void *)malloc(n);
  if (!p) {
    fprintf(stderr, "Not enough memory to allocate %d bytes\n", n);
    abort();
  }
  return p;
}
