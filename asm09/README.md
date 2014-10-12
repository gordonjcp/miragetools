asm09
=====

This is an assembler based on Motorola's freeware 6809 assembler from their dialup BBS.  For more information, read the accompanying README file which was shipped with the original package that I downloaded from [this 6809 emulation page](http://koti.mbnet.fi/~atjs/mc6809/).

The original file is available [from that page](http://koti.mbnet.fi/~atjs/mc6809/Assembler/asm09.tgz) but requires one or two fixes to work in "modern" gcc.

You can copy the file asm6809.vim to your vim syntax highlighting directory (on Ubuntu 14.04 and no doubt others, this is /usr/share/vim/vim74/syntax) to get correct syntax highlighting.  Thanks to David Roper for the file, found on github:

https://gist.github.com/ebonhand09/1190963


Requirements
-----------

Nothing special.

Building and installing
---------------------

Build the assembler with:

    $ gcc as9.c -o as9
    
These need to be adapted to use waf.

Using asm09
----------

There aren't many options.  This version of asm09 has different command-line switches, which can be seen by typing in "./as9" on its own.  When handling multiple input files, the first one sets the name of the object file unless it is overwritten with the -o switch. 

    $ ./as9 forth.asm      # assembles forth.asm
    $ ./as9 forth.asm -l   # same, but outputs the listing to stdout
    
There are a couple of enhancements to as9 in this version.  Most notably, the line parser has been modified to accept both \r and \n as signifying the end of a line.  The fcc pseudo-op has now got a counterpart fccz which constructs a zero-terminated string.
    
Writing to disk
-------------

Ensure that your user has permission to write to the floppy drive.  On Ubuntu, by default the drive is owned by root, group owned by floppy and set to be writable by owner and group.  You can either change the permissions on /dev/fd0 or add yourself to the floppy group then log out and log back in.

To write the assembled OS to a disk, you'll need a blank formatted diskette.  You can format one on the Mirage, or you can format one with [superformat](http://www.fdutils.linux.lu/) like this:

    $ superformat /dev/fd0 tracksize=11b mss ss ssize=1024 dd --zero-based
    
Although this lays down a low-level format, the sectors are invalid until they have been written to.  So, let's use miragetool to put an OS on the disk:

    $ miragetool --put-os forth.s19
    
Note that miragetool will treat files ending in ".s19" as Motorola S-Record files, but otherwise deals with raw binary images.

TODO list
--------

* waf-ify asm09 
* bugfixes for asm09
