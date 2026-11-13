---
name: wrap-up
description: End-of-day shutdown (about 2 minutes). WorkerBee sorts today's inbox, logs wins, updates where each project left off, and sets tomorrow's first step so tomorrow starts without decisions. Use when the user says they're done for the day.
argument-hint: "[anything else to note before stopping]"
context: fork
agent: workerbee
---

End-of-day wrap-up. Extra notes from the user (may be empty): $ARGUMENTS

1. `date`. Open today's daily note (create from template if missing).
2. Sort `## Inbox`: each item → project task/idea note, memory, or drop if
   it's clearly done. Leave only things you truly can't place. Anything that
   looks like it belongs in Todoist → `## Todoist?` (≤3 lines). Don't add
   it yourself; the user decides.
3. `## Done`: add finished work from Todoist completed-today (read) and from today's
   Bee log / dispatches. Keep the user's own entries.
4. `## Left off`: one line per project touched today → next step.
5. Regenerate `status.md` for every project touched today.
6. Pick tomorrow's first step. Write it at the bottom:
   `**Next:** <single physical action>` — morning-update uses it.
7. Bee log: `- HH:MM wrap-up ok`.

Reply in this shape, nothing else:
```
done today: <N things — name the best 1–2>
tomorrow starts with: <Next line>
```
Then one closing line, plain and warm, no exclamation-mark cheerleading.
