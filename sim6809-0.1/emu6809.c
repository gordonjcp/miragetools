/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   emu6809.c -- 6809 simulator
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


#include <stdio.h>

#include "config.h"
#include "emu6809.h"
#include "calc6809.h"

uint16_t rpc, last_rpc, rx, ry, ru, rs;

uint8_t ra, rb, rdp;

int ccc, ccv, ccz, ccn, cci, cch, ccf, cce;

uint16_t *regp[] = { &rx, &ry, &ru, &rs };

int addrmode;
int nbcycle;
int err6809;

#ifdef PC_HISTORY
uint16_t pchist[PC_HISTORY_SIZE];
int pchistidx = 0;
int pchistnbr = 0;
#endif
 
/*
	modes:
	1 immediate
	2 direct    
	3 indexed   
	4 extended  
	5 inherent
	6 relative
*/

int amod[] = {
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
  0,0,5,5,0,0,6,6,0,5,1,1,1,5,5,5,
  6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
  3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,
  5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
  5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  1,1,1,1,1,1,1,1,1,1,1,1,1,6,1,0,
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,

  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,
  0,0,0,2,0,0,0,0,0,0,0,0,2,0,2,2,
  0,0,0,3,0,0,0,0,0,0,0,0,3,0,3,3,
  0,0,0,4,0,0,0,0,0,0,0,0,4,0,4,4,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,

  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,
  0,0,0,2,0,0,0,0,0,0,0,0,2,0,0,0,
  0,0,0,3,0,0,0,0,0,0,0,0,3,0,0,0,
  0,0,0,4,0,0,0,0,0,0,0,0,4,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };

int cycle[] = {
  6,0,0,6,6,0,6,6,6,6,6,0,6,6,3,6,
  0,0,2,2,0,0,5,9,0,2,3,0,3,2,8,6,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  4,4,4,4,5,5,5,5,0,5,3,6,20,11,0,19,
  2,0,0,2,2,0,2,2,2,2,2,0,2,2,0,2,
  2,0,0,2,2,0,2,2,2,2,2,0,2,2,0,2,
  6,0,0,6,6,0,6,6,6,6,6,0,6,6,3,6,
  7,0,0,7,7,0,7,7,7,7,7,0,7,7,4,7,
  2,2,2,4,2,2,2,0,2,2,2,2,4,7,3,0,
  4,4,4,6,4,4,4,4,4,4,4,4,6,7,5,5,
  4,4,4,6,4,4,4,4,4,4,4,4,6,7,5,5,
  5,5,5,7,5,5,5,5,5,5,5,5,7,8,6,6,
  2,2,2,4,2,2,2,0,2,2,2,2,3,0,3,0,
  4,4,4,6,4,4,4,4,4,4,4,4,5,5,5,5,
  4,4,4,6,4,4,4,4,4,4,4,4,5,5,5,5,
  5,5,5,7,5,5,5,5,5,5,5,5,6,6,6,6,

  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,5,0,0,0,0,0,0,0,0,5,0,4,0,
  0,0,0,7,0,0,0,0,0,0,0,0,7,0,6,6,
  0,0,0,7,0,0,0,0,0,0,0,0,7,0,6,6,
  0,0,0,8,0,0,0,0,0,0,0,0,8,0,7,7,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,

  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,5,0,0,0,0,0,0,0,0,5,0,0,0,
  0,0,0,7,0,0,0,0,0,0,0,0,7,0,0,0,
  0,0,0,7,0,0,0,0,0,0,0,0,7,0,0,0,
  0,0,0,8,0,0,0,0,0,0,0,0,8,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };

