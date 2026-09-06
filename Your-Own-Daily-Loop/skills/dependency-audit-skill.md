# Dependency Audit Skill

These are the steps the implementer (maker) follows on every run of the
Daily Dependency Audit Loop.

## Steps

1. Read progress.md first, to see the state left by the previous run.
2. Read source-data.txt (or the copy inside the isolated workspace),
   which lists a project name and a set of dependencies, each with a
   version and a status (outdated, current, or review).
3. For each dependency, decide a recommendation:
   - status "outdated" -> recommend updating to the latest version
   - status "current" -> recommend no action
   - status "review" -> recommend a manual review by a human
4. Write a clear, structured report to reports\dependency-audit.md,
   including: the run ID, the project name, every dependency checked
   with its version, status, and recommendation, and a summary count of
   how many are outdated, current, and needing review.
5. Clearly label the report as simulated, local demonstration data. Do
   not claim, imply, or format the report as if it came from a real
   internet vulnerability database.
6. Never approve or grade your own report. That is the reviewer's job,
   not the implementer's.
7. If the source data cannot be read, or an unexpected error occurs,
   fail clearly: do not write a partial or misleading report. Report
   the failure so it can be logged and diagnosed.