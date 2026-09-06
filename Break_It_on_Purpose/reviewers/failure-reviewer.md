# Failure Reviewer

This is a checklist for judging whether a sabotaged run of this project
was handled correctly. This reviewer never modifies any file. It only
checks the evidence and reports whether the loop behaved as required.

## What the Reviewer Checks

1. Did the loop fail loudly?
   - The log line's STATUS field must say FAILED. It must not say
     SUCCESS, and it must not be missing.

2. Did the loop produce a useful log line?
   - The log line must include RUN_ID, TIMESTAMP, ATTEMPT,
     MAX_ATTEMPTS, STATUS, NEEDS_HUMAN, and REASON.
   - REASON must not be empty or generic; it must name the specific
     cause (missing file path, or unmet success condition).

3. Did the loop update progress.md?
   - progress.md must show a Timestamp matching the most recent run,
     not an old, stale entry.

4. Did the loop record NEEDS HUMAN correctly?
   - On the final attempt (attempt equals max attempts), both the log
     line and progress.md must say YES / true. Earlier attempts may
     say NO, since the loop is still auto-retrying at that point.

5. Did the loop respect the maximum attempt limit?
   - The number of FAILED entries for this sabotage run must not exceed
     maxAttempts as configured in config\sabotage-config.json.

6. Can the failure be diagnosed without replaying the run?
   - Reading only logs\loop.log and progress.md must be enough to
     answer what failed, when, on which attempt, why, whether the limit
     was reached, and whether a human is needed.

7. Is there enough information to determine what happened and when?
   - Every required field listed above must actually be present and
     filled in, not left blank or set to a placeholder value.

## Verdict

The reviewer's verdict must be exactly one of:

PASS

or

FAIL

If FAIL, list the specific missing or incorrect items from the checklist
above. Do not use soft verdicts like "mostly good" or "looks okay".