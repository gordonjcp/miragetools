/* config.h -- Configuration file
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

/* 
 * You MUST define theses data types
 */

/*
 * Define here your 8 bits types
 *
 */
typedef unsigned char tt_u8;
typedef signed char tt_s8;

/*
 * Define here your 16 bits types 
 *
 */
typedef unsigned short tt_u16;
typedef signed short tt_s16;

/*
 * Define here your 32 bits types
 *
 */
typedef unsigned long tt_u32;
typedef signed long tt_s32;

/*
 * define to keep a PC history in debugger
 */
#define PC_HISTORY

/*
 * define size of PC buffer
 * must be defined only if PC_HISTORY is defined
 */
#define PC_HISTORY_SIZE 20

/*
 * define to compute CC V bit only when required
 */
#define BIT_V_DELAYED
