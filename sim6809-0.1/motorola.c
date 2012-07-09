/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   motorola.c -- Motorola S1 support 
   Copyright (C) 1999 Noah Vawter

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
#include <string.h>
#include <ctype.h>
#include "motorola.h"
#include "config.h"
#include "emu6809.h"

int load_motos1(char *filename)
{
  char buf[201];
  int num_bytes,i,p,done=0;
  long start_addr;
  unsigned char value;
  FILE *fi;
	
  fi=fopen(filename,"r");
  if(fi==NULL)
  {
    printf("can't open it, sorry.\n");
    return(0);
  }
  
  fgets(buf,200,fi);
  while(!done)
  {
    /* read len */  /* 2 bytes of addr, 1 byte is checksum */
    num_bytes = (16*hex_to_int(buf[2])+hex_to_int(buf[3]))-3;
    
    /* read addr */
    start_addr=0;
    for(p=4,i=0;i<4;i++)
      start_addr = (start_addr<<4) + hex_to_int(buf[p++]);

    /* read data */
    for(i=0;i<num_bytes;i++) {
      value = 16*hex_to_int(buf[p])+hex_to_int(buf[p+1]);
      p+=2;
      set_memb(start_addr+i,value);
      //      printf("0x%08x: 0x%02x\n",start_addr+i,value);
    }

    /* check for ending */
    if(!strncmp("S9",buf,2))
    {
      break;   /* done */
    }
    fgets(buf,200,fi);
    if(feof(fi))done=1;
  }
  fclose(fi);
  return(1);
}

int hex_to_int(char x)
{
	x=toupper(x);

	if( x>= '0' && x<= '9') return(x-'0');
	return(10+(x-'A'));
}
