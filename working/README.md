# ~/working

A consistent working-directory structure, kept the same across every host by
`install.sh` (this file is symlinked in from `working/README.md` in this
repo, same as the rest of the manifest — edit it here, not in place).

## Structure

- **`tmp/`** — Scratch space for temporary files. Free for you or an agent
  to use for intermediate output; nothing in here is tracked or backed up,
  and it's safe to delete the contents at any time.
- **`ai/`** — AI skills, docs, and other context specific to maintaining
  this `working` directory itself (not any one repo's own AI context).
  Home of **WorkerBee**, the assistant that maintains everything below —
  see [`ai/README.md`](ai/README.md) for usage.
  - `agents/`, `skills/`, `hooks/`, `templates/`, `README.md` — symlinked
    from the dotfiles repo (edit them there).
  - **`lessons/YYYY-MM-DD-lesson.md`** — Lessons learned from using AI to maintain this `working` directory.
  - **`lessons/RULES.md`** — ≤30 rules distilled from those lessons; WorkerBee reads it every run.
  - **`memory/about-me.md`** — durable facts about you, injected into every session.
- **`repos/`** — All git repos cloned on this host. Backwards compatibility: if a legacy `~/repos` already exists on a host,
  `install.sh` symlinks `repos/` to it instead of creating a second, empty
  directory — TODO once every reference to `~/repos` is updated to
  `~/working/repos`, drop this symlink handling and make `repos/` a plain
  real directory again.
- **`daily-notes/`** — Daily notes, one file per day, named
  `YYYY-MM-DD-daily.md`.
- **`projects/`** — High-level project/task tracking (WorkerBee's), one
  directory per project. Detailed specs and plans stay in planning repos and
  are linked, not copied. Todoist is read for due dates and priorities and
  isn't changed without an explicit request.
  - **project-name/** (no date prefix) — Each project directory contains:
    - `README.md` for a description of the project
    - `ideas/YYYY-MM-DD-idea.md` for each idea, with the date of creation in the filename
    - `tasks/YYYY-MM-DD-task.md` for each task, with the date of creation in the filename, with a simple syntax for marking them done or in progress
    - `status.md` for a summary of the project's current status, including a list and counts of tasks that are done, in progress, or not started yet.

## Future improvements

- A dedicated `working` repo to sync `ai/` and `daily-notes/` across hosts,
  instead of each host having its own empty copy.
