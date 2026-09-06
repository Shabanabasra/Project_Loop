# Project 9: Rehearse a Routine for Free

Source: Loop Engineering: A Crash Course - Appendix: Routines, end to
end, Practice: three routine drills, Project 9.

This is a safe, fully offline, LOCAL SIMULATION. It does NOT require
CCR, Claude Code, OpenCode, API keys, GitHub authentication, internet
access, or external connectors. It rehearses the reasoning and workflow
of Project 9 using plain PowerShell and plain text/JSON files.

**Important distinction:** the real Project 9 exercise uses an actual
Remote (cloud) Claude Routine. This project is a local stand-in that
teaches the same lesson safely, before you ever spend a real one-off
run on the actual product.

## 1. Project Goal

Learn to rehearse a Routine's prompt using one-off runs before ever
putting it on a repeating schedule, and learn the single most important
lesson about reading a Routine's results: a green status does not mean
the task succeeded.

## 2. A1 - Local vs Cloud Routine

A real "New routine" button offers Remote (a true cloud Routine, run on
Anthropic's servers) or Local (a Desktop scheduled task, running only
on your own machine while it is on). This project's config\routine-config.json
deliberately sets "routineType": "Remote", to document that the real
version of this exercise uses a cloud Routine, not a local Desktop task.

## 3. A3 - One-off Schedule / Run Now

A one-off schedule fires exactly once, then turns off. Critically,
one-off scheduled runs do NOT count against a Routine's daily cap,
which is what makes rehearsing "free". config\routine-config.json
reflects this with "triggerType": "one-off" and "repeatingSchedule": false.

## 4. A5 - Reading Full Run Transcripts

The single most important lesson in this project: "a green status means
the session ended without an infrastructure error. It does not mean
your task succeeded." Both simulated runs in this project show:

```
Platform Status: GREEN
```

but only one shows:

```
Task Result: SUCCESS
```

while the other shows:

```
Task Result: FAILED
```

You can only tell them apart by reading the full transcript.

## 5. Folder Structure

```
Rehearse-a-Routine-for-Free/
|
+-- README.md
+-- routine-prompt.md
|
+-- transcripts/
|   +-- README.md
|   +-- successful-run.md
|   +-- failed-run.md
|
+-- config/
|   +-- routine-config.json
|
+-- candidates/
|   +-- yesterday-commits.txt
|
+-- reports/
|   +-- success-report.md
|   +-- failure-report.md
|   +-- comparison-report.md
|
+-- evidence/
|   +-- README.md
|
+-- skills/
|   +-- routine-rehearsal-skill.md
|
+-- reviewers/
|   +-- routine-reviewer.md
|
+-- scripts/
    +-- setup-check.ps1
    +-- run-routine.ps1
    +-- simulate-success.ps1
    +-- simulate-failure.ps1
    +-- read-transcript.ps1
    +-- compare-runs.ps1
```

## 6. Setup

```powershell
cd Rehearse-a-Routine-for-Free\scripts
.\setup-check.ps1
```

## 7. Validation

Run the setup check above; it should end with SETUP CHECK: PASS.

## 8. Running the Successful Simulation

```powershell
.\simulate-success.ps1
```

This reads candidates\yesterday-commits.txt, produces a summary,
simulates pushing it to a claude/summary branch, and writes a full
transcript to transcripts\successful-run.md plus
reports\success-report.md.

## 9. Running the Failure Simulation

```powershell
.\simulate-failure.ps1
```

This attempts to read candidates\file-that-does-not-exist.txt (which
does not exist on purpose), safely catches the error without crashing
the script, and writes a full transcript to transcripts\failed-run.md
plus reports\failure-report.md.

## 10. Reading Transcripts

```powershell
.\read-transcript.ps1
```

Choose to read the successful transcript, the failed transcript, or
both. You can also just open the files directly:

```powershell
Get-Content ..\transcripts\successful-run.md
Get-Content ..\transcripts\failed-run.md
```

## 11. Comparing Runs

```powershell
.\compare-runs.ps1
```

Produces reports\comparison-report.md, with a side-by-side table
showing both runs' Platform Status and Task Result, and the final A5
lesson written out.

## 12. Using the Menu (Optional)

```powershell
.\run-routine.ps1
```

Gives you a simple numbered menu covering all of the above.

## 13. How This Local Simulation Maps to a Real Remote Claude Routine

| This local simulation | The real Project 9 exercise |
| --- | --- |
| scripts\simulate-success.ps1 | Firing a real Routine's normal prompt with a one-off run |
| scripts\simulate-failure.ps1 | Firing the same Routine with a deliberately broken prompt |
| transcripts\*.md | The real run transcript shown on the Routine's detail page |
| "Platform Status: GREEN" text in a file | The actual green status indicator in the Claude Code / claude.ai UI |
| candidates\yesterday-commits.txt | Real commit history the cloud Routine would read from a cloned repo |
| Simulated claude/summary branch | A real claude/summary branch pushed by the cloud Routine |

## 14. What Requires Claude.ai Later

This local scaffold cannot create a real cloud Routine, fire a real
one-off run, or produce a real run transcript on Anthropic's servers.
When your CCR/Claude Code setup is working again, the real version of
this exercise requires:

- A throwaway repo connected to your claude.ai / Claude Code account
- Creating a real Routine at claude.ai/code/routines, in the Desktop
  app (Routines -> New routine -> Remote), or via the CLI's /schedule
  command
- Firing it with a real one-off schedule or Run now
- Reading the real transcript on the Routine's detail page

## 15. Expected Output

Running `.\simulate-success.ps1` should print:

```
Routine simulation completed.
Platform Status: GREEN
Task Result: SUCCESS
```

Running `.\simulate-failure.ps1` should print:

```
Routine simulation completed.
Platform Status: GREEN
Task Result: FAILED

The simulated session completed, but the requested task failed.
Read the transcript to understand what actually happened.
```

Running `.\compare-runs.ps1` should print a markdown table showing
GREEN / GREEN for Platform Status and SUCCESS / FAILED for Task Result,
followed by the A5 lesson.

## 16. Done Checklist

- [ ] Setup check passes.
- [ ] Successful simulation runs and produces a transcript showing
      Task Result: SUCCESS.
- [ ] Failure simulation runs and produces a transcript showing
      Task Result: FAILED, without crashing the script.
- [ ] Both transcripts show Platform Status: GREEN.
- [ ] The comparison report clearly shows both statuses were GREEN
      while task results differed.
- [ ] You can state, in one sentence, why the status column alone
      could not tell the two runs apart.
- [ ] You understand the Remote vs Local distinction (A1) and that
      this project used the one-off trigger concept (A3), never a
      repeating schedule.
- [ ] You understand that this is a local simulation, and that the
      real Project 9 exercise requires an actual Remote Claude Routine.
- [ ] No CCR/Claude Code/OpenCode/API keys/internet were required for
      this local demonstration.