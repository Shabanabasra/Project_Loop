# Success Report - Secrets Drill

Run ID: SECRETS-DRILL-RUN-20260828-101500
Timestamp: 2026-08-28 10:15:00

## Why this run succeeded

OPENROUTER_API_KEY was supplied as a real process environment variable,
not through a .env file. Environment variables live on the execution
environment itself and are not affected by the fresh-clone process that
strips out gitignored files. The prompt also explicitly told the model
not to look for a .env file, removing any wasted attempt down that
dead-end path.

## Was the real secret exposed anywhere

No. This report and the corresponding transcript both report the key's
status as [AVAILABLE] rather than printing the value. No real
OpenRouter key is stored anywhere in this project.

## Mechanical reason this works

Environment variables panel -> value injected directly into the
Routine's execution environment -> available regardless of what the
repository clone contains -> OPENROUTER_API_KEY found successfully.

## Comparison note

See reports\failure-report.md and reports\comparison-report.md for the
side-by-side contrast with the .env-based run, which failed for the
opposite mechanical reason.

---
NOTE: This is example content showing what a real success report looks
like. Run scripts\simulate-environment-success.ps1 to regenerate this
file.