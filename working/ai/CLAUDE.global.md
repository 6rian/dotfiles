<!--
  User-level CLAUDE.md, symlinked to ~/.claude/CLAUDE.md by install.sh.
  Source: ~/repos/dotfiles/working/ai/CLAUDE.global.md — edit it there.
-->

# About me

@~/working/ai/memory/about-me.md

# WorkerBee protocol (for the main agent)

If you ARE WorkerBee, skip this section.

WorkerBee (`subagent_type: workerbee`) owns `~/working/` (except
`~/working/repos/`, which is ordinary code you work in as usual): daily
notes, projects, tasks, ideas, memory, Todoist. You never write those yourself
and never choose file names or locations — WorkerBee decides.

## When to dispatch

Dispatch as soon as one of these happens (batch if several land at once):
- The user mentions a task, todo, reminder, deadline, or idea.
- A task or meaningful chunk of work finishes, or is parked mid-way.
- A decision is made that will matter later.
- The user states a preference, a fact about themselves, a person, or context
  worth remembering.
- You see `WorkerBee checkpoint due` in your context: review the conversation
  since the last dispatch and send anything from the list above. Nothing new
  → skip, silently.

Don't dispatch for chit-chat, or for things already sent.

## How to dispatch

Agent tool, `subagent_type: "workerbee"`. It runs in the background — never
wait on it, never poll it, keep working with the user.

Prompt = raw facts, not instructions about files:
```
cwd: <cwd> · repo: <repo> · branch: <branch>
- done: <what finished>
- left off: <where work stopped> → next: <next step>
- new task: <task> (due <date> if stated)
- idea: <idea>
- decision: <decision + why>
- remember: <preference / fact about the user>
```
Only include lines that apply. Use the user's own words for tasks.

## What to say to the user

For dispatches you started: nothing, or at most `→ bee` at the end of your
reply. Don't relay the result unless it flags a deadline <2h away. The point
is zero overhead.

Exception: when the USER typed `/bee`, `/morning-update` or `/wrap-up`,
relay WorkerBee's reply verbatim as soon as it arrives. They asked for it.

## User-facing commands

- `/bee <anything>` — direct instructions or quick capture.
- `/morning-update` — today's daily note (auto-triggered once a day).
- `/wrap-up` — end-of-day: sort inbox, log wins, set tomorrow's first step.
- `/where` — "what was I doing?" in 3 lines.
