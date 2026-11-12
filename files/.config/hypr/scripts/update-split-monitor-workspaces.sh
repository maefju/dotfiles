#!/usr/bin/env bash
# Switch the split-monitor-workspaces submodule to the release branch that
# matches the installed Hyprland version (e.g. 0.57.x -> release/0.57.x).
#
# Runs automatically from the pacman hook
#   /etc/pacman.d/hooks/hyprland-split-monitor-workspaces.hook
# and can also be run by hand. Optional argument: a Hyprland version to use
# instead of the installed one, e.g. `update-split-monitor-workspaces.sh 0.58.0`.
set -euo pipefail

repo_url="https://github.com/zjeffer/split-monitor-workspaces"
script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
plugin_dir="$(readlink -f "$script_dir/../plugins/split-monitor-workspaces")"
dotfiles_dir="$(git -C "$plugin_dir/.." rev-parse --show-toplevel)"
submodule_path="${plugin_dir#"$dotfiles_dir"/}"

# When started via runuser from the pacman hook, HOME may still be /root.
HOME="$(getent passwd "$(id -un)" | cut -d: -f6)"
export HOME

log() { printf '[split-monitor-workspaces] %s\n' "$*"; }

if [[ $EUID -eq 0 ]]; then
  log "refusing to run as root; run it as your user" >&2
  exit 1
fi

version="${1:-$(pacman -Q hyprland 2>/dev/null | awk '{print $2}' || true)}"
if [[ -z "$version" ]]; then
  version="$(Hyprland --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
fi
if [[ ! "$version" =~ ^([0-9]+)\.([0-9]+) ]]; then
  log "could not determine Hyprland version (got '$version')" >&2
  exit 1
fi
major_minor="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
branch="release/${major_minor}.x"

if ! git ls-remote --exit-code --heads "$repo_url" "$branch" >/dev/null; then
  log "no upstream branch '$branch' yet; falling back to 'main'."
  log "check $repo_url later or open an issue there."
  branch="main"
fi

if [[ ! -e "$plugin_dir/.git" ]]; then
  log "submodule not initialised, cloning..."
  git -C "$dotfiles_dir" submodule update --init -- "$submodule_path"
fi

if [[ -n "$(git -C "$plugin_dir" status --porcelain)" ]]; then
  log "local changes in $plugin_dir, not touching it:" >&2
  git -C "$plugin_dir" status --short >&2
  exit 1
fi

old_rev="$(git -C "$plugin_dir" rev-parse --short HEAD)"
git -C "$plugin_dir" fetch --quiet origin "+refs/heads/$branch:refs/remotes/origin/$branch"
git -C "$plugin_dir" checkout --quiet -B "$branch" "origin/$branch"
git -C "$plugin_dir" branch --quiet --set-upstream-to="origin/$branch" "$branch"
new_rev="$(git -C "$plugin_dir" rev-parse --short HEAD)"

# Record the tracked branch in .gitmodules so `git submodule update --remote` agrees.
git -C "$dotfiles_dir" config -f .gitmodules "submodule.$submodule_path.branch" "$branch"

if [[ "$old_rev" == "$new_rev" ]]; then
  log "Hyprland $version: already on $branch ($new_rev)."
else
  log "Hyprland $version: switched to $branch ($old_rev -> $new_rev)."
  log "commit the submodule bump in $dotfiles_dir when you're happy with it."
fi
log "log out and back in (or run 'hyprctl reload' once the new Hyprland is running)."
