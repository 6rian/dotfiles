#!/bin/bash
# Claude Code status line: model name + context usage progress bar + session cost/duration
#
# Managed in 6rian/dotfiles, symlinked into ~/.claude/statusline-command.sh
# by the Ansible `dotfiles` role (infra/ansible/roles/dotfiles in the
# cyberdelia.lab repo) -- edit here, not in place on a host.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')

bar_width=20

# Dim variants of each color so segments stay legible against a dimmed
# status line while still standing apart from one another.
RESET='\033[0m'
CYAN='\033[2;36m'
GREEN='\033[2;32m'
YELLOW='\033[2;33m'
RED='\033[2;31m'
BLUE='\033[2;34m'
MAGENTA='\033[2;35m'
DIM_SEP='\033[2m'

segments=()

segments+=("$(printf "${CYAN}\xf0\x9f\xa4\x96 %s${RESET}" "$model")")

if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  [ "$used_int" -lt 0 ] && used_int=0
  [ "$used_int" -gt 100 ] && used_int=100

  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))

  bar=""
  i=0
  while [ "$i" -lt "$filled" ]; do bar="${bar}#"; i=$((i + 1)); done
  i=0
  while [ "$i" -lt "$empty" ]; do bar="${bar}-"; i=$((i + 1)); done

  if [ "$used_int" -ge 80 ]; then
    ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi

  segments+=("$(printf "${ctx_color}\xf0\x9f\xa7\xa0 [%s] %s%%${RESET}" "$bar" "$used_int")")
fi

if [ -n "$cost" ]; then
  cost_fmt=$(printf '%.2f' "$cost")
  segments+=("$(printf "${MAGENTA}\xf0\x9f\x92\xb0 \$%s${RESET}" "$cost_fmt")")
fi

if [ -n "$duration_ms" ]; then
  duration_s=$(( ${duration_ms%.*} / 1000 ))
  d_h=$(( duration_s / 3600 ))
  d_m=$(( (duration_s % 3600) / 60 ))
  d_s=$(( duration_s % 60 ))
  if [ "$d_h" -gt 0 ]; then
    dur_fmt=$(printf '%dh%dm' "$d_h" "$d_m")
  elif [ "$d_m" -gt 0 ]; then
    dur_fmt=$(printf '%dm%ds' "$d_m" "$d_s")
  else
    dur_fmt=$(printf '%ds' "$d_s")
  fi
  segments+=("$(printf "${BLUE}\xe2\x8f\xb1\xef\xb8\x8f  %s${RESET}" "$dur_fmt")")
fi

out=""
for i in "${!segments[@]}"; do
  if [ "$i" -gt 0 ]; then
    out="${out}$(printf "${DIM_SEP} \xc2\xb7 ${RESET}")"
  fi
  out="${out}${segments[$i]}"
done

printf '%s' "$out"
