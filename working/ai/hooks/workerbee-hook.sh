#!/usr/bin/env bash
# WorkerBee automation, wired up in .claude/settings.json.
#
#   workerbee-hook.sh session-start   SessionStart: inject today's Now line; trigger
#                                     morning-update once a day. (The protocol itself
#                                     lives in ~/.claude/CLAUDE.md.)
#   workerbee-hook.sh prompt          UserPromptSubmit: every Nth prompt, remind the
#                                     main agent to hand new facts to WorkerBee.
#   workerbee-hook.sh pre-compact     PreCompact / SessionEnd: hand the transcript to
#   workerbee-hook.sh session-end     a fully detached harvest worker (below), so
#                                     nothing is lost when context goes away.
#   workerbee-hook.sh harvest-worker  internal: runs detached, never from settings.json.
#
# Env knobs:
#   WORKERBEE_OFF=1               disable everything
#   WORKERBEE_HARVEST=0           disable transcript harvesting
#   WORKERBEE_CHECKPOINT_EVERY=N  prompts between checkpoint reminders (default 15)
#   WORKERBEE_HEADLESS=1          set internally on harvest runs so they don't recurse
#
# Only interactive sessions (CLAUDE_CODE_ENTRYPOINT=cli) harvest or trigger the
# morning update: scripted `claude -p` / SDK runs (worktree agents, scripts)
# would otherwise each spawn a paid harvest.
#
# Plain bash 3.2 compatible (macOS /bin/bash). Never fails the session: every
# error path exits 0 with no output.

set -uo pipefail

mode="${1:-}"
[ -n "${WORKERBEE_OFF:-}" ] && exit 0
[ -n "${WORKERBEE_HEADLESS:-}" ] && exit 0
command -v jq >/dev/null 2>&1 || exit 0

W="$HOME/working"
AI="$W/ai"
STATE="$W/tmp/.workerbee"
mkdir -p "$STATE" "$AI/.state" 2>/dev/null || exit 0

today="$(date +%F)"
every="${WORKERBEE_CHECKPOINT_EVERY:-15}"
interactive=0
case "${CLAUDE_CODE_ENTRYPOINT:-cli}" in cli) interactive=1 ;; esac

# ---------------------------------------------------------------- harvest worker
# Runs fully detached (own session via setsid), so the SessionEnd hook
# timeout can't kill it. Single-flight: one harvest at a time across all
# sessions, so parallel harvests don't race on the same notes.
if [ "$mode" = "harvest-worker" ]; then
  tp="${2:-}" sid="${3:-unknown}" cwd="${4:-}"
  [ -f "$tp" ] || exit 0
  lock="$STATE/harvest.lock"
  for _ in $(seq 1 120); do # wait up to ~10 min for another harvest
    mkdir "$lock" 2>/dev/null && break
    # stale lock (crashed worker) → take it over
    if [ -n "$(find "$lock" -maxdepth 0 -mmin +20 2>/dev/null)" ]; then
      rmdir "$lock" 2>/dev/null
      continue
    fi
    sleep 5
  done
  [ -d "$lock" ] || exit 0
  trap 'rmdir "$lock" 2>/dev/null' EXIT

  off_f="$STATE/harvested-$sid"
  off="$(cat "$off_f" 2>/dev/null || echo 0)"
  total="$(wc -l <"$tp" | tr -d ' ')"
  [ "$total" -le "$off" ] && exit 0

  out="$STATE/harvest-$sid-$total.md"
  tail -n +"$((off + 1))" "$tp" | head -n "$((total - off))" | jq -r '
    select((.type == "user" or .type == "assistant") and (.isMeta | not) and (.isSidechain | not))
    | (.message.content
       | if type == "string" then . else ([.[]? | select(.type == "text") | .text] | join("\n")) end) as $t
    | select($t != "" and ($t | startswith("<local-command") | not) and ($t | startswith("<command-") | not))
    | "\(.type): \($t)\n"' >"$out" 2>/dev/null || exit 0

  size="$(wc -c <"$out" | tr -d ' ')"
  if [ "$size" -lt 1500 ]; then # too short to hold anything worth filing
    rm -f "$out"
    echo "$total" >"$off_f"
    exit 0
  fi
  if [ "$size" -gt 60000 ]; then # keep the run fast and cheap: newest ~60KB
    tail -c 60000 "$out" >"$out.tmp" && mv "$out.tmp" "$out"
  fi

  branch="$(git -C "${cwd:-.}" branch --show-current 2>/dev/null)"
  cd "$W" || exit 0
  echo "--- $(date '+%F %H:%M') harvest $sid lines $off-$total" >>"$STATE/harvest.log"
  if WORKERBEE_HEADLESS=1 claude -p --agent workerbee --permission-mode acceptEdits \
    "Harvest mode. Read $out: the text of a Claude session (cwd: ${cwd:-?}, branch: ${branch:-none}). File anything worth keeping per your rules: finished work, where work left off, tasks, ideas, decisions, facts about the user. Headline level only: if the session was in a planning repo, record what was started/finished/blocked/due with a plan: link, never its spec or task detail. Never write to Todoist in harvest mode. The main agent may already have dispatched some of it, so dedupe against existing notes. Reply noop if nothing is worth filing." \
    </dev/null >>"$STATE/harvest.log" 2>&1; then
    echo "$total" >"$off_f" # only mark harvested once it actually ran
  fi
  find "$STATE" -name 'harvest-*.md' -mtime +2 -delete 2>/dev/null
  exit 0
