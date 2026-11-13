#!/usr/bin/env bash
# PreToolUse guard for the WorkerBee subagent.
#
# WorkerBee manages ~/working (notes, projects, its own memory) and often runs
# unattended (background dispatches, transcript harvests under
# --permission-mode acceptEdits). This hook keeps it inside its lane:
#
#   Write / Edit / MultiEdit / NotebookEdit
#       Allowed only when the real (symlink-resolved) target is inside
#       ~/working but not inside ~/working/repos -- except
#       ~/working/repos/dotfiles, which holds WorkerBee's own agents, skills,
#       hooks and templates (~/working/ai/{agents,skills,hooks,templates} are
#       symlinks into it). ~/working/repos may itself be a symlink (to ~/repos
#       on some hosts), so every path is compared after resolving symlinks.
#   Bash
#       Only date / ls / wc / pwd and read-only git (status, log, branch,
#       diff, show, rev-parse, optionally after `-C <path>`), with no shell
#       metacharacters, so a command can't chain or redirect into a write.
#   Anything else
#       Allowed.
#
# It is attached only to WorkerBee, through the `hooks:` block in its agent
# frontmatter. Main agents and other subagents are NOT restricted by it.
#
# Fails closed: if jq is missing or the input can't be parsed, writing and
# Bash calls are denied (and so is any call whose tool can't be identified).
#
# Deny = print a PreToolUse permissionDecision JSON and exit 0. Allow = print
# nothing and exit 0. Plain bash 3.2 compatible (macOS /bin/bash).

set -uo pipefail

WRITE_REASON='WorkerBee may write only inside ~/working (excluding ~/working/repos, except ~/working/repos/dotfiles).'
BASH_REASON="WorkerBee's Bash is limited to date/ls/wc/pwd and read-only git; use Read/Write/Edit/Glob/Grep"

have_jq=0
command -v jq >/dev/null 2>&1 && have_jq=1

deny() {
  if [ "$have_jq" = 1 ]; then
    jq -cn --arg r "$1" \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r}}'
  else # reasons are fixed strings with no characters that need JSON escaping
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  fi
  exit 0
}

input="$(cat)"

# ---------------------------------------------------------------- fail closed
# Without jq (or with unparseable input) we can't inspect the call. Allow only
# when every tool_name we can spot is an unguarded tool.
if [ "$have_jq" = 0 ] || ! jq -e 'type == "object" and (.tool_name | type == "string")' <<<"$input" >/dev/null 2>&1; then
  names=""
  [ "$have_jq" = 0 ] && names="$(printf '%s' "$input" |
    grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' |
    sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')"
  [ -n "$names" ] || deny "WorkerBee guard couldn't read the tool call (jq missing or bad input); denying to be safe."
  while IFS= read -r n; do
    case "$n" in Write | Edit | MultiEdit | NotebookEdit | Bash | "")
      deny "WorkerBee guard couldn't inspect this $n call (jq missing); denying to be safe." ;;
    esac
  done <<<"$names"
  exit 0
fi

field() { jq -r "$1 // empty" <<<"$input" 2>/dev/null; }
tool="$(field .tool_name)"

