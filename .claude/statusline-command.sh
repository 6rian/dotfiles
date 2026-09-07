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

out="$model"

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

  out="$out [$bar] ${used_int}%"
fi

if [ -n "$cost" ]; then
  cost_fmt=$(printf '%.2f' "$cost")
  out="$out \$${cost_fmt}"
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
  out="$out ${dur_fmt}"
fi

printf '\033[2m%s\033[0m' "$out"