fi

# ---------------------------------------------------------------- hook modes
input="$(cat)"
field() { jq -r --arg k "$1" '.[$k] // empty' <<<"$input" 2>/dev/null; }

# A session that *is* WorkerBee (`claude --agent workerbee`) doesn't need the protocol.
[ "$(field agent_type)" = "workerbee" ] && exit 0

sid="$(field session_id)"
sid="${sid:-unknown}"
note="$W/daily-notes/$today-daily.md"

emit() {
  jq -n --arg ev "$1" --arg ctx "${2:0:9500}" \
    '{hookSpecificOutput: {hookEventName: $ev, additionalContext: $ctx}}'
}

# Prints a morning-update instruction at most once per day across all
# sessions. "Done" is a marker morning-update writes itself — not the note's
# existence, since /bee or a harvest can create the note first. A failed or
# interrupted run gets one retry after 30 min, then it stays quiet for the day.
maybe_morning() {
  [ "$interactive" = 1 ] || return
  [ -f "$AI/.state/morning-$today" ] && return
  [ "$(date +%H)" -lt 5 ] && return # 1am is still "yesterday"
  local lock="$STATE/morning-$today" tries
  tries="$(cat "$lock.tries" 2>/dev/null || echo 0)"
  if [ -d "$lock" ] && [ "$tries" -lt 2 ] &&
    [ -n "$(find "$lock" -maxdepth 0 -mmin +30 2>/dev/null)" ]; then
    rmdir "$lock" 2>/dev/null
  fi
  mkdir "$lock" 2>/dev/null || return
  echo "$((tries + 1))" >"$lock.tries"
  printf '%s\n' "Today's morning update hasn't run yet. Invoke the morning-update skill now — it runs in the background. Don't wait for it; at most say '→ bee'."
}

# The static protocol and about-me memory come from ~/.claude/CLAUDE.md;
# this only adds what changes day to day.
session_start() {
  [ "$(field source)" = "startup" ] && rm -f "$STATE/count-$sid"
  local ctx="" now
  if [ -f "$note" ]; then
    now="$(grep -m1 '^\*\*Now:\*\*' "$note" 2>/dev/null | grep -v '{{')"
    [ -n "$now" ] && ctx+="Today's daily note says — $now"$'\n'
  fi
  ctx+="$(maybe_morning)"
  [ -n "$ctx" ] && emit SessionStart "$ctx"
}

prompt() {
  local f="$STATE/count-$sid" n msg
  n=$(($(cat "$f" 2>/dev/null || echo 0) + 1))
  echo "$n" >"$f"
  msg="$(maybe_morning)" # sessions that run past midnight
  if [ $((n % every)) -eq 0 ]; then
    msg+=$'\n'"WorkerBee checkpoint due: scan the conversation since your last WorkerBee dispatch for tasks, ideas, decisions, finished or parked work, and facts about the user. Dispatch anything new in the background; skip silently if there's nothing."
  fi
  [ -n "${msg//[[:space:]]/}" ] && emit UserPromptSubmit "$msg"
}

# Does the bare minimum inside the hook's timeout: hand the transcript path
# to a worker in its own session (perl setsid — macOS has no setsid(1)).
harvest() {
  [ "$interactive" = 1 ] || return
  [ "${WORKERBEE_HARVEST:-1}" = "0" ] && return
  command -v claude >/dev/null 2>&1 || return
  local tp
  tp="$(field transcript_path)"
  [ -f "$tp" ] || return
  perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV' -- \
    bash "$0" harvest-worker "$tp" "$sid" "$(field cwd)" \
    </dev/null >/dev/null 2>&1 &
}

session_end() {
  echo "$(date '+%F %a %H:%M') end" >>"$AI/.state/sessions.log"
  rm -f "$STATE/count-$sid"
  harvest
  # trim after launching the worker — keeps the hook fast
  if [ "$(wc -l <"$AI/.state/sessions.log")" -gt 200 ]; then
    tail -n 200 "$AI/.state/sessions.log" >"$AI/.state/sessions.log.tmp" &&
      mv "$AI/.state/sessions.log.tmp" "$AI/.state/sessions.log"
  fi
}

case "$mode" in
  session-start) session_start ;;
  prompt) prompt ;;
  pre-compact) harvest ;;
  session-end) session_end ;;
esac
exit 0
