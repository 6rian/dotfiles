---
name: where
description: '"What was I doing?" — read-only 3-line resume after a distraction or context switch: the Now line, where the current project left off, and the next step. Use when the user asks where they were, what they were doing, or what''s next.'
allowed-tools: Read, Glob, Bash(date:*)
---

Read-only and fast. Do NOT dispatch WorkerBee and don't write anything.

1. `date +%Y-%m-%d`, then Read `~/working/daily-notes/<date>-daily.md`.
   Missing → read the newest file in `~/working/daily-notes/`.
2. Match the current cwd/repo to a line in `## Left off` if possible.
3. Also use what's in this conversation, if anything.

Reply with exactly 3 lines, nothing before or after:
```
now: <Now line, or the in-conversation task>
left off: <where this project stopped>
next: <one physical action>
```
Unknown → `next: run /morning-update`.
