/* emu6809.h -- defs
   Copyright (C) 1998 Jerome Thoen

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


tt_u16 rpc, rx, ry, ru, rs;
tt_u8 ra, rb, rdp;
int nbcycle;
int err6809; 
 
#ifdef PC_HISTORY
tt_u16 pchist[PC_HISTORY_SIZE];
int pchistidx;
int pchistnbr;
#endif

/* macros */

#define btst(a, b) (((a) & (b)) != 0)
 
/* defines */

#define ERR_INVALID_OPCODE -1
#define ERR_INVALID_POSTBYTE -2
#define ERR_INVALID_ADDRMODE -3
#define ERR_INVALID_EXGR -4

#define SYSTEM_CALL -100

/* prototypes */

/* console.c */
void console_init(void);
int m6809_system(void);
int execute(void);
void execute_addr(tt_u16 addr);
void ignore_ws(char **c);
tt_u16 readhex(char **c);
int readint(char **c);
int more_params(char **c);
char next_char(char **c);
void console_command(void);
void parse_cmdline(int argc, char **argv);
int main(int argc, char **argv);

/* dis6809.c */
int dis6809(tt_u16 adr, FILE *stream);

/* emu6809.c */
tt_u8 getcc(void);
void setcc(tt_u8 i);
tt_u16 getexr(int c);
void setexr(int c, tt_u16 r);
void do_psh(tt_u16 *rp, tt_u16 *rnp, tt_u8 c);
void do_pul(tt_u16 *rp, tt_u16 *rnp, tt_u8 c);
tt_u8 get_i8(void);
tt_u16 get_i16(void);
void null(void);
tt_u16 nula(void);
tt_u16 immb(void);
tt_u16 immw(void);
tt_u16 dir(void);
tt_u16 idx(void);
tt_u16 ext(void);
tt_u16 relb(void);
tt_u16 relw(void);
void pag2(void);
void pag3(void);
tt_u16 rd(void);
tt_u16 get_eab(void);
tt_u16 get_eaw(void);
void m6809_init(void);
int m6809_execute(void);
void m6809_dumpregs(void);

/* inst6809.c */
void abx(void);
void adca(void);
void adcb(void);
void adda(void);
void addb(void);
void addd(void);
void anda(void);
void andb(void);
void andc(void);
void asla(void);
void aslb(void);
void asl(void);
void asra(void);
void asrb(void);
void asr(void);
void bita(void);
void bitb(void);
void clra(void);
void clrb(void);
void clr(void);
void cmpa(void);
void cmpb(void);
void cmpd(void);
void cmps(void);
void cmpu(void);
void cmpx(void);
void cmpy(void);
void coma(void);
void comb(void);
void com(void);
void cwai(void);
void daa(void);
void deca(void);
void decb(void);
void dec(void);
void eora(void);
void eorb(void);
void exg(void);
void inca(void);
void incb(void);
void inc(void);
void jmp(void);
void jsr(void);
void lda(void);
void ldb(void);
void ldd(void);
void lds(void);
void ldu(void);
void ldx(void);
void ldy(void);
void leas(void);
void leau(void);
void leax(void);
void leay(void);
void lsra(void);
void lsrb(void);
void lsr(void);
void mul(void);
void nega(void);
void negb(void);
void neg(void);
void nop(void);
void ora(void);
void orb(void);
void orcc(void);
void pshs(void);
void pshu(void);
void puls(void);
void pulu(void);
void rola(void);
void rolb(void);
void rol(void);
void rora(void);
void rorb(void);
void ror(void);
void rti(void);
void rts(void);
void sbca(void);
void sbcb(void);
void sex(void);
void sta(void);
void stb(void);
void std(void);
void sts(void);
void stu(void);
void stx(void);
void sty(void);
void suba(void);
void subb(void);
void subd(void);
void swi(void);
void swi2(void);
void swi3(void);
void syn(void);
void tfr(void);
void tsta(void);
void tstb(void);
void tst(void);
void bcc(void);
void lbcc(void);
void bcs(void);
void lbcs(void);
void beq(void);
void lbeq(void);
void bge(void);
void lbge(void);
void bgt(void);
void lbgt(void);
void bhi(void);
void lbhi(void);
void ble(void);
void lble(void);
void bls(void);
void lbls(void);
void blt(void);
void lblt(void);
void bmi(void);
void lbmi(void);
void bne(void);
void lbne(void);
void bpl(void);
void lbpl(void);
void bra(void);
void lbra(void);
void brn(void);
void lbrn(void);
void bsr(void);
void lbsr(void);
void bvc(void);
void lbvc(void);
void bvs(void);
void lbvs(void);

/* int6809.c */
void reset(void);
void irq(void);
void firq(void);

/* memory.c */
int memory_init(void);
tt_u8 get_memb(tt_u16 adr);
tt_u16 get_memw(tt_u16 adr);
void set_memb(tt_u16 adr, tt_u8 val);
void set_memw(tt_u16 adr, tt_u16 val);

/* misc.c */
char hexdigit(tt_u16 v);
char *hex8str(tt_u8 v);
char *hex16str(tt_u16 v);
char *bin8str(tt_u8 val);
char *ccstr(tt_u8 val);

/* miscutils.c */
void *mmalloc(size_t n);

/* intel.c */
void load_intelhex(char *filename);
