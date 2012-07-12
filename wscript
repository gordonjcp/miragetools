#! /usr/bin/env python

# the following two variables are used by the target "waf dist"
VERSION='0'
APPNAME='miditerm'

# these variables are mandatory ('/' are converted automatically)
top = '.'
out = 'build'

def options(opt):
    opt.tool_options('compiler_cc')

def configure(conf):
    conf.check_tool('compiler_cc')
    conf.check(header_name='stdlib.h')
    conf.check(header_name='math.h')
    
    # set for debugging
    conf.env.CCFLAGS = ['-O0', '-g3']


    conf.check_cfg(package='gtk+-2.0', uselib_store='GTK', atleast_version='2.6.0', mandatory=True, args='--cflags --libs')
    conf.check_cfg(package = 'alsa', uselib_store='ALSA', atleast_version = '1.0.25', mandatory=True, args = '--cflags --libs')
    conf.check_cfg(package = 'vte', uselib_store='VTE', atleast_version = '0.28.0', mandatory=True, args = '--cflags --libs')
    
def build(bld):
    # the main program
    bld(
        features = 'c cprogram',
        source = ['midi.c', 'miditerm.c' ],
        target = 'miditerm',
        uselib = "GTK ALSA VTE",
        includes = '. /usr/include')

