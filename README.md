# twilight-shell/bar

The bar of the [twilight-shell](https://github.com/twilight-shell) organization:
a row of floating sticker islands along the top of every screen. It works on its
own or as a piece of the full shell.

## Requirements

[Quickshell](https://quickshell.org) 0.3 or newer and
[twilight-shell/core](https://github.com/twilight-shell/core) installed.

## Running on its own

```sh
qs -p /path/to/bar
```

If `Twilight.Core` is not in a directory Qt searches, point `QML_IMPORT_PATH` at
its parent.

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
[clock]
hour24 = true      # false for AM/PM
seconds = false
```

The colors come from `~/.config/twilight-shell/theme.toml` (see
[core](https://github.com/twilight-shell/core)).

## License

MIT, see `LICENSE`.
