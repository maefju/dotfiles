# Pulling on a machine

One branch (`main`) for all machines. Machine-specific settings are picked by
hostname, not by branch.

| Hostname         | Machine                        |
|------------------|--------------------------------|
| `maefju-cachyos` | Gaming PC (NVIDIA)             |
| `matthias-sot`   | Work laptop (Intel + NVIDIA)   |

Per-machine settings live in:

- `files/.config/hypr/config/hosts/<hostname>.lua`: monitors, browser,
  software cursor, machine-specific autostart (loaded by `config/host.lua`)
- `files/.config/uwsm/env`: the `case "$(cat /etc/hostname)"` block (browser,
  NVIDIA GBM backend, SDL)

A machine without a host file gets neutral defaults.

## Every pull

```sh
cd ~/.dotfiles
git pull
git submodule update --init      # split-monitor-workspaces plugin
hyprctl reload && hyprctl configerrors
```

## One-time: first pull after the sot-laptop merge (gaming PC)

Do these **before** `git pull`:

1. **Back up fish universal variables.** `fish_variables` is no longer tracked,
   so the pull deletes it from disk:
   ```sh
   cp ~/.config/fish/fish_variables ~/fish_variables.bak
   ```

Then pull (see above), and afterwards:

2. **Restore fish variables.** Git ignores this file from now on:
   ```sh
   cp ~/fish_variables.bak ~/.config/fish/fish_variables
   ```
3. **Initialise the plugin submodule** if you skipped it:
   `git submodule update --init`. Without it, Hyprland shows a config error
   for `plugins.split-monitor-workspaces`.
4. **Regenerate Noctalia theme files.** The pull deletes the generated
   `noctalia.css`, `kitty/themes/noctalia.conf`, `btop` theme,
   `qt6ct/colors/noctalia.conf` and `hypr/noctalia.lua` (now gitignored).
   Change the wallpaper or theme once in Noctalia to rewrite them.
5. **Remove the old C++ plugin** if hyprpm still lists it:
   ```sh
   hyprpm list
   hyprpm remove split-monitor-workspaces
   # if that fails with "failed to remove dir":
   sudo rm -rf /var/cache/hyprpm/$USER
   ```
6. **Install the pacman hook** that keeps the plugin on the right release
   branch after Hyprland updates:
   ```sh
   sed "s/matthias/$USER/g" ~/.dotfiles/files/etc/pacman.d/hooks/hyprland-split-monitor-workspaces.hook \
     | sudo install -Dm644 /dev/stdin /etc/pacman.d/hooks/hyprland-split-monitor-workspaces.hook
   ```
7. **Remove the old polkit rule** if it exists. Noctalia no longer needs it:
   ```sh
   sudo rm -f /etc/polkit-1/rules.d/99-noctalia-greeter.rules && sudo systemctl restart polkit
   ```
8. **Check the default browser for links.** `mimeapps.list` is shared and no
   longer sets an http/https handler:
   ```sh
   xdg-mime query default x-scheme-handler/https
   ```
9. **Log out and back in** so the new `uwsm/env` takes effect.

## Adding a new machine

1. `cat /etc/hostname`
2. Copy a file in `files/.config/hypr/config/hosts/` to `<hostname>.lua` and
   adjust monitors (`hyprctl monitors`), browser and cursor settings.
3. Add a `<hostname>)` case to `files/.config/uwsm/env` if it needs its own
   environment.
4. Install the pacman hook (step 6 above).
