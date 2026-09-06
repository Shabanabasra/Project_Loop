# Evidence Folder

This folder exists to hold this project's guiding rule for diagnosis.

scripts\diagnose-failure.ps1 is only ever allowed to use these sources
of evidence:

1. progress.md - the spine, holding the latest known state and run
   history
2. logs\loop.log - the observable run-by-run record
3. The existing files in reports\ (dependency-audit.md,
   reviewer-report.md, cost-report.md) as they currently stand

Diagnosis must NOT be based on:

- Re-running scripts\daily-loop.ps1 to see what happens
- Reading source-data.txt to guess what should have happened
- Replaying or re-triggering a failed run in any way

This restriction is intentional. It simulates a real unattended loop
failing overnight, when nobody is there to watch it live. If the log,
the spine, and the existing reports are not enough to explain a failure
on their own, that is itself an important finding: it means the loop is
not observable enough yet, and needs clearer logging before anything
else.