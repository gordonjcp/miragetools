/* vim: set noexpandtab ai ts=4 sw=4 tw=4:

	as.c - part of as9 6809 assembler
*/


#include <string.h>
#include <unistd.h>

static char *rcs_id = "Mirage asm09 2012 <gordon@gjcp.net>";

char mapdn();
char *alloc();
void PrintHelp (char *pszName);
/*
 *	as ---	cross assembler main program
 */
int main(int argc, char **argv) {
	char	**np;
	char	*i;
	int	j = 0, c, srcarg;

	if(argc < 2){
	   PrintHelp (argv[0]);
	   exit(1);
	}
	Argv = argv;
	initialize();

	while ((c = getopt (argc, argv, "lscxo:")) != -1)
		switch (c) {
			case 'o':
				strncpy(Obj_name, optarg, 64);
				break;
			case 'l':
				Lflag = 1;
				break;
			case 's':
				Sflag = 1;
				break;
			case 'c':
				Cflag = 1;
				break;
			case 'x':
				CREflag = 1;
				break;
			case '?':
				if (optopt == 'o') {
					fprintf (stderr, "Option -%c requires an argument.\n", optopt);
				}
				if (isprint (optopt)) {
					fprintf (stderr, "Unknown option `-%c'.\n", optopt);
				} else {
					fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
				}
				return 1;
			default:
				abort ();
           }

	root = NULL;
	N_files = argc - optind;

	if (strlen(Obj_name)==0) {
		// copy first filename as object name
		strcpy(Obj_name,argv[optind]);
		i = strrchr(Obj_name, '.');
		strncpy(i, ".s19", 4);
	}

	if( (Objfil = fopen(Obj_name,"w")) == NULL) fatal("Can't create object file");

	// first pass
	srcarg = optind;  // get the first filename
	while (srcarg < argc) {
		Fd = fopen(argv[srcarg], "r");
		strncpy(cur_file, argv[srcarg], 64);	// save filename for warnings etc
		Line_num = 0; /* reset line number */
		if (!Fd) {
			printf("as: cannot open source file %s\n", argv[srcarg]);
		} else {
			make_pass();
			fclose(Fd);
		}
		srcarg++;
	}

	if (Err_count) exit(Err_count);
	
	Pass++;
	re_init();
	srcarg = optind;

	while (srcarg < argc) {
		Fd = fopen(argv[srcarg], "r");
		strncpy(cur_file, argv[srcarg], 64);	// save filename for warnings etc
		Line_num = 0; /* reset line number */		

		if (!Fd) {
			printf("as: cannot open source file %s\n", argv[srcarg]);
		} else {
			make_pass();
			fclose(Fd);
		}
		
		if (Sflag == 1) {
			printf ("\f");
			stable (root);
		}
		if (CREflag == 1) {
			printf ("\f");
			cross (root);
		}
		srcarg++;
	}

	fprintf(Objfil,"S9030000FC\n"); /* at least give a decent ending */
	if (Err_count) exit(Err_count);
	else return 0;
}

void PrintHelp (char *pszName)
{
  fprintf (stderr, "%s:  assembler for Motorola MPUs\n", pszName);
  fprintf (stderr, "  Usage:    %s file1 file2 -option1 -option2...\n", pszName);
  fprintf (stderr, "  Options:  l - generate listing\n");
  fprintf (stderr, "            c - cycle count on\n");
  fprintf (stderr, "            s - symbol table on\n");
  fprintf (stderr, "            x - cross reference flag\n");
  fprintf (stderr, "            o [file] - specify output filename\n");
  //fprintf (stderr, "            h  - this listing\n");
  //fprintf (stderr, "            V  - print version information\n");
  fprintf (stderr, "  Version:  %s\n", rcs_id);
}

initialize()
{

	int	i = 0;

#ifdef DEBUG
	printf("Initializing\n");
#endif
	Err_count = 0;
	Pc	  = 0;
	Pass	  = 1;
	Lflag	  = 0;
	Cflag	  = 0;
	Ctotal	  = 0;
	Sflag	  = 0;
	CREflag   = 0;
	N_page	  = 0;
	Line[MAXBUF-1] = NEWLINE;
	fwdinit();	/* forward ref init */
	localinit();	/* target machine specific init. */
}

re_init()
{
#ifdef DEBUG
	printf("Reinitializing\n");
#endif
	Pc	= 0;
	E_total = 0;
	P_total = 0;
	Ctotal	= 0;
	N_page	= 0;
	fwdreinit();
}

make_pass() {
	char	*fgets();

#ifdef DEBUG
	printf("Pass %d\n",Pass);
#endif
	while( fgets(Line,MAXBUF-1,Fd) != (char *)NULL ){
		Line_num++;
		P_force = 0;	/* No force unless bytes emitted */
		N_page = 0;
		   if(parse_line())
			process();
		if(Pass == 2 && Lflag && !N_page)
			print_line();
		P_total = 0;	/* reset byte count */
		Cycles = 0;	/* and per instruction cycle count */
		}
	f_record();
}


/*
 *	parse_line --- split input line into label, op and operand
 */
parse_line()
{
	register char *ptrfrm = Line;
	register char *ptrto = Label;
	char	*skip_white();

	if( *ptrfrm == '*' || *ptrfrm == '\n' )
		return(0);	/* a comment line */

	while( delim(*ptrfrm)== NO )
		*ptrto++ = *ptrfrm++;
	if(*--ptrto != ':')ptrto++;     /* allow trailing : */
	*ptrto = EOS;

	ptrfrm = skip_white(ptrfrm);

	ptrto = Op;
	while( delim(*ptrfrm) == NO)
		*ptrto++ = mapdn(*ptrfrm++);
	*ptrto = EOS;

	ptrfrm = skip_white(ptrfrm);

	ptrto = Operand;
	while( *ptrfrm != NEWLINE )
		*ptrto++ = *ptrfrm++;
	*ptrto = EOS;

#ifdef DEBUG
	printf("Label-%s-\n",Label);
	printf("Op----%s-\n",Op);
	printf("Operand-%s-\n",Operand);
#endif
	return(1);
}

/*
 *	process --- determine mnemonic class and act on it
 */
process()
{
	register struct oper *i;
	struct oper *mne_look();

	Old_pc = Pc;		/* setup `old' program counter */
	Optr = Operand; 	/* point to beginning of operand field */

	if(*Op==EOS){		/* no mnemonic */
		if(*Label != EOS)
			install(Label,Pc);
		}
	else if( (i = mne_look(Op))== NULL)
		error("Unrecognized Mnemonic");
	else if( i->class == PSEUDO )
		do_pseudo(i->opcode);
	else{
		if( *Label )install(Label,Pc);
		if(Cflag)Cycles = i->cycles;
		do_op(i->opcode,i->class);
		if(Cflag)Ctotal += Cycles;
		}
}
