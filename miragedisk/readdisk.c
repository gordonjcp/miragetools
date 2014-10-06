/* vim: set noexpandtab ai ts=4 sw=4 tw=4: */
/*  readdisk, part of a set of disk tools for the Ensoniq Mirage
	(C) 2010-2011 Gordon JC Pearce MM0YEQ
	
	readdisk.c
	Read a Mirage disk image from a floppy
	
	Put a formatted Mirage disk in /dev/fd0 and read it with:

	$ readdisk <name of image file>

	
	readdisk is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 2 of the License, or
	any later version.

	readdisk is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with miragetools.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <linux/fd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <linux/fdreg.h>
#include <string.h>

char buffer[5632];

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

void readtrack(int fd, int trk, char *buffer) {

	struct floppy_raw_cmd raw_cmd;
	int tmp, i, j;
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_READ | FD_RAW_INTR | FD_RAW_NEED_SEEK;

	// write first part
	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer;
	raw_cmd.length = 5120;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_READ;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 3;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) printf("read nonzero, error = \"%s\"\n", strerror(errno));
		
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_READ | FD_RAW_INTR | FD_RAW_NEED_SEEK;
	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer+5120;
	raw_cmd.length = 512;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_READ;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 5;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 2;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if (tmp) printf("read2 nonzero, error = \"%s\"\n", strerror(errno));
}

void main(int argc, char **argv) {

	int fd = -1, tmp, i, j;
	struct floppy_raw_cmd raw_cmd;
	
	FILE *in;

	if (argc != 2) {
		printf("usage: readdisk <file to save image to>\n");
		exit(1);
	}

	in = fopen(argv[1], "wb");
	if (!in) {
		printf("could not open %s\n",argv[1]);
		exit(1);
	}

	fd = open("/dev/fd0", O_ACCMODE | O_NDELAY);
	if (!fd) {
		printf("could not open /dev/fd0 for reading\n");
		exit(1);
	}

	seektrack(fd, 0);
	
	for(i = 0; i< 80; i++) {
		printf("track %d\n", i);
		readtrack(fd, i, buffer);
		fwrite(buffer, sizeof(char), 5632, in);
		seekin(fd);
	}
	printf("done        \n");
	
	close(fd);
	fclose(in);
}

