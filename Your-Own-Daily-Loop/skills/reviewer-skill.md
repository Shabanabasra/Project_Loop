# Reviewer Skill

These are the steps the reviewer (checker) follows on every run of the
Daily Dependency Audit Loop. The reviewer is a separate role from the
implementer and never writes or edits the audit report itself.

## Steps

1. Check that reports\dependency-audit.md actually exists. If it does
   not, this is an automatic FAIL.
2. Check that the report contains the current run's Run ID, not an old
   one left over from a previous run.
3. Check that every dependency mentioned in the run's source data was
   actually considered in the report (no dependency silently skipped).
4. Check that every dependency listed has a status and a recommendation
   attached to it.
5. Check that the report contains a summary section with counts.
6. Check that the report clearly labels its data as simulated or local
   demonstration data, and does not claim to be a real vulnerability
   scan.
7. Check that the report is written in plain, understandable language,
   not just raw data dumps.
8. Combine all checks into exactly one verdict: PASS or FAIL. Never use
   a soft verdict like "mostly good" or "looks okay".
9. If FAIL, list the specific missing or incorrect items so a human (or
   a future implementer run) knows exactly what was wrong.
10. Never modify reports\dependency-audit.md. The reviewer only reads
    and grades it.