void (*fonc[])() = {
neg ,null,null,com ,lsr ,null,ror ,asr ,asl ,rol ,dec ,null,inc ,tst ,jmp ,clr ,
pag2,pag3,nop ,syn ,null,null,lbra,lbsr,null,daa ,orcc,null,andc,sex ,exg ,tfr ,
bra ,brn ,bhi ,bls ,bcc ,bcs ,bne ,beq ,bvc ,bvs ,bpl ,bmi ,bge ,blt ,bgt ,ble ,
leax,leay,leas,leau,pshs,puls,pshu,pulu,null,rts ,abx ,rti ,cwai,mul ,null,swi ,
nega,null,null,coma,lsra,null,rora,asra,asla,rola,deca,null,inca,tsta,null,clra,
negb,null,null,comb,lsrb,null,rorb,asrb,aslb,rolb,decb,null,incb,tstb,null,clrb,
neg ,null,null,com ,lsr ,null,ror ,asr ,asl ,rol ,dec ,null,inc ,tst ,jmp ,clr ,
neg ,null,null,com ,lsr ,null,ror ,asr ,asl ,rol ,dec ,null,inc ,tst ,jmp ,clr ,
suba,cmpa,sbca,subd,anda,bita,lda ,null,eora,adca,ora ,adda,cmpx,bsr ,ldx ,null,
suba,cmpa,sbca,subd,anda,bita,lda ,sta ,eora,adca,ora ,adda,cmpx,jsr ,ldx ,stx ,
suba,cmpa,sbca,subd,anda,bita,lda ,sta ,eora,adca,ora ,adda,cmpx,jsr ,ldx ,stx ,
suba,cmpa,sbca,subd,anda,bita,lda ,sta ,eora,adca,ora ,adda,cmpx,jsr ,ldx ,stx ,
subb,cmpb,sbcb,addd,andb,bitb,ldb ,null,eorb,adcb,orb ,addb,ldd ,null,ldu ,null,
subb,cmpb,sbcb,addd,andb,bitb,ldb ,stb ,eorb,adcb,orb ,addb,ldd ,std ,ldu ,stu ,
subb,cmpb,sbcb,addd,andb,bitb,ldb ,stb ,eorb,adcb,orb ,addb,ldd ,std ,ldu ,stu ,
subb,cmpb,sbcb,addd,andb,bitb,ldb ,stb ,eorb,adcb,orb ,addb,ldd ,std ,ldu ,stu ,

null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,lbrn,lbhi,lbls,lbcc,lbcs,lbne,lbeq,lbvc,lbvs,lbpl,lbmi,lbge,lblt,lbgt,lble,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,swi2,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,cmpd,null,null,null,null,null,null,null,null,cmpy,null,ldy ,null,
null,null,null,cmpd,null,null,null,null,null,null,null,null,cmpy,null,ldy ,sty ,
null,null,null,cmpd,null,null,null,null,null,null,null,null,cmpy,null,ldy ,sty ,
null,null,null,cmpd,null,null,null,null,null,null,null,null,cmpy,null,ldy ,sty ,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,lds ,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,lds ,sts ,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,lds ,sts ,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,lds ,sts ,
 
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,swi3,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,cmpu,null,null,null,null,null,null,null,null,cmps,null,null,null,
null,null,null,cmpu,null,null,null,null,null,null,null,null,cmps,null,null,null,
null,null,null,cmpu,null,null,null,null,null,null,null,null,cmpu,null,null,null,
null,null,null,cmpu,null,null,null,null,null,null,null,null,cmpu,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null };

uint16_t (*eaddrmodb[7])() = {
  nula, immb, dir, idx, ext, nula, relb };

uint16_t (*eaddrmodw[7])() = {
  nula, immw, dir, idx, ext, nula, relw };

uint8_t getcc()
{
  return(ccc | ccv << 1 | ccz << 2 | ccn << 3 | cci << 4 | cch << 5 | ccf << 6 | cce << 7);
}

void setcc(uint8_t i)
{
  ccc = btst(i, 0x01);
  ccv = btst(i, 0x02);
  ccz = btst(i, 0x04);
  ccn = btst(i, 0x08);
  cci = btst(i, 0x10);
  cch = btst(i, 0x20);
  ccf = btst(i, 0x40);
  cce = btst(i, 0x80);
}

