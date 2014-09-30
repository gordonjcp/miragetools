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
#include <string.h>
#include <ctype.h>
#include "disk.h"

int hex_to_int(char x) {
	x=toupper(x);
	if( x>= '0' && x<= '9') return(x-'0');
	return(10+(x-'A'));
}

int load_srec(FILE *in, char *buffer) {
	// this is messy horrible code nicked from 6809emu
	// it wasn't so messy and horrible before I messed with it
	
	char buf[200];
	int num_bytes,i,p,done=0;
	long start_addr;
	char value;

	fgets(buf,200,in);
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
				buffer[start_addr+i-0x8000] = value; // shift down $8000 to allow for the RAM mapping
			}

		/* check for ending */
		if(!strncmp("S9",buf,2)) {
			break;   /* done */
		}
		fgets(buf,200,in);
		if(feof(in))done=1;
	}
	return(1);
}


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
	for(; track<=11; track++) {

		fd_readwrite(fd, MFD_WRITE, track, 5, 512, buffer + 10240+(512*track));
	}
}

void get_os(int fd, char *filename) {
	// get the OS from disk, and save as a binary image
	
	char buffer[16384];
	FILE *out, *in;
	int track;

	// from disk
	if(fd!=-1) {
		get_os_sectors(fd, buffer);
	
		out=fopen(filename,"w");
		if(!out) {
			fprintf(stderr,"cannot open %s\n", filename);
			exit(1);
		}

		if (fwrite(buffer, 1, 16384, out) != 16384) {
			fprintf(stderr,"error writing %s\n", filename);
			fclose(out);
			exit(1);
		}
		fclose(out);
	} 
	
	// from disk image
	else {
		in=fopen(filename,"r");
		if(!in) {
			fprintf(stderr, "cannot open %s\n", filename);
			exit(1);
		}
		
		// 0x8000-0xabff
		if( fread(buffer, 1, 11264, in) != 11264)
		{
dumpfile_readfail:
			fprintf(stderr, "error reading %s\n", filename);
			fclose(in);
			exit(-1);
		}
		
		// remaining short tracks
		for(track=2; track<=11; track++)
		{
			fseek(in, 5120, SEEK_CUR);
			if( fread(buffer+11264+(track-2)*512, 1, 512, in) != 512)
				goto dumpfile_readfail;
		}

		// cough it out
		fwrite(buffer, 1, 16384, stdout);
	}
}

void put_os(int fd, char *filename) {
	// get the OS from disk, and save as a binary image
	
	char buffer[16384];
	FILE *in;

	in=fopen(filename,"r");
	if(!in) {
		fprintf(stderr,"cannot open %s\n", filename);
		exit(1);
	}

	if (strncmp(strrchr(filename, '.'), ".s19", 4) == -1) {
		// doesn't end with .s19, so we'll assume (possibly wrongly)
		// that it isn't a Motorola S-REC file	

		if (fread(buffer, 1, 16384, in) != 16384) {
			fprintf(stderr,"error reading %s\n", filename);
			fclose(in);
			exit(1);
		}
		fclose(in);
	} else {
		// *does* end with .s19, so we'll assume (possibly wrongly)
		// that this is a Motorola S-REC file
		load_srec(in, buffer);
		
	}

	if(fd!=-1)
		put_os_sectors(fd, buffer);
	else
		fprintf(stderr,"Unsupported scheme. L8r.\n");
}


