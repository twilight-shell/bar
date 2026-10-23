# twilight-shell/bar

The bar of the [twilight-shell](https://github.com/twilight-shell) organization:
a row of floating sticker islands along the top of every screen: workspaces, the
focused window, the clock, the keyboard layout, the tray, the volume and the
launcher button. It works
on its own or as a piece of the full shell.

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
    launcherOpen: launcher.opened
    onPopoutRequested: name => popouts.toggle(name)
    onLauncherRequested: launcher.toggle()
}
```

The bar doesn't know the other components: what is open elsewhere comes in as
properties and what the user asks for goes out as signals. On its own the clicks
simply do nothing.

| | |
|---|---|
| `activePopout` | Which card dropped from the bar is open: `""`, `"calendar"` or `"sound"`. The island that opened it stays lit. |
| `launcherOpen` | Whether the launcher is open; the launcher button stays lit. |
| `popoutRequested(name)` | A click on the clock (`"calendar"`) or the volume (`"sound"`). |
| `launcherRequested()` | A click on the launcher button. |
| `settingsRequested()` | A right click on the launcher button. |

## Settings

`~/.config/twilight-shell/bar.toml`, created with the defaults the first time the
bar starts and applied as soon as it is saved:

```toml
# The focused window's icon and title next to the workspaces.
window-title = true

[clock]
# false for AM/PM
hour24 = true
seconds = false
```

The colors come from `~/.config/twilight-shell/theme.toml` (see
[core](https://github.com/twilight-shell/core)).

## License

MIT, see `LICENSE`.
