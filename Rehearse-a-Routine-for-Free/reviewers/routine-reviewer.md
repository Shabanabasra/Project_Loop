# Routine Reviewer - Project 9 Rehearsal

This file defines the checklist used to judge whether this Project 9
rehearsal was completed correctly. This reviewer never modifies any
file; it only inspects the evidence and reports a verdict.

## What the Reviewer Checks

1. Was the successful task actually completed?
   - transcripts\successful-run.md must show Task Result: SUCCESS, with
     the commit data actually read and a summary actually produced.

2. Was the failure deliberately caused by the missing file?
   - transcripts\failed-run.md must show an attempt to read
     candidates\file-that-does-not-exist.txt specifically, not some
     other unrelated error.

3. Were both transcripts created?
   - transcripts\successful-run.md and transcripts\failed-run.md must
     both exist and both contain real run details, not just the initial
     placeholder text.

4. Was platform status separated from task result?
   - Both transcripts must show Platform Status: GREEN, while only the
     successful one shows Task Result: SUCCESS and the failed one shows
     Task Result: FAILED.

5. Did the learner inspect the transcript?
   - reports\comparison-report.md must reference specific details from
     both transcripts, not just repeat the status line.

6. Was the A5 lesson demonstrated?
   - reports\comparison-report.md must state, in the learner's own
     words or close to it, that a green status does not prove task
     success and that the transcript must be read.

7. Was the Remote vs Local distinction documented?
   - config\routine-config.json must show "routineType": "Remote", and
     README.md must explain the difference between a Remote cloud
     Routine and a Local Desktop scheduled task.

8. Was repeating scheduling avoided?
   - config\routine-config.json must show "repeatingSchedule": false
     and "triggerType": "one-off".

## Verdict

The verdict must be exactly one of:

PASS

or

FAIL

If FAIL, list the specific missing or incorrect items from the
checklist above. Do not use soft verdicts like "mostly good" or "looks
okay".