# ---------------------------------------------------------------- path resolution
# Prints the real path of $1 (absolute), resolving every symlink component,
# including the final one and symlinks whose targets don't exist yet. Works
# for paths whose tail doesn't exist (new files and directories). `..` is
# applied to the already-resolved prefix, so ~/working/repos/../x means the
# parent of the symlink's target, as the kernel would.
resolve() {
  local rest="${1#/}" cur="/" comp next t hops=0
  while [ -n "$rest" ]; do
    comp="${rest%%/*}"
    if [ "$comp" = "$rest" ]; then rest=""; else rest="${rest#*/}"; fi
    case "$comp" in
      "" | .) continue ;;
      ..) cur="$(dirname "$cur")"; continue ;;
    esac
    next="${cur%/}/$comp"
    if [ -d "$next" ]; then # existing dir (or symlink to one): let the kernel resolve it
      cur="$(cd -P "$next" 2>/dev/null && pwd -P)" || return 1
    elif [ -L "$next" ]; then # symlink to a file, or dangling: splice its target in
      hops=$((hops + 1))
      [ "$hops" -gt 40 ] && return 1
      t="$(readlink "$next")" || return 1
      case "$t" in /*) cur="/" ;; esac
      t="${t#/}"
      rest="$t${rest:+/$rest}"
    else # doesn't exist yet: nothing left to resolve at this level
      cur="$next"
    fi
  done
  printf '%s\n' "$cur"
}

under() { [ "$1" = "$2" ] || case "$1" in "$2"/*) return 0 ;; *) return 1 ;; esac; }

check_write() {
  local p cwd real rw rrepos rdot
  p="$(field '.tool_input.file_path // .tool_input.notebook_path')"
  [ -n "$p" ] || deny "$WRITE_REASON (no file path in the call)"
  [ -n "${HOME:-}" ] || deny "$WRITE_REASON (HOME is unset)"
  case "$p" in
    "~") p="$HOME" ;;
    "~/"*) p="$HOME/${p#\~/}" ;;
    "~"*) deny "$WRITE_REASON (~user paths aren't supported)" ;;
  esac
  case "$p" in
    /*) ;;
    *)
      cwd="$(field .cwd)"
      case "$cwd" in /*) ;; *) deny "$WRITE_REASON (relative path with no usable cwd)" ;; esac
      p="$cwd/$p"
      ;;
  esac
  real="$(resolve "$p")" || deny "$WRITE_REASON (couldn't resolve $p)"
  rw="$(resolve "$HOME/working")" || deny "$WRITE_REASON"
  rrepos="$(resolve "$HOME/working/repos")" || deny "$WRITE_REASON"
  rdot="$(resolve "$HOME/working/repos/dotfiles")" || deny "$WRITE_REASON"
  under "$real" "$rdot" && exit 0
  if under "$real" "$rw" && ! under "$real" "$rrepos"; then exit 0; fi
  deny "$WRITE_REASON Resolved target: $real"
}

check_bash() {
  local cmd nl=$'\n' cr=$'\r' sub i n has_list=0 a
  cmd="$(field .tool_input.command)"
  [ -n "$cmd" ] || deny "$BASH_REASON"
  case "$cmd" in
    *";"* | *"&"* | *"|"* | *">"* | *"<"* | *'`'* | *'$('* | *"$nl"* | *"$cr"*) deny "$BASH_REASON" ;;
  esac
  local -a w
  read -r -a w <<<"$cmd"
  n=${#w[@]}
  [ "$n" -gt 0 ] || deny "$BASH_REASON"
  case "${w[0]}" in
    date | ls | wc | pwd) exit 0 ;;
    git) ;;
    *) deny "$BASH_REASON" ;;
  esac
  i=1
  if [ "${w[1]:-}" = "-C" ]; then
    [ "$n" -ge 3 ] || deny "$BASH_REASON"
    i=3
  fi
  sub="${w[$i]:-}"
  case "$sub" in
    status | log | branch | diff | show | rev-parse) ;;
    *) deny "$BASH_REASON" ;;
  esac
  # Close the write paths these subcommands still have: --output=<file> on
  # log/diff/show, and creating/deleting/renaming branches.
  for ((a = i + 1; a < n; a++)); do
    case "${w[$a]}" in --output | --output=*) deny "$BASH_REASON" ;; esac
  done
  if [ "$sub" = "branch" ]; then
    for ((a = i + 1; a < n; a++)); do
      case "${w[$a]}" in --list | -l) has_list=1 ;; esac
    done
    for ((a = i + 1; a < n; a++)); do
      case "${w[$a]}" in
        --list | -l | -a | --all | -r | --remotes | -v | -vv | --verbose | --show-current | \
          --merged* | --no-merged* | --contains* | --no-contains* | --points-at* | \
          --sort=* | --format=* | --color* | --no-color | --column* | --no-column | -i | --ignore-case) ;;
        -*) deny "$BASH_REASON" ;;
        *) [ "$has_list" = 1 ] || deny "$BASH_REASON" ;; # bare name = create a branch
      esac
    done
  fi
  exit 0
}

case "$tool" in
  Write | Edit | MultiEdit | NotebookEdit) check_write ;;
  Bash) check_bash ;;
esac
exit 0
