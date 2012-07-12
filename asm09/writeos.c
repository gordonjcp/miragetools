/* vim: set noexpandtab ai ts=4 sw=4 tw=4:

   writeos.c -- write an OS to Mirage disk
   
   put a formatted Mirage floppy in /dev/fd0 and run with:
   
   $ ./writeos <image.s19>
   
   where image.s19 is in Motorola S-record format and starts at $8000
   FIXME - this will only write the first two tracks (10Kbytes) of the disk
   which ought to be enough for now
   
   Copyright (C) 2012 Gordon JC Pearce <gordon@gjcp.net>

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
#include <linux/fd.h>
#include <fcntl.h>
#include <errno.h>
#include <linux/fdreg.h>

char *buffer, *osimage;


int hex_to_int(char x) {
	x=toupper(x);
	if( x>= '0' && x<= '9') return(x-'0');
	return(10+(x-'A'));
}

int load_motos1(FILE *fi) {
	char buf[201];
	int num_bytes,i,p,done=0;
	long start_addr;
	unsigned char value;

	fgets(buf,200,fi);
	while(!done) {
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
				osimage[start_addr+i-0x8000] = value;
			}

		/* check for ending */
		if(!strncmp("S9",buf,2)) {
			break;   /* done */
		}
		fgets(buf,200,fi);
		if(feof(fi))done=1;
	}
	return(1);
}



void seektrack(int fd, int trk) {

	struct floppy_raw_cmd raw_cmd;
	int tmp, i;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_INTR | FD_RAW_NEED_SEEK;

	raw_cmd.cmd_count = 0;
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_SEEK;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) printf("tmp nonzero, error = \"%s\"\n", strerror(errno));


}

void seekin(int fd) {

	struct floppy_raw_cmd raw_cmd;
	int tmp, i;

	raw_cmd.flags = FD_RAW_INTR;
	raw_cmd.cmd_count = 0;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_RSEEK_IN;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 1;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) printf("seekin nonzero, error = \"%s\"\n", strerror(errno));


}

void writetrack(int fd, int trk, char *buffer) {

	struct floppy_raw_cmd raw_cmd;
	int tmp, i, j;
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_NEED_SEEK;


	// write first part
	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer;
	raw_cmd.length = 5120;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_WRITE;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 3;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) printf("write nonzero, error = \"%s\"\n", strerror(errno));
		
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_NEED_SEEK;
	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer+5120;
	raw_cmd.length = 512;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_WRITE;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 5;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 2;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if (tmp) printf("write2 nonzero, error = \"%s\"\n", strerror(errno));
}

int main(int argc, char **argv) {
	int fd = -1, tmp, i, j;
	struct floppy_raw_cmd raw_cmd;
	FILE *in;

	if (argc<2) {
		printf("\nusage: %s <image.s19>\n", argv[0]);
		exit(1);
	}
	in=fopen(argv[1],"r");
	if(!in) {
		printf("cannot open %s\n", argv[1]);
		return(0);
	}
  


	fd = open("/dev/fd0", O_ACCMODE | O_NDELAY);
	if (fd==-1) {
		printf("cannot open /dev/fd0: %s\n", strerror(errno));
		exit(1);
	}
	
	buffer = malloc(5632);
	if (!buffer) {
		printf("cannot allocate track buffer\n");
		exit(1);
	}

	osimage = malloc(16384);
	if (!osimage) {
		printf("cannot allocate image buffer\n");
		exit(1);
	}
	bzero(osimage, 16384);

	load_motos1(in);

	seektrack(fd, 0);
	
	for(i = 0; i< 2; i++) {
		writetrack(fd, i, osimage+5632*i);
		seekin(fd);
	}
	
	free(osimage);
	free(buffer);
	close(fd);
	fclose(in);
}

/* vim: set noexpandtab ai ts=4 sw=4 tw=4: */
