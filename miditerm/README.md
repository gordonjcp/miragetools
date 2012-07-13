MIDIterm
=======

This is a very simple (perhaps too simple) terminal emulator to communicate with the Mirage running Forth.  When run, it will provide an ALSA sequencer input and output, that can be patched to a physical MIDI interface.  ALSA is smart enough to "sensibly" merge MIDI messages so in theory you could patch a controller keyboard and MIDIterm to the Mirage.

Requirements
-----------
* libvte
* ALSA

From Ubuntu you should probably be able to get away with:

    $ sudo apt-get install libvte-dev libasound2-dev
    

Building and installing
--------------------

MIDIterm uses [waf](http://code.google.com/p/waf/) for building.  From the miditerm directory, type:

    $ ./waf configure
    $ ./waf

Using MIDIterm
-------------

There isn't a lot to it.  Start MIDIterm with ./build/miditerm and connect the ports it creates to your MIDI interface.  There really needs to be a built-in facility to connect the ports.  Patches are welcome.  For now, I use qjackctl's patchbay facility.

What it does
-----------

Some USB MIDI interfaces have trouble sending "raw" bytes, preferring to see a properly-formatted MIDI message before they will pass it to or from the host PC.  MIDIterm sends each keystroke as a MIDI Timecode Quarter-Frame message and interprets these as incoming characters to be displayed, which keeps the interface happy.  This slows down transmission by 50% but does mean that it will work reliably with even the pickiest of interfaces.

A useful side-effect of this is that it should be possible to interpret the MIDI stream in the Mirage in such a way that "normal" MIDI messages can be interpreted without disrupting the console traffic.  It would also be possible to send "out-of-band" commands to the Forth stack, such as a reset command to make the Mirage reboot.

TODO list
--------

* Add port autoconnect features
* reset/reboot commands
