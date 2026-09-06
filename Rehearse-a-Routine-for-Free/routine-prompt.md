# Routine Prompt - Project 9 Rehearsal

This file documents the two prompts used in this local rehearsal, so you
can see clearly what a real Remote Routine's prompt would look like,
both in its normal form and in the deliberately broken form used to
demonstrate the A5 lesson (green status is not the same as task
success).

## Normal Prompt (would be used with a real Remote Routine later)

Summarize yesterday's commits and prepare the summary on the
claude/summary branch. Report exactly what was changed and verify the
result.

This is the prompt a real cloud Routine would run. It is self-contained:
it says what to read (yesterday's commits), what to do (summarize),
where to put the result (a claude/summary branch), and what "done"
looks like (report what changed and verify it).

## Deliberately Broken Prompt (used only to rehearse failure)

Read candidates/file-that-does-not-exist.txt and summarize it.

This prompt is intentionally broken on purpose, using the Project 9
method: pointing the task at a file that does not exist. This lets us
rehearse what a failed run looks like, safely, before ever running a
real Routine this way.

## Which Script Uses Which Prompt

* scripts\simulate-success.ps1 acts out the Normal Prompt above, using
  candidates\yesterday-commits.txt as its real input.
* scripts\simulate-failure.ps1 acts out the Deliberately Broken Prompt
  above, attempting to read candidates\file-that-does-not-exist.txt,
  which does not exist on purpose.
