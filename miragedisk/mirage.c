/*  vim: set noexpandtab ai ts=4 sw=4 tw=4:

    miragedisk, part of a set of disk tools for the Ensoniq Mirage
	(C) 2012 Gordon JC Pearce MM0YEQ <gordon@gjcp.net>
	
	mirage.c
	Main command handler and routines

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

#include <argp.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sndfile.h>
#include "disk.h"
#include "os.h"

const char *argp_program_version = "miragedisk 0.1";
const char *argp_program_bug_address = "gordon@gjcp.net";

enum { NONE, GET, PUT, GET_OS, PUT_OS } mode;

static struct argp_option options[] = {
	{"get", 'g', "AREA", 0, "Get sample from disk" },
	{"put", 'p', "AREA", 0, "Write sample to disk" },
	{"get-os", GET_OS, NULL, 0, "Get OS from disk" },
	{"put-os", PUT_OS, NULL, 0, "Write OS to disk" },
	{ 0 }
};

struct arguments {
	char *sample;
	int mode;
	int area;
};


static error_t parse_opt (int key, char *arg, struct argp_state *state) {
	// parse one option
	struct arguments *arguments = state->input;
	
	switch (key) {
		case 'g': arguments->mode = GET; arguments->area = atoi(arg); break;
		case 'p': arguments->mode = PUT; arguments->area = atoi(arg); break;
		case GET_OS: arguments->mode = GET_OS; break;
		case PUT_OS: arguments->mode = PUT_OS; break;		
		case ARGP_KEY_ARG:
			if (state->arg_num >= 1) printf("too many args\n");
			arguments->sample = arg;
			break;
		case ARGP_KEY_END:
			if (state->arg_num<1) {
				argp_usage(state);
				exit(1);
			}
 		default:
			return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

void getsample(int fd, int area, char *filename) {

	SNDFILE *snd;
	SF_INFO info;
	
	int i, j, track;
	
	char buffer[5632];
	short sf_buffer[5120];

	info.samplerate = 22050;
	info.channels = 1;
	info.format = SF_FORMAT_WAV | SF_FORMAT_PCM_U8;
	
	snd = sf_open(filename, SFM_WRITE, &info);
	if (!snd) {
		printf("Couldn't open %s", filename);
		sf_perror(NULL);
		exit(1);
	}
	// now we pull the sample
	
	track = 2+(area*13);

	// first track is special, because it has the params at the start
	// we'll start reading from sector 1 and only read 4096 bytes
	fd_readwrite(fd, MFD_READ, track, 1, 4096, buffer);
	for (i=0; i<4096; i++) {
		sf_buffer[i] = (buffer[i]-128)<<8;
	}
	sf_write_short(snd, sf_buffer, 4096);
	
	// now we read full 5120-byte blocks
	for(j = ++track; j<track+12; j++) {
		fd_readwrite(fd, MFD_READ, j, 0, 5120, buffer);		
		for (i=0; i<5120; i++) {
			sf_buffer[i] = (buffer[i]-128)<<8;
		}		
		sf_write_short(snd, sf_buffer, 5120);
	}	
	sf_close(snd);
}

void putsample(int fd, int area, char *filename) {
	// write a sample to the given area on a Mirage disk
	// FIXME - if the sample is already 8-bit unsigned, write it verbatim

	SNDFILE *snd;
	SF_INFO info;
	
	int i, j, track;
	
	char buffer[5632];
	short sf_buffer[5120];
	
	snd = sf_open(filename, SFM_READ, &info);
	if (!snd) {
		printf("Couldn't open %s", filename);
		sf_perror(NULL);
		exit(1);
	}
	
	// write the sample
	track = 2+(area*13);
	
	// first block is special, because it has the params at the start
	// making the first track hold 1k of params and 4k of sample
	sf_read_short(snd, sf_buffer, 4096);
	for (i=0; i<4096; i++) {
		buffer[i] = (sf_buffer[i]>>8)+128;  // convert to unsigned int
		if (buffer[i] ==0 ) buffer[i+1024] = 1; // smash any zero values which will stop the oscillator
	}
	fd_readwrite(fd, MFD_WRITE, track, 1, 4096, buffer);
	track++;
	
	// now write the remaining tracks
	for(j = track; j<track+12; j++) {
		sf_read_short(snd, sf_buffer, 5120);
		for (i=0; i<5120; i++) {
			buffer[i] = (sf_buffer[i]>>8)+128;
			if (buffer[i] ==0 ) buffer[i] = 1;
		}
		fd_readwrite(fd, MFD_WRITE, j, 0, 5120, buffer);
	}
	sf_close(snd);
}


static struct argp argp = { options, parse_opt, "FILE", "mirage disk tool" };

int main (int argc, char **argv) {

	int fd = -1;	// file descriptor for floppy
	SNDFILE *snd;
	SF_INFO info;
	
	int track, sect, i, j;
	unsigned char buffer[5632]; // track buffer
	short int sf_buffer[5120];
	
	struct arguments arguments;
	arguments.mode=NONE;
	
	argp_parse(&argp, argc, argv, 0, 0, &arguments);

	// looks like we have a mode, an area and a sample name
	fd = open("/dev/fd0", O_ACCMODE | O_NDELAY);
	if (fd == -1) {
		perror("couldn't open /dev/fd0");
		exit(1);
	}

	if (arguments.area<0) arguments.area=0;
	if (arguments.area>5) arguments.area=5;

	switch(arguments.mode) {
		case GET: getsample(fd, arguments.area, arguments.sample); break;
		case PUT: putsample(fd, arguments.area, arguments.sample); break;
		case GET_OS: get_os(fd, arguments.sample); break;
		case PUT_OS: put_os(fd, arguments.sample); break;
	}
	close(fd);
}