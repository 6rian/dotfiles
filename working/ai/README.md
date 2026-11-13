# WorkerBee

A background assistant that keeps `~/working` up to date: daily notes,
high-level projects and tasks, memory. It reads Todoist to help with
priorities and scheduling, and changes it only when you ask.
Detailed planning stays in your planning repos (see below). You talk to Claude normally. WorkerBee files
things quietly, and only WorkerBee decides where notes go.

## Daily use

| You type | What happens |
|---|---|
| *(nothing)* | First session of the day creates today's note. Facts from your chats get filed as you go and again when a session ends. |
| `/bee <anything>` | Quick capture or a direct instruction: "remind me to renew passport by Dec 1", "move the API task to Fri". Runs in the background. |
| `/where` | "What was I doing?" Three lines: now / left off / next. Read-only and instant. |
| `/wrap-up` | End of day, about 2 min. Sorts the inbox, logs wins, sets tomorrow's first step. |
| `/morning-update` | Rebuild today's note. Safe to re-run. |

To talk to WorkerBee for a whole session: `cd ~/working && claude --agent workerbee`.
To mention it mid-chat: `@agent-workerbee`.

## How it works

- **Agent** `agents/workerbee.md` uses Sonnet at low effort. It runs in the
  background, so its speed never blocks you. Sonnet gets placement,
  dedupe and prioritization right more often than Haiku, and mistakes there
  cost you more attention than a few extra seconds would.
- **Protocol** `CLAUDE.global.md` is symlinked to `~/.claude/CLAUDE.md`, so
  every session loads it. It tells the main agent when to hand facts to
  WorkerBee, and imports `memory/about-me.md`. A SessionStart hook adds
  today's **Now** line.
- **Guard** `hooks/workerbee-guard.sh` runs before WorkerBee's writes and
  shell commands. WorkerBee can read `~/working/repos/` but can't write there,
  except in `~/working/repos/dotfiles`. Its shell is limited to `date`, `ls`,
  `wc`, `pwd`, `grep`, `find` (no `-delete`/`-exec`) and read-only git. Main agents aren't restricted.
- **Hooks** `hooks/workerbee-hook.sh`:
  - *SessionStart* injects the protocol. If the morning update hasn't run
    today, it triggers `/morning-update`: once per day across all sessions,
    with one retry if that run fails.
  - *UserPromptSubmit* adds a one-line "checkpoint due" nudge every 15
    prompts so the main agent reviews the chat for anything to file.
  - *PreCompact* and *SessionEnd* extract the chat text and hand it to a
    detached headless WorkerBee (`claude -p --agent workerbee`) to harvest.
    Nothing gets lost when context is compacted or the session closes.
    Only one harvest runs at a time. Scripted `claude -p` and SDK runs never
    harvest or trigger the morning update, so worktree agents don't run up cost.
- **Todoist is your list.** WorkerBee reads it but never adds, edits or
  completes anything unless you explicitly ask (`/bee add X to Todoist`).
  Only read tools are pre-approved, so even an explicit change shows you a
  permission prompt. Tasks you mention in chat land in markdown, and
  suggestions show up under `## Todoist?` in the daily note.
- **Planning repos come first.** Repos with their own planning workflow
  (e.g. `optimization-pod-plans`) keep all the detail: specs, plans, task
  breakdowns, drafts. WorkerBee keeps only the headline (on it, done,
  blocked, due, left off) with a `plan:` link back. It never writes there or
  copies their content.
- **Lessons**: WorkerBee logs its own mistakes to `lessons/YYYY-MM-DD-lesson.md`
  and distills them into `lessons/RULES.md` (≤30 rules). It reads that file
  at the start of every run.

Only the code (`agents/ skills/ hooks/ templates/`) is symlinked from the
dotfiles repo. `lessons/`, `memory/` and `.state/` are real per-host
directories, so personal notes never land in git.

## Setup (once per host)

1. `~/repos/dotfiles/install.sh`. It links everything, seeds `RULES.md` and
   `about-me.md`, registers the Todoist MCP server, and installs settings
   with the hooks and permissions. If your current `~/.claude/settings.json`
   differs from the repo's, it backs that file up first.
2. Sign in to Todoist once: run `/mcp` in Claude, select todoist, and finish
   the browser login. This is the only step that can't be automated.
3. Optional: put a few lines about yourself in `~/working/ai/memory/about-me.md`.
4. Optional: Todoist's MCP server may not expose calendar events. If
   `/morning-update` says `schedule: Todoist only`, connect a calendar MCP
   (e.g. Google Calendar in claude.ai connectors) and add its tool pattern to
   `tools:` in `agents/workerbee.md`.

## Knobs (environment variables)

- `WORKERBEE_OFF=1` turns all hooks off, e.g. for a focus session.
- `WORKERBEE_HARVEST=0` stops end-of-session harvesting.
- `WORKERBEE_CHECKPOINT_EVERY=25` makes checkpoint nudges less frequent.

Harvest log: `~/working/tmp/.workerbee/harvest.log`.

## Changing it

Edit the files here in `~/repos/dotfiles/working/ai/`, or ask WorkerBee
(`/bee change your daily note to …`). WorkerBee can edit its own files in
the dotfiles repo, but never commits. Settings and permissions live in
`~/repos/dotfiles/.claude/settings.json`. Don't edit `~/.claude/settings.json`
directly: `install.sh` overwrites it. To change one of WorkerBee's habits
without touching code, add a rule to `~/working/ai/lessons/RULES.md`.

Permissions auto-approve WorkerBee's own folders (`daily-notes`,
`projects`, `ai/lessons`, `ai/memory`, `tmp`), Todoist read tools, and reads anywhere
under `~/working` and `~/repos`. Edits to the dotfiles repo still ask first.
