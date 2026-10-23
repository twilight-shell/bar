# twilight-shell/bar

The bar of the [twilight-shell](https://github.com/twilight-shell) organization:
a row of floating sticker islands along the top of every screen: workspaces, the
focused window, the clock and the keyboard layout. It works on its own or as a
piece of the full shell.

## Requirements

[Quickshell](https://quickshell.org) 0.3 or newer, with
[twilight-shell/core](https://github.com/twilight-shell/core) and
[twilight-shell/compositor](https://github.com/twilight-shell/compositor)
installed. The compositor module gives it the workspaces, the focused window and
the keyboard layout; under a compositor it doesn't know, the bar still starts,
just without them.

## Running on its own

```sh
qs -p /path/to/bar
```

If `Twilight.Core` or `Twilight.Compositor` are not in a directory Qt searches,
point `QML_IMPORT_PATH` at their parent directories, separated by `:`.

## Using it in a shell

```sh
sudo make install        # to /usr/lib/qt6/qml/Twilight/Bar
```

```qml
import Twilight.Bar

Bar {
    activePopout: popouts.current            // lights the island that opened it
    onPopoutRequested: name => popouts.toggle(name)
}
```

The bar doesn't know the other components: what is open elsewhere comes in as
properties and what the user asks for goes out as signals. On its own the clicks
simply do nothing.

## Settings

`~/.config/twilight-shell/bar.toml`, applied as soon as it is saved:

```toml
window-title = true   # the focused window's icon and title next to the workspaces

[clock]
hour24 = true      # false for AM/PM
seconds = false
```

The colors come from `~/.config/twilight-shell/theme.toml` (see
[core](https://github.com/twilight-shell/core)).

## License

MIT, see `LICENSE`.
