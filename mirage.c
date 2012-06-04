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


static struct argp_option options[] = {
	{"get", 'g', "AREA", 0, "Get sample from disk" },
	{"put", 'p', "AREA", 0, "Write sample to disk" },
	{ 0 }
};

struct arguments {
	char *arg;
	int get, put;
	int area;
};


static error_t parse_opt (int key, char *arg, struct argp_state *state) {
	// parse one option
	struct arguments *arguments = state->input;
	
	switch (key) {
		case 'g': arguments->get = 1; arguments->area = atoi(arg); break;
		case 'p': arguments->put = 1; arguments->area = atoi(arg); break;
		case ARGP_KEY_ARG:
			if (state->arg_num >= 1) printf("too many args\n");
			arguments->arg = arg;
			break;
		case ARGP_KEY_END:
			if (state->arg_num<1) printf("not enough arguments\n"); break;
		default:
			return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

static struct argp argp = { options, parse_opt, "SAMPLE", "mirage disk tool" };

int main (int argc, char **argv) {

	int fd = -1;	// file descriptor for floppy
	
	struct arguments arguments;
	argp_parse(&argp, argc, argv, 0, 0, &arguments);
	
	fd = open("/dev/fd0", O_ACCMODE | O_NDELAY);
	if (fd == -1) {
		perror("couldn't open /dev/fd0");
		exit(1);
	}
	
	printf("parsed filename %s\n", arguments.arg);
	printf("disk exerciser\nrecalibrate floppy\n");
	fd_recalibrate(fd);
	sleep(2);
	printf("seeking to track 79\n");
	fd_seek(fd, 79);
	sleep(2);
	printf("seeking to track 40\n");
	fd_seek(fd,40);
	sleep(2);
	printf("step in\n");
	fd_seekin(fd);
	sleep(1);
	printf("step in\n");
	fd_seekin(fd);
	sleep(1);
	printf("step in\n");
	fd_seekin(fd);
	sleep(1);
	printf("step in\n");
	fd_seekin(fd);
	sleep(1);
	
	close(fd);

}
