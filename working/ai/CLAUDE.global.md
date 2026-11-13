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
notes, high-level projects and tasks, ideas, memory. It reads Todoist to help
prioritize. You never write those `~/working` notes yourself and never choose
their file names or locations — WorkerBee decides.

**Planning repos come first.** Some repos have their own detailed
planning/task workflow (e.g. `optimization-pod-plans`: `PROJECT.md`,
`STATUS.md`, `tasks/`, `drafts/`, skills like `task-draft`/`scope-work`).
Inside one, follow that repo's workflow for all detail: drafts, specs, plans,
task breakdowns. WorkerBee is the high-level layer on top and only gets the
headline (see below). It never replaces those workflows.

## When to dispatch

Dispatch as soon as one of these happens (batch if several land at once):
- The user mentions a task, todo, reminder, deadline, or idea that isn't
  already being captured by a planning repo's own workflow.
- A task or meaningful chunk of work finishes, or is parked mid-way.
- A decision is made that will matter later.
- The user states a preference, a fact about themselves, a person, or context
  worth remembering.
- You see `WorkerBee checkpoint due` in your context: review the conversation
  since the last dispatch and send anything from the list above. Nothing new
  → skip, silently.

Don't dispatch for chit-chat, or for things already sent.

In a planning repo, dispatch only headline events: started, finished, blocked,
a deadline, where you left off. Point to the repo's file (`plan:` line)
instead of describing the detail. Scoping back-and-forth, spec content and
sub-task breakdowns stay in the repo.

## How to dispatch

Agent tool, `subagent_type: "workerbee"`. It runs in the background — never
wait on it, never poll it, keep working with the user.

Prompt = raw facts, not instructions about files:
```
cwd: <cwd> · repo: <repo> · branch: <branch>
- done: <what finished>
- left off: <where work stopped> → next: <next step>
- new task: <task> (due <date> if stated)
- user asked: <explicit instruction, e.g. "add X to Todoist due Fri">
- plan: <path to the planning repo's file for this work>
- idea: <idea>
- decision: <decision + why>
- remember: <preference / fact about the user>
```
Only include lines that apply. Use the user's own words for tasks.

**Todoist is read-only for WorkerBee** unless the user explicitly asks for a
change (add, update, reschedule, complete, delete). Use a `user asked:` line
only when the user really asked for that. Mentioning a task or finishing work
is not a request.

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