uint16_t getexr(int c)
{
  switch(c) {
  case 0:
    return((uint16_t)ra << 8 | (uint16_t)rb);
  case 1:
    return(rx);
  case 2:
    return(ry);
  case 3:
    return(ru);
  case 4:
    return(rs);
  case 5:
    return(rpc);
  case 8:
    return((uint16_t)ra);
  case 9:
    return((uint16_t)rb);
  case 10:
    return((uint16_t)getcc());
  case 11:
    return((uint16_t)rdp);
  default :
    err6809 = ERR_INVALID_EXGR;
    return 0;
  }
}

void setexr(int c, uint16_t r)
{
  switch(c) {
  case 0:
    ra = (uint8_t)(r >> 8);
    rb = (uint8_t)r;
    break;
  case 1:
    rx = r;
    break;
  case 2:
    ry = r;
    break;
  case 3:
    ru = r;
    break;
  case 4:
    rs = r;
    break;
  case 5:
    rpc = r;
    break;
  case 8:
    ra = (uint8_t)r;
    break;
  case 9:
    rb = (uint8_t)r;
    break;
  case 10:
    setcc((uint8_t)r);
    break;
  case 11:
    rdp = (uint8_t)r;
    break;
  default :
    err6809 = ERR_INVALID_EXGR;
  }
}

void do_psh(uint16_t *rp, uint16_t *rnp, uint8_t c)
{
  if (c & 0x80) {
    *rp -= 2;
    set_memw(*rp, rpc);
    nbcycle += 2;
  }
  if (c & 0x40) {
    *rp -= 2;
    set_memw(*rp, *rnp);
    nbcycle += 2;
  }
  if (c & 0x20) {
    *rp -= 2;
    set_memw(*rp, ry);
    nbcycle += 2;
  }
  if (c & 0x10) {
    *rp -= 2;
    set_memw(*rp, rx);
    nbcycle += 2;
  }
  if (c & 0x08) {
    *rp -= 1;
    set_memb(*rp, rdp);
    nbcycle += 1;
  }
  if (c & 0x04) {
    *rp -= 1;
    set_memb(*rp, rb);
    nbcycle += 1;
  }
  if (c & 0x02) {
    *rp -= 1;
    set_memb(*rp, ra);
    nbcycle += 1;
  }
  if (c & 0x01) {
    *rp -= 1;
    set_memb(*rp, getcc());
    nbcycle += 1;
  }
}

void do_pul(uint16_t *rp, uint16_t *rnp, uint8_t c)
{
  if (c & 0x01) {
    setcc(get_memb(*rp));
    *rp += 1;
    nbcycle += 1;
  }
  if (c & 0x02) {
    ra = get_memb(*rp);
    *rp += 1;
    nbcycle += 1;
  }
  if (c & 0x04) {
    rb = get_memb(*rp);
    *rp += 1;
    nbcycle += 1;
  }
  if (c & 0x08) {
    rdp = get_memb(*rp);
    *rp += 1;
    nbcycle += 1;
  }
  if (c & 0x10) {
    rx = get_memw(*rp);
    *rp += 2;
    nbcycle += 2;
  }
  if (c & 0x20) {
    ry = get_memw(*rp);
    *rp += 2;
    nbcycle += 2;
  }
  if (c & 0x40) {
    *rnp = get_memw(*rp);
    *rp += 2;
    nbcycle += 2;
  }
  if (c & 0x80) {
    rpc = get_memw(*rp);
    *rp += 2;
    nbcycle += 2;
  }
}

uint8_t get_i8()
{
  return(get_memb(rpc++));
}

uint16_t get_i16()
{
  uint16_t w = get_memw(rpc);

  rpc += 2;
  return(w);
}

void null()
{
  err6809 = ERR_INVALID_OPCODE;
}

uint16_t nula()
{
  err6809 = ERR_INVALID_ADDRMODE;
  return 0;
}

uint16_t immb()
{
  uint16_t v = rpc;

  rpc++;
  return(v);
}

uint16_t immw()
{
  uint16_t v = rpc;

  rpc += 2;
  return(v);
}

uint16_t dir()
{
  return(((uint16_t)rdp) << 8 | (uint16_t)get_i8());
}

