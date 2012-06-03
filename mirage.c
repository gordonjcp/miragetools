// vim: set noexpandtab ai ts=4 sw=4 tw=4:
// mirage.c
// todo: add licence header

#include <argp.h>
#include <stdio.h>
#include <stdlib.h>

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
	struct arguments arguments;
	argp_parse(&argp, argc, argv, 0, 0, &arguments);
	
	printf("%s\n", arguments.arg);

}
