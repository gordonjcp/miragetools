/* inst6809.c -- 6809 instructions
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

void abx()
{
  rx += rb;
}

#define adc8(reg) \
{ \
  tt_u16 v = (tt_u16)FETCHB; \
  tt_u16 r; \
 \
  r = (tt_u16)reg + v + ccc; \
  SET_NZVC8(reg,v,r); \
  SET_H(reg,v,r); \
  reg = (tt_u8)r; \
}              

void adca()
{
  adc8(ra);
}

void adcb()
{
  adc8(rb);
}

#define add8(reg) \
{ \
  tt_u16 v = (tt_u16)FETCHB; \
  tt_u16 r; \
 \
  r = (tt_u16)reg + v; \
  SET_NZVC8(reg,v,r); \
  SET_H(reg,v,r); \
  reg = (tt_u8)r; \
}

void adda()
{
  add8(ra);
}

void addb()
{
  add8(rb);
}

void addd()
{
  tt_u32 v = (tt_u32)FETCHW;
  tt_u32 r, d = GETRD;

  r = d + v;
  SET_NZVC16(d,v,r);
  SETRD(r);
}

#define and(reg) \
{ \
  reg &= FETCHB; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
}

void anda()
{
  and(ra);
}

void andb()
{
  and(rb);
}

void andc()
{
  setcc(getcc() & FETCHB);
}

#define asl8(reg) \
{ \
  ccc = btst(reg, 0x80); \
  reg <<= 1; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = ccn ^ ccc; \
}

void asla()
{
  asl8(ra);
}

void aslb()
{
  asl8(rb);
}

void asl()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  asl8(t);
  set_memb(a, t);
}

#define asr8(reg) \
{ \
  ccc = reg & 0x01; \
  reg = (reg & 0x80) | (reg >> 1); \
  SET_NZ8(reg); \
}

void asra()
{
  asr8(ra);
}

void asrb()
{
  asr8(rb);
}

void asr()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  asr8(t);
  set_memb(a, t);
}

#define bit8(reg) \
{ \
  tt_u8 r; \
 \
  r = reg & FETCHB; \
  SET_NZ8(r); \
  PUT_V; \
  ccv = 0; \
}

void bita()
{
  bit8(ra);
}

void bitb()
{
  bit8(rb);
}

#define clr8(reg) \
{ \
  reg = 0; \
  PUT_V; \
  ccn = ccv = ccc = 0; \
  ccz = 1; \
}

void clra()
{
  clr8(ra);
}

void clrb()
{
  clr8(rb);
}

void clr()
{
  set_memb(GET_EAB, 0);
  PUT_V;
  ccn = ccv = ccc = 0;
  ccz = 1;
}

#define cmp8(reg) \
{ \
  tt_u16 v = (tt_u16)FETCHB; \
  tt_u16 r; \
 \
  r = reg - v; \
  SET_NZVC8(reg,v,r); \
}

void cmpa()
{
  cmp8(ra);
}

void cmpb()
{
  cmp8(rb);
}

#define cmp16(reg) \
{ \
  tt_u32 v = (tt_u32)FETCHW; \
  tt_u32 r, d = (tt_u32)reg; \
 \
  r = d - v; \
  SET_NZVC16(d,v,r); \
}

void cmpd()
{
  cmp16(GETRD);
}

void cmps()
{
  cmp16(rs);
}

void cmpu()
{
  cmp16(ru);
}
  
void cmpx()
{
  cmp16(rx);
}


void cmpy()
{
  cmp16(ry);
}

#define com8(reg) \
{ \
  reg = ~reg; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
  ccc = 1; \
} 

void coma()
{
  com8(ra);
}

void comb()
{
  com8(rb);
}

void com()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  com8(t);
  set_memb(a, t);
}

void cwai()
{
  setcc((getcc() & get_i8()) | 0x80);
}

void daa()
{
  tt_u8 m, l;
  tt_u16 t, cf = 0;

  m = ra & 0xf0;
  l = ra & 0x0f;
  if (l > 0x09 || cch )
    cf |= 0x06;
  if (m > 0x80 && l > 0x09 )
    cf |= 0x60;
  if (m > 0x90 || ccc )
    cf |= 0x60;
  t = cf + ra;
  SET_NZ8((tt_u8)t);
  SET_C8(t);
  PUT_V;
  ccv = 0;
  ra = (tt_u8)t;
}

#define dec8(reg) \
{ \
  PUT_V; \
  ccv = (reg == 0x80); \
  reg--; \
  SET_NZ8(reg); \
}

void deca()
{
  dec8(ra);
}

void decb()
{
  dec8(rb);
}

void dec()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  dec8(t);
  set_memb(a, t);
}

#define eor8(reg) \
{ \
  reg ^= FETCHB; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
}

void eora()
{
  eor8(ra);
}

void eorb()
{
  eor8(rb);
}

void exg()
{
  tt_u8 c = get_i8();
  tt_u16 i;
  int c1, c2;

  c1 = c & 0x0f;
  c2 = c >> 4;

  i = getexr(c1);
  setexr(c1, getexr(c2));
  setexr(c2, i);
}

#define inc8(reg) \
{ \
  PUT_V; \
  ccv = (reg == 0x7f); \
  reg++; \
  SET_NZ8(reg); \
}

void inca()
{
  inc8(ra);
}

void incb()
{
  inc8(rb);
}

void inc()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  inc8(t);
  set_memb(a, t);
}

void jmp()
{
  rpc = GET_EAW;
}

void jsr()
{
  tt_u16 nrpc = GET_EAW;

  rs -= 2;
  set_memw(rs, rpc);
  rpc = nrpc;
}

#define ld8(reg) \
{ \
  reg = FETCHB; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
}

void lda()
{
  ld8(ra);
}

void ldb()
{
  ld8(rb);
}

#define ld16(reg) \
{ \
  reg = FETCHW; \
  SET_NZ16(reg); \
  PUT_V; \
  ccv = 0; \
}

void ldd()
{
  tt_u16 d;

  ld16(d);
  SETRD(d);
}

void lds()
{
  ld16(rs);
}

void ldu()
{
  ld16(ru);
}

void ldx()
{
  ld16(rx);
}

void ldy()
{
  ld16(ry);
}

void leas()
{
  rs = GET_EAW;
}

void leau()
{
  ru = GET_EAW;
}

void leax()
{
  rx = GET_EAW;
  SET_Z16(rx);
}

void leay()
{
  ry = GET_EAW;
  SET_Z16(ry);
}

#define lsr8(reg) \
{ \
  ccc = reg & 0x01; \
  reg >>= 1; \
  SET_Z8(reg); \
  ccn = 0; \
}

void lsra()
{
  lsr8(ra);
}

void lsrb()
{
  lsr8(rb);
}

void lsr()
{
  tt_u16 a = GET_EAB;
  tt_u8 v = get_memb(a);

  lsr8(v);
  set_memb(a, v);
}

void mul()
{
  tt_u16 r = (tt_u16)ra * (tt_u16)rb;

  SET_Z16(r);
  ccc = btst(rb, 0x80);
  SETRD(r);
}

#define neg8(reg) \
{ \
  tt_u16 r; \
 \
  r = -reg; \
  SET_NZVC8(0,reg,r); \
  reg = (tt_u8)r; \
}

void nega()
{
  neg8(ra);
}

void negb()
{
  neg8(rb);
}

void neg()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  neg8(t);
  set_memb(a, t);
}

void nop()
{
}

#define or8(reg) \
{ \
  reg |= FETCHB; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
}

void ora()
{
  or8(ra);
}

void orb()
{
  or8(rb);
}

void orcc()
{
  setcc(getcc() | FETCHB);
}

void pshs()
{
  do_psh(&rs, &ru, get_i8());
}

void pshu()
{
  do_psh(&ru, &rs, get_i8());
}

void puls()
{
  do_pul(&rs, &ru, get_i8());
}

void pulu()
{
  do_pul(&ru, &rs, get_i8());
}

#define rol8(reg) \
{ \
  tt_u8 r = reg << 1 | ccc; \
 \
  ccc = btst(reg, 0x80); \
  reg = r; \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = ccn ^ ccc; \
}

void rola()
{
  rol8(ra);
}

void rolb()
{
  rol8(rb);
}

void rol()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  rol8(t);
  set_memb(a, t);
}

#define ror8(reg) \
{ \
  tt_u8 r = reg >> 1 | ccc << 7; \
 \
  ccn = ccc; \
  ccc = reg & 0x01; \
  reg = r; \
  SET_Z8(reg); \
}

void rora()
{
  ror8(ra);
}

void rorb()
{
  ror8(rb);
}

void ror()
{
  tt_u16 a = GET_EAB;
  tt_u8 t = get_memb(a);

  ror8(t);
  set_memb(a, t);
}

void rti()
{
  do_pul(&rs, &ru, 0x01);
  if (!cce) {
    do_pul(&rs, &ru, 0x80);
    nbcycle = 6;
  } else {
    do_pul(&rs, &ru, 0xfe);
    nbcycle = 15;
  }
}

void rts()
{
  rpc = get_memw(rs);
  rs += 2;
}

#define sbc8(reg) \
{ \
  tt_u16 v = (tt_u16)FETCHB; \
  tt_u16 r; \
 \
  r = (tt_u16)reg - v - ccc; \
  SET_NZVC8(reg,v,r); \
  SET_H(reg,v,r); \
  reg = (tt_u8)r; \
}              

void sbca()
{
  sbc8(ra);
}

void sbcb()
{
  sbc8(rb);
}

void sex()
{
  SET_NZ8(rb);
  ra = ccn ? 0xff : 0x00;
}

#define st8(reg) \
{ \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
  set_memb(GET_EAB, reg); \
}

void sta()
{
  st8(ra);
}

void stb()
{
  st8(rb);
}

#define st16(reg) \
{ \
  SET_NZ16(reg); \
  PUT_V; \
  ccv = 0; \
  set_memw(GET_EAW, reg); \
}

void std()
{
  tt_u16 d = GETRD;

  st16(d);
}

void sts()
{
  st16(rs);
}

void stu()
{
  st16(ru);
}

void stx()
{
  st16(rx);
}

void sty()
{
  st16(ry);
}

#define sub8(reg) \
{ \
  tt_u16 v = (tt_u16)FETCHB; \
  tt_u16 r; \
 \
  r = (tt_u16)reg - v; \
  SET_NZVC8(reg,v,r); \
  SET_H(reg,v,r); \
  reg = (tt_u8)r; \
}

void suba()
{
  sub8(ra);
}

void subb()
{
  sub8(rb);
}

void subd()
{
  tt_u32 v = (tt_u32)FETCHW;
  tt_u32 r, d = GETRD;

  r = d - v;
  SET_NZVC16(d,v,r);
  SETRD(r);
}

void swi()
{
  cce = 1;
  do_psh(&rs, &ru, 0xff);
  cci = ccf = 1;
  /*
  rpc = get_memw(0xfffa);
  */
  err6809 = SYSTEM_CALL;
}

