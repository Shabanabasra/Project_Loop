# Project 8: Your Own Daily Loop (Capstone)

Source: Loop Engineering: A Crash Course - Practice Projects, Project 8,
the first capstone.

This is a safe, fully offline, local scaffold: a **Daily Dependency
Audit Loop**. It does NOT require CCR, Claude Code, OpenCode, or any AI
model. Everything runs with plain PowerShell and plain text/JSON files
on your own machine. Later, when your CCR/Claude Code/OpenCode setup is
working again, the simulated maker and checker steps can be replaced
with real AI agent calls.

## 1. Project 8 Goal

Build a full six-part loop around one real, boring, recurring chore -
here, a dependency audit - and demonstrate that all six parts work
together safely: a heartbeat that fires it, isolated worktrees, a
skill, a maker-checker split, a connector, and a spine that remembers
between runs. The real capstone (per the source) is meant to run
unattended on a real project for a week; this scaffold gives you a safe
local simulation you can run and inspect first.

## 2. The Six-Part Loop, as Built Here

1. **Heartbeat** - scripts\heartbeat.ps1 fires scripts\daily-loop.ps1 a
   bounded number of times (config\loop-config.json "maxRuns"),
   simulating a daily schedule without ever running forever.
2. **Body** - scripts\daily-loop.ps1 is the body: it orchestrates every
   step of one run, from reading the spine to writing the log.
3. **Spine** - progress.md, read at the start and rewritten at the end
   of every run by scripts\update-spine.ps1.
4. **Worktree** - scripts\create-workspace.ps1 creates an isolated
   workspace per run, under workspaces\, using a real git worktree if
   available or a plain folder otherwise.
5. **Maker-checker** - scripts\implementer.ps1 (maker) drafts the audit
   report; scripts\reviewer.ps1 (checker) independently grades it as
   PASS or FAIL, and never edits it.
