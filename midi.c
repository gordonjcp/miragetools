/* vim: set noexpandtab ai ts=4 sw=4 tw=4:
   midi.c -- MIDI-connected terminal, for Mirage Forth
   Copyright (C) 2012 Gordon JC Pearce <gordon@gjcp.net>
   somewhat based on gmidimon by Nedko Arnaudov <nedko@arnaudov.name>

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

#include <glib.h>
#include <alsa/asoundlib.h>
#include "miditerm.h"

snd_seq_t * g_seq_ptr;
pthread_t g_alsa_midi_tid;

void *alsa_midi_thread(void * context_ptr) {
	snd_seq_event_t * event_ptr;
	unsigned char buf;

	while (snd_seq_event_input(g_seq_ptr, &event_ptr) >= 0) {
		if (event_ptr->type == SND_SEQ_EVENT_QFRAME) {
			buf=event_ptr->data.control.value;
			vte_terminal_feed(VTE_TERMINAL(terminal),  &buf, 1);
		}
	}
}

gboolean alsa_init() {
	int ret;
	snd_seq_port_info_t * port_info = NULL;

	ret = snd_seq_open(&g_seq_ptr, "default", SND_SEQ_OPEN_INPUT, 0);
	if (ret < 0) {
		g_warning("Cannot open sequncer, %s\n", snd_strerror(ret));
		goto fail;
	}

	//  snd_seq_set_client_name(g_seq_ptr, name);
	snd_seq_port_info_alloca(&port_info);

	snd_seq_port_info_set_capability(port_info, SND_SEQ_PORT_CAP_WRITE | SND_SEQ_PORT_CAP_SUBS_WRITE);
	snd_seq_port_info_set_type(port_info, SND_SEQ_PORT_TYPE_APPLICATION);
	snd_seq_port_info_set_midi_channels(port_info, 1);
	snd_seq_port_info_set_port_specified(port_info, 1);

	snd_seq_port_info_set_name(port_info, "midi in");
	snd_seq_port_info_set_port(port_info, 0);

	ret = snd_seq_create_port(g_seq_ptr, port_info);
	if (ret < 0) {
	    g_warning("Error creating ALSA sequencer port, %s\n", snd_strerror(ret));
		goto fail_close_seq;
	}

	ret = pthread_create(&g_alsa_midi_tid, NULL, alsa_midi_thread, NULL);
	return TRUE;

	fail_close_seq:
	ret = snd_seq_close(g_seq_ptr);
	if (ret < 0) {
		g_warning("Cannot close sequncer, %s\n", snd_strerror(ret));
	}

fail:
	return FALSE;
}
