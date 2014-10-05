/* vim: set noexpandtab ai ts=4 sw=4 tw=0:
   miditerm.c -- MIDI-connected terminal, for Mirage Forth
   Copyright (C) 2012 Gordon JC Pearce <gordon@gjcp.net>
   somewhat based on tinyterm.c by Sebastian Linke

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

#include <vte/vte.h>
#include "miditerm.h"

int main (int argc, char *argv[]) {

    GtkWidget *window, *scrollbar, *hbox;
	GtkWidget *vbox, *menubar, *filemenu, *file, *reset, *quit;
    gtk_init (&argc, &argv);

	// window widgets
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "MIDIterm");
    terminal = vte_terminal_new();
    scrollbar = gtk_vscrollbar_new(VTE_TERMINAL (terminal)->adjustment);
    hbox = gtk_hbox_new(FALSE, 0);
    gtk_box_pack_start(GTK_BOX (hbox), terminal, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX (hbox), scrollbar, FALSE, FALSE, 0);

	// menu bar
	vbox = gtk_vbox_new(FALSE, 0);
	gtk_container_add(GTK_CONTAINER(window), vbox);

	menubar = gtk_menu_bar_new();
	filemenu = gtk_menu_new();
	quit = gtk_menu_item_new_with_label("Quit");
	reset = gtk_menu_item_new_with_label("Send MIDI Reset");
	file = gtk_menu_item_new_with_label("File");
	gtk_menu_shell_append(GTK_MENU_SHELL(filemenu), reset);
	gtk_menu_shell_append(GTK_MENU_SHELL(filemenu), quit);
	
	gtk_menu_item_set_submenu(GTK_MENU_ITEM(file), filemenu);
	gtk_menu_shell_append(GTK_MENU_SHELL(menubar), file);

	// put it all together
	gtk_box_pack_start(GTK_BOX(vbox), menubar, FALSE, FALSE, 0);
	gtk_box_pack_start(GTK_BOX(vbox), hbox, TRUE, TRUE, 0);

    g_signal_connect(window, "delete-event", gtk_main_quit, NULL);
    g_signal_connect(terminal, "child-exited", gtk_main_quit, NULL);
    g_signal_connect_after(GTK_OBJECT(terminal), "commit", G_CALLBACK(term_in), NULL);
	g_signal_connect_swapped(quit, "activate", gtk_main_quit, NULL);
	g_signal_connect_swapped(reset, "activate", send_reset, NULL);
    
    gtk_widget_show_all(window);
    alsa_init();
    
    gtk_main ();
    alsa_destroy();
}