void swi2()
{
  cce = 1;
  do_psh(&rs, &ru, 0xff);
  rpc = get_memw(0xfff4);
}

void swi3()
{
  cce = 1;
  do_psh(&rs, &ru, 0xff);
  rpc = get_memw(0xfff2);
}

void syn()
{
}

void tfr()
{
  tt_u8 c = get_i8();

  setexr(c & 0x0f, getexr(c >> 4));
}

#define tst8(reg) \
{ \
  SET_NZ8(reg); \
  PUT_V; \
  ccv = 0; \
}

void tsta()
{
  tst8(ra);
}

void tstb()
{
  tst8(rb);
}

void tst()
{
  tt_u8 t = FETCHB;

  tst8(t);
}

void bcc()
{
  tt_u16 nrpc = GET_EAB;

  if (!ccc)
    rpc = nrpc;
}

void lbcc()
{
  tt_u16 nrpc = GET_EAW;

  if (!ccc) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bcs()
{
  tt_u16 nrpc = GET_EAB;

  if (ccc)
    rpc = nrpc;
}

void lbcs()
{
  tt_u16 nrpc = GET_EAW;

  if (ccc) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void beq()
{
  tt_u16 nrpc = GET_EAB;

  if (ccz)
    rpc = nrpc;
}

void lbeq()
{
  tt_u16 nrpc = GET_EAW;

  if (ccz) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bge()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (!(ccn ^ ccv))
    rpc = nrpc;
}

void lbge()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (!(ccn ^ ccv)) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bgt()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (!(ccz | (ccn ^ ccv)))
    rpc = nrpc;
}

void lbgt()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (!(ccz | (ccn ^ ccv))) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bhi()
{
  tt_u16 nrpc = GET_EAB;

  if (!(ccz | ccc))
    rpc = nrpc;
}

void lbhi()
{
  tt_u16 nrpc = GET_EAW;

  if (!(ccz | ccc)) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void ble()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (ccz | (ccn ^ ccv))
    rpc = nrpc;
}

void lble()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (ccz | (ccn ^ ccv)) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bls()
{
  tt_u16 nrpc = GET_EAB;

  if (ccc | ccz)
    rpc = nrpc;
}

void lbls()
{
  tt_u16 nrpc = GET_EAW;

  if (ccc | ccz) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void blt()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (ccn ^ ccv)
    rpc = nrpc;
}

void lblt()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (ccn ^ ccv) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bmi()
{
  tt_u16 nrpc = GET_EAB;

  if (ccn)
    rpc = nrpc;
}

void lbmi()
{
  tt_u16 nrpc = GET_EAW;

  if (ccn) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bne()
{
  tt_u16 nrpc = GET_EAB;

  if (!ccz)
    rpc = nrpc;
}

void lbne()
{
  tt_u16 nrpc = GET_EAW;

  if (!ccz) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bpl()
{
  tt_u16 nrpc = GET_EAB;

  if (!ccn)
    rpc = nrpc;
}

void lbpl()
{
  tt_u16 nrpc = GET_EAW;

  if (!ccn) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bra()
{
  rpc = GET_EAB;
}

void lbra()
{
  rpc = GET_EAW;
}

void brn()
{
  GET_EAB;
}

void lbrn()
{
  GET_EAW;
}

void bsr()
{
  rs -= 2;
  set_memw(rs, rpc+1);
  rpc = GET_EAB;
}

void lbsr()
{
  rs -= 2;
  set_memw(rs, rpc+2);
  rpc = GET_EAW;
}

void bvc()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (!ccv)
    rpc = nrpc;
}

void lbvc()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (!ccv) {
    rpc = nrpc;
    nbcycle += 1;
  }
}

void bvs()
{
  tt_u16 nrpc = GET_EAB;

  GET_V;
  if (ccv)
    rpc = nrpc;
}

void lbvs()
{
  tt_u16 nrpc = GET_EAW;

  GET_V;
  if (ccv) {
    rpc = nrpc;
    nbcycle += 1;
  }
}


