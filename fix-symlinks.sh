#!/usr/bin/env bash
set -euo pipefail

# Repoint symlinks in ~/.config that target ~/.mydotfiles/files/.config
# so they instead target ~/.dotfiles/files/.config.

old_prefix="$HOME/.mydotfiles/com.ml4w.dotfiles.stable/.config"
new_prefix="$HOME/.dotfiles/files/.config"
config_dir="$HOME/.config"

if [[ ! -d "$new_prefix" ]]; then
  echo "New target base does not exist: $new_prefix" >&2
  exit 1
fi

dry_run=0
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=1
fi

count=0
while IFS= read -r -d '' link; do
  target="$(readlink "$link")"

  # Resolve target relative to the symlink's directory if not absolute.
  if [[ "$target" != /* ]]; then
    target="$(cd "$(dirname "$link")" && cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")" || continue
  fi

  case "$target" in
    "$old_prefix"/*)
      suffix="${target#"$old_prefix"/}"
      new_target="$new_prefix/$suffix"
      if [[ ! -e "$new_target" ]]; then
        echo "Skipping (no matching path): $link -> $new_target does not exist" >&2
        continue
      fi
      echo "Relinking: $link"
      echo "  old: $target"
      echo "  new: $new_target"
      if [[ "$dry_run" -eq 0 ]]; then
        ln -sfn "$new_target" "$link"
      fi
      count=$((count + 1))
      ;;
  esac
done < <(find "$config_dir" -type l -print0)

echo "Done. ${count} symlink(s) $([[ "$dry_run" -eq 1 ]] && echo "would be" || echo "were") updated."
