/*  vim: set noexpandtab ai ts=4 sw=4 tw=4:

    miragedisk, part of a set of disk tools for the Ensoniq Mirage
	(C) 2012 Gordon JC Pearce MM0YEQ <gordon@gjcp.net>
	
	os.c
	Read and write Mirage OS blocks

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

/*
	The Mirage OS memory is 16KB located between $8000 and $bfff.  The OS
	itself is loaded from track 0 and 1 (11KB) and sector 5 of track 2 to
	track 10.
	Note that the "default" sequences load to $b800 to $bfff as four sectors
	The "Close Encounters" sequence is held on disk on tracks 8-10, with
	track 11 sector 5 holding the system parameters.
*/

#include <stdio.h>
#include <stdlib.h>
#include "disk.h"

void get_os_sectors(int fd, char *buffer) {
	// get the OS from the disk into a buffer
	int track = 0;
	
	// read first two tracks
	fd_readwrite(fd, MFD_READ, track, 0, 5120, buffer);
	fd_readwrite(fd, MFD_READ, track, 5, 512, buffer + 5120);
	track++;
	fd_readwrite(fd, MFD_READ, track, 0, 5120, buffer + 5632);
	fd_readwrite(fd, MFD_READ, track, 5, 512, buffer + 10752);
	track++;
	// loop through the remaining tracks
	for(; track<=10; track++) {

		fd_readwrite(fd, MFD_READ, track, 5, 512, buffer + 10240+(512*track));
	}
}

void put_os_sectors(int fd, char *buffer) {
	// get the OS from the disk into a buffer
	int track = 0;
	
	// read first two tracks
	fd_readwrite(fd, MFD_WRITE, track, 0, 5120, buffer);
	fd_readwrite(fd, MFD_WRITE, track, 5, 512, buffer + 5120);
	track++;
	fd_readwrite(fd, MFD_WRITE, track, 0, 5120, buffer + 5632);
	fd_readwrite(fd, MFD_WRITE, track, 5, 512, buffer + 10752);
	track++;
	// loop through the remaining tracks
	for(; track<=10; track++) {

		fd_readwrite(fd, MFD_WRITE, track, 5, 512, buffer + 10240+(512*track));
	}
}

void get_os(int fd, char *filename) {
	// get the OS from disk, and save as a binary image
	
	char buffer[16384];
	FILE *out;
	get_os_sectors(fd, buffer);
	
	out=fopen(filename,"w");
	if(!out) {
		printf("cannot open %s\n", filename);
		exit(1);
	}

	if (fwrite(buffer, 1, 16384, out) != 16384) {
		printf("error writing %s\n", filename);
		fclose(out);
		exit(1);
	}
	fclose(out);
}

void put_os(int fd, char *filename) {
	// get the OS from disk, and save as a binary image
	
	char buffer[16384];
	FILE *out;
	
	out=fopen(filename,"r");
	if(!out) {
		printf("cannot open %s\n", filename);
		exit(1);
	}

	if (fread(buffer, 1, 16384, out) != 16384) {
		printf("error reading %s\n", filename);
		fclose(out);
		exit(1);
	}
	fclose(out);
	put_os_sectors(fd, buffer);
}


