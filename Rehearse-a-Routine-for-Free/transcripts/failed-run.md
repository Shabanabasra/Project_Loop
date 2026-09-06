# Failed Run Transcript

Run ID: ROUTINE-RUN-20260829-161757
Start time: 2026-08-29 16:17:57
Trigger type: one-off (Run now / one-off schedule simulation)

## Broken prompt used

Read candidates/file-that-does-not-exist.txt and summarize it.

## Missing file

Path attempted: C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Rehearse-a-Routine-for-Free\candidates\file-that-does-not-exist.txt
This file does not exist. It was left out on purpose, to rehearse a
failure safely, using the Project 9 method of pointing a task at a
file that does not exist.

## Error

Error message recorded: Cannot find path 'C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Rehearse-a-Routine-for-Free\candidates\file-that-does-not-exist.txt' because it does not exist.

## Task result

Task Result: FAILED
The requested file could not be found, so no summary could be
produced and nothing was pushed to any branch.

## Platform status

Platform Status: GREEN
(The simulated session still ended without an infrastructure
error. PowerShell caught the missing-file error safely, the script
did not crash, and the session completed normally. This is exactly
why status alone is not enough: an infrastructure-level GREEN can
still wrap a task-level failure.)

## Explanation

This run demonstrates the A5 lesson directly. The session itself
completed without an infrastructure error (no crash, no network
failure, no authentication failure) so its platform status is
GREEN, exactly like the successful run. But the actual task, that
is, summarizing a real file, could not happen, because the file
named in the prompt does not exist. Only reading this transcript
reveals that difference. The status color cannot.

## What a human should investigate

1. Confirm whether the missing file was expected to exist.
2. If the file was supposed to exist, find out why it does not
   (wrong path in the prompt, file not yet created, file moved,
   or a typo).
3. Fix the prompt or the missing input, then re-run a one-off
   rehearsal before ever putting this prompt on a repeating
   schedule.
