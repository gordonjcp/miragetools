/* console.c -- debug console 
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
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <ctype.h>

#include "config.h"
#include "emu6809.h"
#include "console.h"

long cycles = 0;

static int activate_console = 0;
static int console_active = 0;

static void sigbrkhandler(int sigtype)
{
  if (!console_active)
    activate_console = 1;
}

static void setup_brkhandler(void)
{
  signal(SIGINT, sigbrkhandler);
}

void console_init(void)
{
  printf("sim6809 v0.1 - 6809 simulator\nCopyright (c) 1998 by Jerome Thoen\n\n");
}

int m6809_system(void) 
{
  static char input[256];
  char *p = input;
  tt_u8 c;

  switch (ra) {
  case 0 :
    printf("Program terminated\n");
    rti();
    return 1;
  case 1 :
    while ((c = get_memb(rx++)))
      putchar(c);
    rti();
    return 0;
  case 2 :
    ra = 0;
    if (rb) {
      fflush(stdout);
      if (fgets(input, rb, stdin)) {
	do {
	  set_memb(rx++, *p);
	  ra++;
	} while (*p++);
	ra--;
      } else
	set_memb(rx, 0);
    }
    set_memb(rs + 1, ra);
    rti();
    return 0;
  default :
    printf("Unknown system call %d\n", ra);
    rti();
    return 0;
  }
}

int execute()
{
  int n;
  int r = 0;

  do {
    while ((n = m6809_execute()) > 0 && !activate_console)
      cycles += n;

    if (activate_console && n > 0)
      cycles += n;
    
    if (n == SYSTEM_CALL)
      r = activate_console = m6809_system();
    else if (n < 0) {
      printf("m6809 run time error, return code %d\n", n);
      activate_console = r = 1;
    }
  } while (!activate_console);

  return r;
}

void execute_addr(tt_u16 addr)
{
  int n;

  while (!activate_console && rpc != addr) {
    while ((n = m6809_execute()) > 0 && !activate_console && rpc != addr)
      cycles += n;
    
    if (n == SYSTEM_CALL)
      activate_console = m6809_system();
    else if (n < 0) {
      printf("m6809 run time error, return code %d\n", n);
      activate_console = 1;
    }
  }
}

void ignore_ws(char **c)
{
  while (**c && isspace(**c))
    (*c)++;
}

tt_u16 readhex(char **c)
{
  tt_u16 val = 0;
  char nc;

  ignore_ws(c);

  while (isxdigit(nc = **c)){
    (*c)++;
    val *= 16;
    nc = toupper(nc);
    if (isdigit(nc)) {
      val += nc - '0';
    } else {
      val += nc - 'A' + 10;
    }
  }
  
  return val;
}

int readint(char **c)
{
  int val = 0;
  char nc;

  ignore_ws(c);

  while (isdigit(nc = **c)){
    (*c)++;
    val *= 10;
    val += nc - '0';
  }
  
  return val;
}

char *readstr(char **c)
{
  static char buffer[256];
  int i = 0;

  ignore_ws(c);

  while (!isspace(**c) && **c && i < 255)
    buffer[i++] = *(*c)++;

  buffer[i] = '\0';

  return buffer;
}

int more_params(char **c)
{
  ignore_ws(c);
  return (**c) != 0;
}

char next_char(char **c)
{
  ignore_ws(c);
  return *(*c)++;
} 
  
void console_command()
{
  static char input[80], copy[80];
  char *strptr;
  tt_u16 memadr, start, end;
  long n;
  int i, r;
  int regon = 0;

  for(;;) {
    activate_console = 0;
    console_active = 1;
    printf("> ");
    fflush(stdout);
    if(fgets(input, 80, stdin) == 0)
      return;
    if (strlen(input) == 1)
      strptr = copy;
    else
      strptr = strcpy(copy, input);
    
    switch (next_char(&strptr)) {
    case 'c' :
      for (n = 0; n < 0x10000; n++)
	set_memb((tt_u16)n, 0);
      printf("Memory cleared\n");
      break;
    case 'd' :
      if (more_params(&strptr)) {
	start = readhex(&strptr);
	if (more_params(&strptr))
	  end = readhex(&strptr);
	else
	  end = start;
      } else 
	start = end = memadr;
      
      for(n = start; n <= end && n < 0x10000; n += dis6809((tt_u16)n, stdout));

      memadr = (tt_u16)n;
      break;
    case 'f' :
      if (more_params(&strptr)) {
	console_active = 0;
	execute_addr(readhex(&strptr));
	if (regon) {
	  m6809_dumpregs();
	  printf("Next PC: ");
	  dis6809(rpc, stdout);
	}
	memadr = rpc;
      } else
	printf("Syntax Error. Type 'h' to show help.\n");
      break;
    case 'g' :
      if (more_params(&strptr))
	rpc = readhex(&strptr);
      console_active = 0;
      execute();
      if (regon) {
	m6809_dumpregs();
	printf("Next PC: ");
	dis6809(rpc, stdout);
      }
      memadr = rpc;
      break;
    case 'h' : case '?' :
      printf("     HELP for the 6809 simulator debugger\n\n");
      printf("   c               : clear memory\n");
      printf("   d [start] [end] : disassemble memory from <start> to <end>\n");
      printf("   f adr           : step forward until PC = <adr>\n");
      printf("   g [adr]         : start execution at current address or <adr>\n");
      printf("   h, ?            : show this help page\n");
      printf("   l file          : load Intel Hex binary <file>\n");
      printf("   m [start] [end] : dump memory from <start> to <end>\n");
      printf("   n [n]           : next [n] instruction(s)\n");
      printf("   p adr           : set PC to <adr>\n");
      printf("   q               : quit the emulator\n");
      printf("   r               : dump CPU registers\n");
#ifdef PC_HISTORY
      printf("   s               : show PC history\n");
      printf("   t               : flush PC history\n");
#endif
      printf("   u               : toggle dump registers\n");
      printf("   y [0]           : show number of 6809 cycles [or set it to 0]\n");
      break;
    case 'l' :
      if (more_params(&strptr))
	load_intelhex(readstr(&strptr));
      else
	printf("Syntax Error. Type 'h' to show help.\n");
      break;
    case 'm' :
      if (more_params(&strptr)) {
	n = readhex(&strptr);
	if (more_params(&strptr))
	  end = readhex(&strptr);
	else
	  end = n;
      } else 
	n = end = memadr;
      while (n <= (long)end) {
	printf("%04hX: ", (unsigned int)n);
	for (i = 1; i <= 8; i++)
	  printf("%02X ", get_memb(n++));
	n -= 8;
	for (i = 1; i <= 8; i++) {
	  tt_u8 v;

	  v = get_memb(n++);
	  if (v >= 0x20 && v <= 0x7e)
	    putchar(v);
	  else
	    putchar('.');
	}
	putchar('\n');
      }
      memadr = n;
      break;
    case 'n' :
      if (more_params(&strptr))
	i = readint(&strptr);
      else
	i = 1;

      while (i-- > 0) {
	activate_console = 1;
	if (!execute()) {
	  printf("Next PC: ");
	  memadr = rpc + dis6809(rpc, stdout);
	  if (regon)
	    m6809_dumpregs();
	} else
	  break;
      }
      break;
    case 'p' :
      if(more_params(&strptr))
	rpc = readhex(&strptr);
      else
	printf("Syntax Error. Type 'h' to show help.\n");
      break;
    case 'q' :
      return;
    case 'r' :
      m6809_dumpregs();
      break;
#ifdef PC_HISTORY
    case 's' :
      r = pchistidx - pchistnbr;
      if (r < 0)
	r += PC_HISTORY_SIZE;
      for (i = 1; i <= pchistnbr; i++) {
	dis6809(pchist[r++], stdout);
	if (r == PC_HISTORY_SIZE)
	  r = 0;
      }
      break;
    case 't' :
      pchistnbr = pchistidx = 0;
      break;
#endif
    case 'u' :
      regon ^= 1;
      printf("Dump registers %s\n", regon ? "on" : "off");
      break;
    case 'y' :
      if (more_params(&strptr))
	if(readint(&strptr) == 0) {
	  cycles = 0;
	  printf("Cycle counter initialized\n");
	} else
	  printf("Syntax Error. Type 'h' to show help.\n");
      else {
	double sec = (double)cycles / 1000000.0;

	printf("Cycle counter: %ld\nEstimated time at 1 Mhz : %g seconds\n", cycles, sec);
      }
      break;
    default :
      printf("Undefined command. Type 'h' to show help.\n");
      break;
    }
  }
}

void parse_cmdline(int argc, char **argv)
{
  if (--argc == 0)
    return;
  if (!strcmp(argv[1], "-h")) {
    printf("%s: [file [...]]\n", argv[0]);
    exit(0);
  }
  while (argc-- > 0)
    load_intelhex(*++argv);
}

int main(int argc, char **argv)
{
  if (!memory_init())
    return 1;
  parse_cmdline(argc, argv);
  console_init();
  m6809_init();
  setup_brkhandler();
  console_command();

  return 0;
}
