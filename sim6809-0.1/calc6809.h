/* calc6809.h
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

int ccc, ccv, ccz, ccn, cci, cch, ccf, cce;

/* help to compute V bit */

#ifdef BIT_V_DELAYED
tt_u32 ccvx, ccvy, ccvz;
int ccvr, ccv8;

#define GET_V if (!ccvr) {ccvr=1; if (ccv8) { GET_V8;} else { GET_V16;}}
#define PUT_V {ccvr=1;}
#define GET_V8        {ccv = ((ccvx^ccvy^ccvz^(ccvz>>1))&0x80)>>7;}
#define GET_V16       {ccv = ((ccvx^ccvy^ccvz^(ccvz>>1))&0x8000)>>15;}
#else
#define GET_V ;
#define PUT_V ;
#endif

#define SET_Z8(a)     {ccz = !(tt_u8)(a);}
#define SET_Z16(a)    {ccz = !(tt_u16)(a);}
#define SET_N8(a)     {ccn = ((a)&0x80)>>7;}
#define SET_N16(a)    {ccn = ((a)&0x8000)>>15;}
#define SET_H(a,b,r)  {cch = (((a)^(b)^(r))&0x10)>>3;}
#define SET_C8(a)     {ccc = ((a)&0x100)>>8;}
#define SET_C16(a)    {ccc = ((a)&0x10000)>>16;}

#ifdef BIT_V_DELAYED
#define SET_V8(a,b,r)  {ccvx=a;ccvy=b;ccvz=r;ccv8=1;ccvr=0;}
#define SET_V16(a,b,r) {ccvx=a;ccvy=b;ccvz=r;ccv8=0;ccvr=0;}
#else
#define SET_V8(a,b,r)  {ccv = ((a^b^r^(r>>1))&0x80)>>7;}
#define SET_V16(a,b,r) {ccv = ((a^b^r^(r>>1))&0x8000)>>15;}
#endif

#define SET_NZ8(a)        {SET_N8(a);SET_Z8(a);}
#define SET_NZ16(a)       {SET_N16(a);SET_Z16(a);}
#define SET_NZVC8(a,b,r)  {SET_NZ8(r);SET_V8(a,b,r);SET_C8(r);}
#define SET_NZVC16(a,b,r)  {SET_NZ16(r);SET_V16(a,b,r);SET_C16(r);}

int addrmode;

tt_u16 (*eaddrmodb[])();
tt_u16 (*eaddrmodw[])();

#define GET_EAB (*eaddrmodb[addrmode])()
#define GET_EAW (*eaddrmodw[addrmode])()

#define FETCHB get_memb(GET_EAB)
#define FETCHW get_memw(GET_EAW)

#define GETRD    ((tt_u16)ra << 8 | (tt_u16)rb)
#define SETRD(d) {ra = (tt_u8)(d >> 8);rb = (tt_u8)d;}

#define ext5(v) (tt_s16)((v) & 0x10 ? (tt_u16)(v) | 0xffe0 : (tt_u16)(v) & 0x000f)

#define ext8(v) (tt_s16)(tt_s8)(v)




