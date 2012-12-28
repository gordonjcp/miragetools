// vim: set noexpandtab ai ts=4 sw=4 tw=4:

/*  miragedisk, part of a set of disk tools for the Ensoniq Mirage
	(C) 2012 Gordon JC Pearce MM0YEQ <gordon@gjcp.net>
	
	disk.c
	Floppy disk ioctl routines

	miragedisk is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 2 of the License, or
	any later version.

	miragedisk is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with miragedisk.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <linux/fd.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <linux/fdreg.h>

#include "disk.h"

static char buffer[5632];
static struct floppy_raw_cmd raw_cmd;

void fd_readwrite(int fd, int rdwr, int trk, int sect, int len, char *buffer) {
	// read or write either a 5120-byte "track" or 512-byte sector

	struct floppy_raw_cmd raw_cmd;
	int tmp;

	raw_cmd.rate = 2;	   // set rate for 3.5" DD floppy
	raw_cmd.track = trk;

	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer;
	
	// note that reading more than the number of sectors available (ie.
	// reading 5120 bytes starting from sector 1) will cause an error
	if (len>5120) len=5120;		// cap len at 5120 bytes for normal track
	if (sect == 5) len = 512;   // sector 5 is always 512 bytes
	
	raw_cmd.length = len;
	raw_cmd.flags = FD_RAW_INTR | FD_RAW_NEED_SEEK;

	raw_cmd.flags |= rdwr ? FD_RAW_WRITE : FD_RAW_READ;

	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = rdwr ? FD_WRITE : FD_READ;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;    // head, drive (always 0)
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;  // track
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;    // head (always 0)
	raw_cmd.cmd[raw_cmd.cmd_count++] = sect; // sector number
	// sector size is next, 128 * (2^n) bytes
	raw_cmd.cmd[raw_cmd.cmd_count++] = (sect == 5) ? 2 : 3;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;    // max sectors per track (sets gap size)
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b; // GAP3 length (magic, no idea)
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff; // read all sectors

	// now do the actual reading or writing
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);
}



void fd_recalibrate(int fd) {
	// reset the floppy controller
	struct floppy_raw_cmd raw_cmd;
	int tmp;

	raw_cmd.flags = FD_RAW_INTR;
	raw_cmd.cmd_count = 0;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_RECALIBRATE;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);
}

void fd_seek(int fd, int trk) {
	// seek to a particular track
	
	struct floppy_raw_cmd raw_cmd;
	int tmp, i;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_INTR | FD_RAW_NEED_SEEK;

	raw_cmd.cmd_count = 0;
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_SEEK;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 1;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);
}

void fd_seekin(int fd) {
	// step one track in
	struct floppy_raw_cmd raw_cmd;
	int tmp, i;

	raw_cmd.flags = FD_RAW_INTR;
	raw_cmd.cmd_count = 0;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = FD_RSEEK_IN;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 1;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);
}

void fd_readtrack(int fd, int trk, char *buffer) {
	// fetch (most of) a track from disk
	// doesn't read the last 512-byte sector

	struct floppy_raw_cmd raw_cmd;
	int tmp, i, j;
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_READ | FD_RAW_INTR | FD_RAW_NEED_SEEK;

	// read first part
	raw_cmd.cmd_count = 0;
	raw_cmd.data = buffer;
	raw_cmd.length = 5120;
	
	// set up the command
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xe6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = trk;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 3;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 6;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0x1b;
	raw_cmd.cmd[raw_cmd.cmd_count++] = 0xff;
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);

}

void fd_writetrack(int fd, int trk, char *buffer) {
	// writes five 1024-byte sectors, not a whole track

	struct floppy_raw_cmd raw_cmd;
	int tmp, i, j;
	raw_cmd.rate = 2;
	raw_cmd.track = trk;
	raw_cmd.flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_NEED_SEEK;


	// read first part
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
	/*
			printf("instrumented\n");
			printf("%02x %ld %ld\n", raw_cmd.flags, raw_cmd.length, raw_cmd.phys_length);
			printf("%d %d %d\n", raw_cmd.buffer_length, raw_cmd.rate, raw_cmd.track);
				
	for( i=0; i< raw_cmd.cmd_count; i++ )
		printf("%d: %x\n", i, raw_cmd.cmd[i] );
	*/
	tmp = ioctl( fd, FDRAWCMD, &raw_cmd );
	if(tmp) perror(__func__);
	
	//for( i=0; i< raw_cmd.reply_count; i++ )
	//		printf("%d: %x\n", i, raw_cmd.reply[i] );

}

