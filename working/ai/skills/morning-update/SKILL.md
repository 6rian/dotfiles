---
name: morning-update
description: WorkerBee's once-a-day routine. Creates or refreshes today's daily note in ~/working/daily-notes with the top 3 priorities, today's schedule, upcoming deadlines and where work left off. Auto-triggered by the SessionStart hook; safe to re-run.
context: fork
agent: workerbee
---

Run the morning update. Safe to re-run: update today's note in place, never
duplicate sections, never overwrite the user's own text (`## Inbox`,
`## Done`, `## Notes`).

1. `date "+%Y-%m-%d %a %H:%M"`. Today's file:
   `~/working/daily-notes/YYYY-MM-DD-daily.md`. Missing → copy
   `~/working/ai/templates/daily-note.md`.
2. Gather (read, don't write yet):
   - Todoist: tasks due today, timed tasks (schedule), p1/p2 tasks, anything
     due in the next 7 days, items with label `doing`.
   - The most recent previous daily note: its `## Inbox` leftovers,
     `**Next:**` line from `/wrap-up`, `## Left off`.
   - `~/working/projects/*/status.md` for active projects.
   - `~/working/ai/.state/sessions.log` (session end times, last 5 days).
3. Pick priorities. Max 3. Order: hard deadline today > the "Next" line set
   at last wrap-up > p1 > things already in progress > the rest. One gets ⭐.
   Each gets ≤5 words of why.
4. `**Now:**` = the single next physical action for ⭐ (e.g. "open
   dotfiles PR #5 and read the review").
5. Fill the note from the template. Hard caps:
   - Schedule: one line, `·`-separated times. Nothing → `- clear day`.
   - Coming up: ≤4 deadlines in the next 7 days, with weekday.
   - Older open items: ONE line, `- N older items parked in Todoist`. Never
     list them.
   - Left off: one line per active project, ≤3 projects.
   - Monday only: add `## Last week` with ≤3 wins.
6. Energy line (only if true): ended ≥3 of the last 5 sessions after 22:00,
   or worked a weekend → add one neutral line under the date, e.g.
   `_late finishes 3 of last 5 days — light day is fine_`. No advice beyond that.
7. Carry over unsorted `## Inbox` items from the previous note: file what you
   can, keep the rest in today's Inbox.
8. `## Bee log`: `- HH:MM morning-update ok` (or what failed).
9. Only on success: Write an empty file `~/working/ai/.state/morning-YYYY-MM-DD`.
   This stops the daily auto-trigger. Skip it if the run failed, so the hook
   retries once.

Reply with ≤5 lines: the Now line, the 3 priorities, first fixed time today.
