/*  vim: set noexpandtab ai ts=4 sw=4 tw=4:

    miragedisk, part of a set of disk tools for the Ensoniq Mirage
	(C) 2012 Gordon JC Pearce MM0YEQ <gordon@gjcp.net>
	
	format.c
	Floppy disk ioctl routines
	Format a blank Mirage disk

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

#include <linux/fd.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <linux/fdreg.h>

#include "disk.h"

// will need some code to:
// assemble up a single "raw format" sector
// assemble those up into a raw track
// write that track
// optionally verify the track
// write sectors to the directory entries
// write "blank" parameter blocks, or possibly a simple tone
// can we write and format?
// blank parameter and sequence sectors

