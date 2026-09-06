# Dependency Reviewer - Checker Rules

This file defines the rules scripts\reviewer.ps1 follows. The reviewer
is the CHECKER, not the maker. It never writes the audit report and
never fixes it.

## What the Reviewer Must Check

1. Does reports\dependency-audit.md exist?
2. Does it contain the current run's Run ID?
3. Does it list every dependency from this run's source data?
4. Does every dependency have a status and a recommendation?
5. Does it contain a summary with counts (outdated, current, review)?
6. Does it clearly say the data is simulated / local demonstration data,
   and avoid claiming to be a real vulnerability scan?
7. Is the report understandable, not just raw dumped data?

## Verdict Rules

- If every check above passes, and no reviewer failure was deliberately
  simulated, the verdict is exactly: PASS
- If any check fails, or a reviewer failure was deliberately simulated
  (see config\loop-config.json "simulateReviewerFailure"), the verdict
  is exactly: FAIL, with a list of specific reasons.
- Never use soft verdicts such as "mostly good", "almost pass", "looks
  okay", or "partial pass".

## What the Reviewer Must Never Do

- Never modify reports\dependency-audit.md.
- Never modify source-data.txt.
- Never fix the underlying problem itself. Fixing is out of scope for
  this role; the reviewer only inspects and grades.