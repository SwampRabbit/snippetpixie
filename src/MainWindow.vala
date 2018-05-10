/*
* Copyright (c) 2018 Byte Pixie Limited (https://www.bytepixie.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class SnippetPixie.MainWindow : Gtk.ApplicationWindow {
    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_ADD = "action_add";
    public const string ACTION_EDIT = "action_edit";
    public const string ACTION_DELETE = "action_delete";
    public const string ACTION_IMPORT = "action_import";
    public const string ACTION_EXPORT = "action_export";
    public const string ACTION_PREFS = "action_prefs";

    private const ActionEntry[] action_entries = {
        { ACTION_ADD, action_add },
//        { ACTION_EDIT, action_edit, null, 0 },
//        { ACTION_DELETE, action_delete, null, 0 },
        { ACTION_IMPORT, action_import },
        { ACTION_EXPORT, action_export }
    };

    private Settings settings;
    private MainWindowHeader headerbar;
    private ViewStack main_view;

    private Gee.Collection<Snippet> snippets;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            height_request: 600,
            icon_name: "com.bytepixie.snippet-pixie",
            resizable: true,
            title: _("Snippet Pixie"),
            width_request: 800
        );
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (action_entries, this);
        insert_action_group ("win", actions);

        settings = new Settings ("com.bytepixie.snippet-pixie");

        var window_x = settings.get_int ("window-x");
        var window_y = settings.get_int ("window-y");
        var window_width = settings.get_int ("window-width");
        var window_height = settings.get_int ("window-height");

        if (window_x != -1 ||  window_y != -1) {
            this.move (window_x, window_y);
        }

        if (window_width != -1 ||  window_width != -1) {
            this.set_default_size (window_width, window_height);
        }

        // Construct window's components.
        main_view = new ViewStack ();
        main_view.request_snippets.connect (request_snippets);
        this.add (main_view);

        headerbar = new MainWindowHeader ();
        this.set_titlebar (headerbar);

        // TODO: Depending on whether there are snippets or not, might set "snippets" visible.
        main_view.visible_child_name = "welcome";
        main_view.init ();
    }

    private void action_add () {
        main_view.visible_child_name = "snippets";
    }

    private void action_import () {
        main_view.visible_child_name = "welcome";
    }

    private void action_export () {
        main_view.visible_child_name = "snippets";
    }

    private Gee.Collection<Snippet> request_snippets () {
        snippets = new Gee.ArrayList<Snippet> ();

        var snippet = new Snippet (1);
        snippets.add (snippet);

        snippet = new Snippet (2);
        snippet.abbreviation = "@b`";
        snippet.body = "hello@bytepixie.com";
        snippets.add (snippet);

        snippet = new Snippet (3);
        snippet.abbreviation = "sp`";
        snippet.body = "Snippet Pixie";
        snippets.add (snippet);

        snippet = new Snippet (4);
        snippet.abbreviation = "spu`";
        snippet.body = "https://www.snippetpixie.com";
        snippets.add (snippet);

        return snippets;
    }
}
