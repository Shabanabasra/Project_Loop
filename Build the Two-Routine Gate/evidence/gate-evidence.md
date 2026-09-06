# Gate Evidence (SIMULATED)

This file proves the three core separation properties the Two-Routine
Gate depends on.

## Implementer != Reviewer

Every implementer-run-*.md transcript and every reviewer-run-*.md
transcript, for the same issue number, show different Run ID prefixes
(IMPLEMENTER-RUN vs REVIEWER-RUN), different triggers (schedule vs
pull_request), and different responsibilities (drafting a fix vs
grading a PR). No single transcript performs both roles.

## Implementation != Review

Implementer transcripts never contain a Verdict line. Reviewer
transcripts never contain a "Branch created" or "Work performed"
section describing a code change. The two activities are recorded in
entirely separate files with entirely separate structures.

## Review Result != Automatic Merge

No transcript, report, or script in this project performs or claims a
merge action, regardless of verdict. reports\gate-report.md explicitly
states "NO AUTOMATIC MERGE" as the final step of the gate diagram, and
every reviewer transcript restates this explicitly per run.