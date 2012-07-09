# Makefile for sim6809
# Copyright (C) 1998 Jerome Thoen

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

CC = gcc
LIBS = 
INC = 
CDEBUG = -g
CFLAGS = $(CDEBUG) $(INC) -Wall
LDFLAGS = -g

OBJS= console.o dis6809.o emu6809.o inst6809.o int6809.o memory.o \
      misc.o miscutils.o intel.o

sim6809:$(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

console.o: console.c config.h emu6809.h console.h

dis6809.o: dis6809.c config.h emu6809.h

emu6809.o: emu6809.c config.h emu6809.h

inst6809.o: inst6809.c config.h emu6809.h

int6809.o: int6809.c config.h emu6809.h

memory.o: memory.c config.h console.h

misc.o: misc.c config.h emu6809.h

miscutils.o: miscutils.c config.h  

intel.o: intel.c config.h emu6809.h

clean:
	rm -f sim6809 *.o core
