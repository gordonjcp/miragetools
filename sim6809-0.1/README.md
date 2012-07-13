sim6809
=======

This is an enhancement of Jerome Thoen's [6809 emulator](http://membres.multimania.fr/jth/6809.html).  There was a modified version of it by [Tim Victor](http://www.gweep.net/~shifty/music/mirage.html) that included a certain amount of Mirage support.  From that I have used the Motorola S-record support.

See also the original README file for further information.

Requirements
-----------

Nothing special.
You may want a terminal emulator to connect to the "serial" port, such as gtkterm or screen.

Building and installing
---------------------

sim6809 uses a single Makefile.  To build:

    $ make
    
Using sim6809
------------

The Mirage-patched version of sim6809 looks for a file called "rom.bin" containing a boot ROM, and a disk image called "disk.img" which should be a bootable Mirage disk.  On startup it will create a pty and print the path to it, where you can attach a serial terminal emulator.

To start sim6809:

    $ ./sim6809 [optional .s19 file to load] [-r resets and starts the CPU]
    
Once sim6809 is running, you can get help by typing "h".  The commands are all mostly the same as "normal" sim6809, except "l" loads a Motorola S-record file and "z &lt;addr&gt;" resets the CPU and runs until the specified address.

Emulated hardware
---------------

The hardware emulation is very much a work-in-progress.  The current state is:

* RAM - emulated as a 64kByte block.  Bank switching is not implemented.
* ROM - loaded from "rom.bin" at startup. Cannot be written from 6809 software.
* ACIA - TDR and RDR implemented, CR implements interrupt flags only, SR implements INT, TDRE, RDRF
* VIA - not much implemented. Notably IRB forces the disk ready signal to always be active
* DOC - not really implemented, but can show registers being accessed
* FDC - partly implemented, sufficient to boot a disk image

TODO list
--------

* improve hardware support
* allow loading disk and rom images from command line and console
* support MIDI ports as well as /dev/pts



