---
title: Ensoniq Mirage Tools
layout: default
---

Ensoniq Mirage Tools
==================

Tools and documentation for hacking on the Ensoniq Mirage 8-bit sampler

There should be just about enough information in the README.md files to get you started.  You're going to need a PC running Linux that has a real genuine floppy drive (no USB ones, sorry) and a MIDI interface.  Other than that you'll need a working GCC and probably some libraries that I've forgotten to note down. Suffice it to say that if you can compile simple Gtk apps, you won't be far wrong.

Clone the repository, then go into miragetools/miditerm and and build it:

    $ ./waf configure
    $ ./waf

If all goes well you should be able to run MIDIterm with:

    $ ./build/miditerm

Use something like qjackctl to hook the ports up to your physical MIDI interface, remembering that "out" on MIDIterm needs to go to "in" on your interface.  If you hook the "out" and "in" connectors on your interface together (maybe using the "through" port on the Mirage) then when you type stuff into MIDIterm you should see it echoed back.

Make sure the Mirage is hooked up to the appropriate MIDI connectors on your interface.

Switch to the asm09 directory.  Build the assembler and disk writer, then build the Forth image:

    $ gcc as9.c -o as9
    $ gcc writeos.c -o writeos
    $ ./as9 forth.asm -nol

Get a blank formatted diskette (or format one, with the instructions in miragetools/asm09/README.md) and write the Forth image:

    $ ./writeos forth.s19

Boot from the disk and you should see the right hand digit of the LED showing a rotating pattern.

At this point, you are running what is probably the first wholly new software to be written for the Ensoniq Mirage, for something like 20 years.  Let that sink in for a moment.

Unfortunately the forth.asm source isn't hugely well-documented.  My own additions don't really help either.  Note that this version starts off with base set to 16 by default - this means that any numbers you type in or any it displays are hexadecimal.  This may be surprising for the unwary.

At the "ok>" prompt, type "vlist" and you should see it list off all the Forth words the environment knows.  You can read Dave Dunfield's [notes on his implementation](http://www.classiccmp.org/dunfield/d6809/d/forth.txt) on his website.

To make your Mirage make a noise, just to prove it can be done:

    ok> 18 e200 c! ( motor off, final VCA unmuted)
    ok> 50 e410 c! ( VCF 1 cutoff opened up somewhat)
    ok> ff e408 c! ( VCF 1 resonance up full)

You have just unmuted the audio (sample/play switch) and set the first VCF to
self-resonate.

Happy hacking!

@gordonjcp
