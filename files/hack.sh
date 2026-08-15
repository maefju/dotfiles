#!/usr/bin/env bash
set -euo pipefail

# Animated ASCII art for "NIX"
# Usage: ./nix-animate.sh [cycles]

cycles="${1:-8}"
if ! [[ "$cycles" =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 [cycles]"
  exit 1
fi

# Hide cursor and restore terminal state on exit.
cleanup() {
  tput cnorm 2>/dev/null || true
  tput sgr0 2>/dev/null || true
  printf '\n'
}
trap cleanup EXIT INT TERM

tput civis 2>/dev/null || true

frame_a='N       N   IIIII   X     X
NN      N     I      X   X
N N     N     I       X X
N  N    N     I        X
N   N   N     I       X X
N    N  N     I      X   X
N     N N   IIIII   X     X'

frame_b='N\\      N   IIIII   XX   XX
N \\     N     I       X X
N  \\    N     I        X
N   \\   N     I       X X
N    \\  N     I      X   X
N     \\ N     I     X     X
N      \\N   IIIII   XX   XX'

frame_c='N*****  N   IIIII   X     X
N*   *  N     I      X   X
N *  *  N     I       X X
N  * *  N     I        X
N   **  N     I       X X
N    *  N     I      X   X
N     * N   IIIII   X     X'

for ((i = 0; i < cycles; i++)); do
  for frame in "$frame_a" "$frame_b" "$frame_c"; do
    tput cup 0 0 2>/dev/null || printf '\033[H'
    tput setaf "$((1 + (i % 6)))" 2>/dev/null || true
    printf '%b\n' "$frame"
    tput sgr0 2>/dev/null || true
    printf '\n   N I X\n'
    sleep 0.12
  done
done