6. **Connector** - config\connector-config.json documents the current
   local-simulation connector and where a real connector (GitHub, a
   real project's package file, a package registry API) would be
   plugged in later.

## 3. Folder Structure

```
Your-Own-Daily-Loop/
|
+-- README.md
+-- progress.md
+-- source-data.txt
|
+-- config/
|   +-- loop-config.json
|   +-- budget-config.json
|   +-- connector-config.json
|
+-- logs/
|   +-- loop.log
|
+-- reports/
|   +-- dependency-audit.md
|   +-- reviewer-report.md
|   +-- concept-15-review.md
|   +-- cost-report.md
|   +-- diagnosis-report.md
|
+-- evidence/
|   +-- README.md
|
+-- skills/
|   +-- dependency-audit-skill.md
|   +-- reviewer-skill.md
|
+-- reviewers/
|   +-- dependency-reviewer.md
|
+-- workspaces/
|   (created and filled automatically at run time)
|
+-- scripts/
    +-- setup-check.ps1
    +-- daily-loop.ps1
    +-- heartbeat.ps1
    +-- create-workspace.ps1
    +-- implementer.ps1
    +-- reviewer.ps1
    +-- update-spine.ps1
    +-- budget-check.ps1
    +-- diagnose-failure.ps1
    +-- estimate-cost.ps1
```

## 4. How to Run Setup Check

```powershell
cd Your-Own-Daily-Loop\scripts
.\setup-check.ps1
```

Prints [OK] or [MISSING] for every required file and folder, and
finishes with SETUP CHECK: PASS or SETUP CHECK: FAIL.

## 5. How to Run the Daily Loop (One Run)

```powershell
.\daily-loop.ps1
```

This runs one complete cycle: reads the spine, checks the budget,
creates a workspace, runs the implementer, runs the reviewer, updates
the spine, and writes a log line. It exits on its own; it does not
loop.

## 6. How to Run the Heartbeat Demonstration (Several Bounded Runs)

```powershell
.\heartbeat.ps1
```

This calls .\daily-loop.ps1 automatically, up to config\loop-config.json
"maxRuns" times (hard-capped at 10 for safety regardless of config), then
stops. It simulates several days of the heartbeat firing, safely, in one
sitting.

## 7. How to Estimate Cost

```powershell
.\estimate-cost.ps1
```

Answer the prompts (or press Enter to accept defaults). Saves the result
to reports\cost-report.md. All numbers are clearly labeled as estimates.

## 8. How to Inspect Logs

```powershell
Get-Content ..\logs\loop.log
```

Each line is one run record: RUN_ID, TIMESTAMP, MAKER_STATUS,
REVIEWER_VERDICT, BUDGET_STATUS, NEEDS_HUMAN, and REASON.

## 9. How to Diagnose Failures

```powershell
.\diagnose-failure.ps1
```

Reads ONLY progress.md, logs\loop.log, and the existing reports. Does
not re-run the loop and does not read source-data.txt. Writes findings
to reports\diagnosis-report.md.

## 10. How to Verify the Spine

```powershell
Get-Content ..\progress.md
```

Check that "Latest Run" shows the most recent Run ID and timestamp, and
that "## Run History" is accumulating one line per run underneath it,
most recent first.

## 11. How to Review Concept 15

Open reports\concept-15-review.md in Notepad and honestly fill in the
checklist after you have run the loop a few times (or, for the real
capstone, after a full week of real unattended runs on a real project).
This file is not auto-generated - it is meant to be filled in by you.

## 12. How to Run This Safely for a Week (the Real Capstone)

This scaffold is a safe local simulation. To do the real capstone from
the source:

1. Pick a real, boring, recurring chore on a project you actually work
   on (dependency audit, docs-freshness check, changelog draft, or lint
   sweep are the source's suggestions).
2. Once your CCR/Claude Code/OpenCode setup is working again, replace
   the simulated implementer and reviewer logic in this scaffold's
   scripts\implementer.ps1 and scripts\reviewer.ps1 with real AI agent
   calls, and replace config\connector-config.json's connectorType with
   a real connector.
3. Wire the heartbeat to a real scheduler (a Claude Code Routine, an
   OpenCode + cron entry, Windows Task Scheduler, or GitHub Actions).
4. Let it run unattended for a week, reading its output daily.
5. Fill in reports\concept-15-review.md honestly at the end of the
   week.

## 13. Demonstrating Failure Handling (Safe, Reversible)

Open config\loop-config.json and set one of:

```
"simulateFailure": "missingData"
```
or
```
"simulateFailure": "unexpectedError"
```

Then run:
```powershell
.\daily-loop.ps1
```

The implementer will fail in a controlled way, logs\loop.log will show
MAKER_STATUS=FAILED, progress.md will show Needs Human: YES, and no
misleading report will be produced.

To demonstrate a reviewer failure instead, set:
```
"simulateReviewerFailure": true
```
and run .\daily-loop.ps1 again. The implementer succeeds but the
reviewer deliberately returns FAIL.

To demonstrate a budget failure, lower "maxRunsPerDay" in
config\budget-config.json to a small number (for example 1), then run
.\daily-loop.ps1 more times than that limit in the same day.

**To restore normal operation afterward**, set:
```
"simulateFailure": "none",
"simulateReviewerFailure": false
```
in config\loop-config.json, and restore "maxRunsPerDay" to a reasonable
number (for example 3) in config\budget-config.json.

## 14. What Would Later Be Replaced by Claude Code/OpenCode

- scripts\implementer.ps1's rule-based dependency parsing would become a
  real AI agent call, potentially reading a real package.json or
  similar real dependency manifest.
- scripts\reviewer.ps1's rule-based checks would become a real,
  independent AI reviewer agent call.
- config\connector-config.json's "local-simulation" connectorType would
  become a real connector (GitHub, filesystem access to a real project,
  or a package registry API).
- scripts\heartbeat.ps1's bounded demonstration loop would be replaced
  by a real unattended scheduler (Claude Code Routine, OpenCode + cron,
  Windows Task Scheduler, or GitHub Actions).

## 15. What "Done" Means for This Capstone

Per the source's "Done when" line: this capstone is done when the loop
has run unattended for a week and you trust what it ships **because you
read it**, not because you stopped reading - and you can honestly answer
Concept 15: did your understanding of the project keep up with what the
loop changed? If not, slow the loop down until it does.

## Done-When Checklist

- [ ] Setup check passes.
- [ ] The daily loop runs a full cycle successfully (Maker=SUCCESS,
      Reviewer=PASS).
- [ ] progress.md updates correctly after every run, with growing Run
      History.
- [ ] logs\loop.log contains an observable record for every run.
- [ ] An isolated workspace is created per run under workspaces\.
- [ ] Monthly token/cost estimate is calculated and saved.
- [ ] Failure handling has been demonstrated for at least one of:
      missingData, unexpectedError, reviewer failure, or budget
      exceeded.
- [ ] Each demonstrated failure produced NEEDS HUMAN: YES and a clear
      REASON in both the log and progress.md.
- [ ] diagnose-failure.ps1 produces a correct diagnosis using only
      progress.md, logs\loop.log, and the existing reports.
- [ ] Normal configuration (simulateFailure=none,
      simulateReviewerFailure=false) has been restored.
- [ ] reports\concept-15-review.md has been read and honestly
      considered.
- [ ] No CCR/Claude Code/OpenCode is required for this local
      demonstration.