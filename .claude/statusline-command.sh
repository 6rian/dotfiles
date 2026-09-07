#!/bin/bash
# Claude Code status line: model name + context usage progress bar
#
# Managed in 6rian/dotfiles, symlinked into ~/.claude/statusline-command.sh
# by the Ansible `dotfiles` role (infra/ansible/roles/dotfiles in the
# cyberdelia.lab repo) -- edit here, not in place on a host.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

bar_width=20

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

  printf '\033[2m%s\033[0m \033[2m[%s]\033[0m \033[2m%s%%\033[0m' "$model" "$bar" "$used_int"
else
  printf '\033[2m%s\033[0m' "$model"
fi
