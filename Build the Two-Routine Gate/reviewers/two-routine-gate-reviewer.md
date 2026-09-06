# Two-Routine Gate Reviewer (Meta-Reviewer) - Project 11

This file defines the checklist used to judge whether the entire
Project 11 rehearsal was completed correctly. This meta-reviewer never
modifies any file; it only inspects the evidence and reports a verdict.

## What This Meta-Reviewer Checks

1. Do two distinct roles exist?
   - routine-implementer-prompt.md and routine-reviewer-prompt.md must
     describe clearly different responsibilities.

2. Do two distinct triggers exist?
   - config\implementer-config.json must show "triggerType": "schedule"
   - config\reviewer-config.json must show "triggerType": "pull_request"

3. Does the implementer use a schedule trigger?
   - Confirmed via config\implementer-config.json and every
     implementer-run-*.md transcript's Trigger line.

4. Does the reviewer use a PR event trigger?
   - Confirmed via config\reviewer-config.json and every
     reviewer-run-*.md transcript's Trigger line.

5. Does the implementer handle exactly one labeled issue per run?
   - config\implementer-config.json must show "maxIssuesPerRun": 1, and
     every implementer-run-*.md transcript must show exactly one issue
     selected.

6. Does the reviewer only grade?
   - Every reviewer-run-*.md transcript must explicitly state it did
     not implement, modify code, or merge.

7. Does the reviewer produce PASS/FAIL?
   - Every reviewer-run-*.md transcript must contain an explicit
     Verdict line reading exactly PASS or FAIL.

8. Can the reviewer merge?
   - config\reviewer-config.json must show "autoMerge": false, and no
     transcript may claim a merge action.

9. Can the implementer grade itself?
   - config\implementer-config.json must show "canReviewOwnWork": false,
     and no implementer-run-*.md transcript may contain a Verdict line.

10. Does evidence support every claim?
    - evidence\implementer-evidence.md, evidence\reviewer-evidence.md,
      and evidence\gate-evidence.md must each cite specific transcript
      content, not just assert conclusions.

## Verdict

The verdict must be exactly one of:

PASS

or

FAIL

If FAIL, list the specific missing or incorrect items from the
checklist above. Do not use soft verdicts like "mostly good" or "looks
okay".