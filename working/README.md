# ~/working

A consistent working-directory structure, kept the same across every host by
`install.sh` (this file is symlinked in from `working/README.md` in this
repo, same as the rest of the manifest — edit it here, not in place).

## Structure

- **`tmp/`** — Scratch space for temporary files. Free for you or an agent
  to use for intermediate output; nothing in here is tracked or backed up,
  and it's safe to delete the contents at any time.
- **`ai/`** — AI skills, docs, and other context specific to maintaining
  this `working` directory itself (not any one repo's own AI context —
  see "Not included" below).
- **`repos/`** — All git repos cloned on this host.
- **`daily-notes/`** — Daily notes, one file per day, named
  `YYYY-MM-DD-daily.md`.

## Not included

No project/task-tracking directory yet — deferred until there's a real use
case for one that isn't already covered by an individual repo's own tracking
(several already have one).

## Future improvements

- A dedicated `working` repo to sync `ai/` and `daily-notes/` across hosts,
  instead of each host having its own empty copy.
- A `.gitkeep` in the other directories (`tmp/`, `repos/`) so that repo
  doubles as a template for the structure documented above.