uint16_t idx()
{
  uint8_t v = get_i8();
  uint16_t r, *pr;

  pr = regp[(v >> 5) & 0x3];

  if (!(v & 0x80)) {         /* n4,R */
    r = *pr + ext5(v);
    nbcycle += 1;
  } else {
    switch (v & 0x1f) {
    case 0x00:               /* ,R+ */
      r = *pr;
      (*pr)++;
      nbcycle += 2;
      break;
    case 0x01: case 0x11:    /* ,R++ */
      r = *pr;
      *pr += 2;
      nbcycle += 3;
      break;
    case 0x02:               /* ,-R */
      (*pr)--;
      r = *pr;
      nbcycle += 2;
      break;
    case 0x03: case 0x13:    /* ,--R */
      *pr -= 2;
      r = *pr;
      nbcycle += 3;
      break;
    case 0x04: case 0x14:    /* ,R */
      r = *pr;
      break;
    case 0x05: case 0x15:    /* B,R */
      r = *pr + ext8(rb);
      nbcycle += 1;
      break;
    case 0x06: case 0x16:
      r = *pr + ext8(ra);    /* A,R */
      nbcycle += 1;
      break;
    case 0x08: case 0x18:    /* n7,R */
      r = *pr + ext8(get_i8());
      nbcycle += 1;
      break;
    case 0x09: case 0x19:    /* n15,R */
      r = *pr + (int16_t)get_i16();
      nbcycle += 4;
      break;
    case 0x0b: case 0x1b:    /* D,R */
      r = *pr + (int16_t)rd();
      nbcycle += 4;
      break;
    case 0x0c: case 0x1c:    /* n7,PCR */
      r = rpc + ext8(get_i8());
      nbcycle += 1;
      break;
    case 0x0d: case 0x1d:    /* n15,PCR */
      r = rpc + (int16_t)get_i16();
      nbcycle += 5;
      break;
    case 0x1f:               /* [n] */
      r = get_i16();
      nbcycle += 2;
      break;
    default:
      err6809 = ERR_INVALID_POSTBYTE;
      r = 0;
      break;
    }
    if (v & 0x10) {          /* indirection */
      r = get_memw(r);
      nbcycle += 3;
    }
  }
  return r;
}

uint16_t ext()
{
  return(get_i16());
}

uint16_t relb()
{
  return(rpc + (int16_t)(int8_t)get_i8());
}

uint16_t relw()
{
  return(rpc + get_i16());
}

void pag2()
{
  int r = get_i8() + 0x100;

  nbcycle = cycle[r];
  addrmode = amod[r];
  (*(fonc[r]))();
}

void pag3()
{
  int r = get_i8() + 0x200;

  nbcycle = cycle[r];
  addrmode = amod[r];
  (*(fonc[r]))();
}
 
uint16_t rd()
{
  return((uint16_t)ra << 8 | (uint16_t)rb);
}

uint16_t get_eab()
{
  return((*eaddrmodb[addrmode])());
}

uint16_t get_eaw()
{
  return((*eaddrmodw[addrmode])());
}

void m6809_init()
{
  rpc = rx = ry = ru = rs = 0;
  last_rpc=-1;
  ra = rb = rdp = 0;
  setcc(0);
}

int m6809_execute()
{
  int r = get_i8();

  nbcycle = cycle[r];
  addrmode = amod[r];
  err6809 = 0;

#ifdef PC_HISTORY
  pchist[pchistidx++] = rpc - 1;
  if (pchistidx == PC_HISTORY_SIZE)
    pchistidx = 0;
  if (pchistnbr < PC_HISTORY_SIZE)
    pchistnbr++;
#endif

  (*(fonc[r]))();

  if (err6809)
    return err6809;
  else
    return nbcycle;
}

void m6809_dumpregs()
{
  printf("PC: %04hX  X: %04hX  Y: %04hX  U: %04hX  S: %04hX\n", rpc, rx, ry, ru, rs);
  printf(" A: %02X    B: %02X   DP: %02X   CC: %02X=%s\n", ra, rb, rdp, getcc(), ccstr(getcc()));
}



