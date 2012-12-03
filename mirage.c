// vim: set noexpandtab ai ts=4 sw=4 tw=4:

/*  miragedisk, part of a set of disk tools for the Ensoniq Mirage
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


static struct argp_option options[] = {
	{"get", 'g', "AREA", 0, "Get sample from disk" },
	{"put", 'p', "AREA", 0, "Write sample to disk" },
	{ 0 }
};

enum { NONE, GET, PUT} mode;

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
		case ARGP_KEY_ARG:
			if (state->arg_num >= 1) printf("too many args\n");
			arguments->sample = arg;
			break;
		case ARGP_KEY_END:
			if (state->arg_num<1) {
				printf("not enough arguments\n");
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
	fd_readtrack(fd, track, buffer);

	// first block is special, because it has the params at the start
	for (i=0; i<4096; i++) {
		sf_buffer[i] = (buffer[i+1024]-128)<<8;
	}
	sf_write_short(snd, sf_buffer, 4096);
	
	for(j = ++track; j<track+12; j++) {
		fd_readtrack(fd, j, buffer);
		for (i=0; i<5120; i++) {
			sf_buffer[i] = (buffer[i]-128)<<8;
		}		
		sf_write_short(snd, sf_buffer, 5120);
	}
		
	sf_close(snd);
}

void putsample(int fd, int area, char *filename) {

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
	// need to get the original track into the buffer first
	fd_readtrack(fd, track, buffer);
	sf_read_short(snd, sf_buffer, 4096);
	for (i=0; i<4096; i++) {
		buffer[i+1024] = (sf_buffer[i]>>8)+128;
	}
	fd_writetrack(fd, track, buffer);

	track++;
	for(j = track; j<track+12; j++) {
		sf_read_short(snd, sf_buffer, 5120);
		for (i=0; i<5120; i++) {
			buffer[i] = (sf_buffer[i]>>8)+128;
		}

		fd_writetrack(fd, j, buffer);
	}
		
	sf_close(snd);
}


static struct argp argp = { options, parse_opt, "SAMPLE", "mirage disk tool" };

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
	
	if (!arguments.mode) {
		printf("must use --get <area> or --put <area>\n");
		exit(1);
	}

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
	}
	
	close(fd);

}
