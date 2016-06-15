/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   miditerm.h -- MIDI-connected terminal, for Mirage Forth
   Copyright (C) 2012 Gordon JC Pearce <gordon@gjcp.net>

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

#ifndef __MIDITERM_H
#define __MIDITERM_H

#include <vte/vte.h>

GtkWidget *terminal;
void term_in(VteTerminal *terminal, gchar *text, guint length, gpointer ptr);
void send_reset();
gboolean alsa_init();
void alsa_destroy();

#endif
