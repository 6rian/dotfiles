---
name: bee
description: Send WorkerBee direct instructions or a quick capture ("/bee remind me to renew passport by Dec 1", "/bee move the API task to Friday"). Runs in the background.
argument-hint: "<instructions or anything to capture>"
context: fork
agent: workerbee
---

Direct request from the user (not from another agent):

$ARGUMENTS

- Instruction (move, rename, complete, reprioritize, summarize…) → do it.
- Bare capture (a thought, a todo, a link) → file it. Unsure where → today's
  `## Inbox`.
- Question → answer in ≤5 bullets.
- Empty → reply `usage: /bee <anything>`.

Reply in one line unless it was a question.
