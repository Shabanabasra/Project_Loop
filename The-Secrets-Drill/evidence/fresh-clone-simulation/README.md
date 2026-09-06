# Project 10: The Secrets Drill

Source: Loop Engineering: A Crash Course - Appendix: Routines, end to
end, Practice: three routine drills, Project 10.

This is a safe, mostly-offline LOCAL REHEARSAL. It uses your own real
OpenRouter key only on your own machine, in your own local `.env` file
or your own PowerShell session's environment variable - never inside
any file in this project, never printed by any script, and never
pasted into a chat.

## 1. Project Goal

Deliberately fail the classic `.env` secrets mistake once, on purpose,
in a safe rehearsal, so you feel exactly why it fails - then fix it the
correct way - so you never make this mistake by accident on a real
Routine that matters.

## 2. A4 - Secrets, State, and Identity

The mechanical rule this drill exists to teach: secrets go in the
environment variables panel, never in a `.env` file. The reason is
purely mechanical: `.env` is gitignored, gitignored files never reach
GitHub, and since a Routine always works from a fresh clone, the cloud
clone therefore never contains them. The Routine fires, finds nothing,
and fails (or worse, improvises).

## 3. A2 - The Environment

Every Routine runs inside a cloud environment that controls network
access, environment variables, and a setup script. This drill uses the
environment variables piece specifically - the correct, permanent home
for any secret a Routine needs.

## 4. Why .env Fails (the Mechanical Chain)

```
.env is gitignored
  -> gitignored files do not reach GitHub
    -> a Routine starts from a fresh clone
      -> the fresh clone does not contain .env
        -> the secret is unavailable
          -> the task fails
```

## 5. Why Fresh Clones Matter

A real cloud Routine never reuses your local working copy. It always
starts from a brand-new clone of your repository. Anything not tracked
by git - including anything excluded by `.gitignore`, like `.env` -
simply does not exist in that fresh clone. This project's
`scripts\simulate-env-failure.ps1` proves this locally by actually
building a fresh-clone-style folder that excludes `.env`, and then
genuinely attempting (and failing) to read `.env` from inside it.

## 6. First Rehearsal (Deliberate Failure)

```powershell
.\simulate-env-failure.ps1
```

This script:
- Checks whether your local `.env` exists (without reading its value)
- Confirms `.env` is listed in `.gitignore`
- Builds a simulated fresh clone that excludes `.env`
- Genuinely attempts to read `.env` from inside that simulated clone
- Records the real failure in `transcripts\failed-env-file-run.md` and
  `reports\failure-report.md`

## 7. Second Rehearsal (Correct Environment-Variable Solution)

First, set your key for this PowerShell session only (it does not
persist after you close the window, and it is never written to any
file):

```powershell
$env:OPENROUTER_API_KEY = "YOUR_REAL_KEY_HERE"
```

Then run:

```powershell
.\simulate-environment-success.ps1
```

This script:
- Reads `OPENROUTER_API_KEY` directly from the process environment
- Never opens or reads `.env` at any point
- Never prints the key value - only reports `[AVAILABLE]` /
  `[NOT AVAILABLE]` and a character-length check
- Records the result in `transcripts\successful-environment-run.md`
  and `reports\success-report.md`

If the environment variable is not set, the script tells you exactly
what to do and exits without falsely claiming success.

## 8. OpenRouter Key Safety

- Never paste your real OpenRouter key into a chat with any assistant.
- Never put your real key into any file in this project - not the
  README, not a transcript, not a report, not a config file, not a
  script.
- Your real key should only ever exist in your own local `.env` file
  (which is gitignored) or as a value you type directly into your own
  PowerShell session with `$env:OPENROUTER_API_KEY = "..."`.
- Every script in this project reports key status only, as
  `[AVAILABLE]` or `[NOT AVAILABLE]`, never the value itself.

## 9. Project Structure

```
Project_10_The-Secrets-Drill/
|
+-- README.md
+-- .gitignore
+-- .env.example
+-- routine-prompt.md
|
+-- config/
|   +-- routine-config.json
|
+-- transcripts/
|   +-- README.md
|   +-- failed-env-file-run.md
|   +-- successful-environment-run.md
|
+-- reports/
|   +-- failure-report.md
|   +-- success-report.md
|   +-- comparison-report.md
|
+-- evidence/
|   +-- README.md
|   (fresh-clone-simulation\ created automatically at run time)
|
+-- skills/
|   +-- secrets-drill-skill.md
|
+-- reviewers/
|   +-- secrets-drill-reviewer.md
|
+-- scripts/
    +-- setup-check.ps1
    +-- simulate-env-failure.ps1
    +-- simulate-environment-success.ps1
    +-- compare-runs.ps1
    +-- read-transcript.ps1
```

## 10. Exact PowerShell Commands

```powershell
cd "C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Project_10_The-Secrets-Drill\scripts"
.\setup-check.ps1
.\simulate-env-failure.ps1
$env:OPENROUTER_API_KEY = "YOUR_REAL_KEY_HERE"
.\simulate-environment-success.ps1
.\compare-runs.ps1
.\read-transcript.ps1 failed
.\read-transcript.ps1 success
```

## 11. Expected Outputs

`.\simulate-env-failure.ps1` ends with:
```
Task Result: FAILED
```

`.\simulate-environment-success.ps1` (after setting the env var) ends
with:
```
Task Result: SUCCESS
```

`.\compare-runs.ps1` prints a table showing `FAILED` vs `SUCCESS`
Task Result values and `NO` vs `YES` for Secret available, followed by
the mechanical chain and the A4 lesson. No real key value appears in
any of this output.

## 12. Done When Checklist

- [ ] Setup check passes.
- [ ] `.env` failure rehearsal runs and genuinely proves the fresh
      clone lacks `.env` (not just a hardcoded FAILED message).
- [ ] `.gitignore` genuinely lists `.env`.
- [ ] Environment-variable rehearsal succeeds once
      `$env:OPENROUTER_API_KEY` is set for the session.
- [ ] `routine-prompt.md` contains the exact required sentence:
      "credentials are available as environment variables; do not
      look for a .env file."
- [ ] Neither transcript, report, config, skill, or reviewer file ever
      contains a real key value.
- [ ] Comparison report shows differing Task Result and Secret
      available values for the two runs.
- [ ] You can explain, in your own words, the mechanical reason the
      first run failed.
- [ ] No real OpenRouter key was ever pasted into this chat or written
      into any file in this project.