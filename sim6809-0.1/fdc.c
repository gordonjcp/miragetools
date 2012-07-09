/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   fdc.c -- emulation of 1772 FDC
   Copyright (C) 2012 Gordon JC Pearce

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
#include <stdlib.h>
#include <unistd.h>

#include "config.h"
#include "fdc.h"
#include "emu6809.h"

/*
   quick technical rundown of the FDC in the Mirage
   DRQ is inverted and drives /IRQ
   INTRQ is inverted and drives /NMI
   So to read data we wait for an interrupt and loop until NMI
   At least, this is how the Mirage ROM does it
*/

static FILE *disk;
static tt_u8 *diskdata;
static long fdc_cycles;
static int s_byte;  // byte within sector

int a;

int fdc_init() {
	diskdata = malloc(80*5632);	// 440k disk image
	if (!diskdata) {
		fprintf(stderr, "Not enough memory to allocate disk data\n");
		abort();
	}
	
	disk = fopen("disk.img", "r");
	if (disk) {
		fread(diskdata, sizeof(char), 5632*80, disk);
		fclose(disk);
	} else {
		fprintf(stderr, "warning: couldn't read in disk image\n");
	}
	return 0;
}

void fdc_destroy() {
 	// free memory used by disk
	if (diskdata) free(diskdata);
}

void fdc_run() {
	// called every cycle
	if ((fdc.sr & 0x01) == 0) return;   // nothing to do
	if (cycles < fdc_cycles) return; // not ready yet
	
	switch (fdc.cr & 0xf0) {
		case 0x00:  // restore
			printf("fdc_run(): restore\n");
			fdc.trk_r = 0;
			fdc.sr = 0x04;  // track at 0
			nmi();
			return;
		case 0x10:  // restore
			printf("fdc_run(): seek\n");
			fdc.trk_r = fdc.data_r;
			fdc.sr = 0;
			if (fdc.trk_r == 0) fdc.sr |= 0x04;  // track at 0
			nmi();
			return;
		case 0x80:  // read sector
			//printf("fdc_run(): read sector %d\n", fdc.sec_r);
			a = s_byte+(1024*fdc.sec_r)+(5632*fdc.trk_r);
			//printf("s_byte=%04x trk=%d sec=%d disk addr = %04x\n",s_byte, fdc.trk_r, fdc.sec_r, a);

			fdc.data_r=diskdata[a];
			fdc.sr |= 0x02;
			s_byte++;
			fdc_cycles = cycles + 32;
			irq();
			
			if (s_byte>=(fdc.sec_r==5?512:1024)) {
				fdc.sr &= 0xfe;
				nmi();
			}
			return;
		default:
			printf("fdc_run(): unknown (%02x)\n", fdc.cr);
			fdc.sr = 0;
			break;
	}
	fdc.sr &= 0xfe;	// stop
}

tt_u8 fdc_rreg(int reg) {
	// handle reads from FDC registers
	tt_u8 val;

	switch (reg & 0x03) {   // not fully mapped
		case FDC_SR:
			val = fdc.sr;
			break;
		case FDC_TRACK:
			val = fdc.trk_r;
			break;
		case FDC_SECTOR:
			val =  fdc.sec_r;
			break;
		case FDC_DATA:
			fdc.sr &= 0xfd; // clear IRQ bit
			val =  fdc.data_r;
			break;
	}
	return val;
}

void fdc_wreg(int reg, tt_u8 val) {
	// handle writes to FDC registers
	int cmd = (val & 0xf0)>>4;
	
	switch (reg & 0x03) {  // not fully mapped
		case FDC_CR:

			if ((val & 0xf0) == 0xd0) { // force interrupt
				printf("cmd %02x: force interrupt\n", val);
				fdc.sr &= 0xfe; // clear busy bit
				return;
			}
			if (fdc.sr & 0x01) return;
			fdc.cr = val;
			switch(cmd) {
				case 0: // restore
					printf("%04x cmd %02x: restore\n", rpc, val);
					fdc_cycles = cycles + 1000000;   // slow
					fdc.sr = 0x01; // busy
					break;
				case 1:
					printf("cmd %02x: seek to %d\n", val, fdc.data_r);
					fdc_cycles = cycles + 1000000;
					fdc.sr = 0x01;
					break;
				case 8:
					printf("cmd %02x: read sector\n", val);
					fdc_cycles = cycles + 1000;
					s_byte = 0;
					fdc.sr = 0x01;
					break;
				default:
					printf("cmd %02x: unknown\n", val);
					fdc.sr = 0;
					fdc_cycles = 0;
					break;
			}
			break;
		case FDC_TRACK:
			printf("%04x track = %d\n",rpc,  val);
			fdc.trk_r = val;
			break;
		case FDC_SECTOR:
			printf("sector = %d\n", val);
			fdc.sec_r = val;
			break;
		case FDC_DATA:
			fdc.data_r = val;
			break;
	}
}
