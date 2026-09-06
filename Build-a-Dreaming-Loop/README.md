# Project 12: Build a Dreaming Loop

Source: Loop Engineering: A Crash Course - Appendix: Routines, end to
end, ProjectCard #12. This is the course's second and final capstone.

This is a safe, fully offline LOCAL SIMULATION. It never calls any AI
model, API, or GitHub. No real credentials are ever requested, stored,
or printed anywhere in this project. All branch/PR actions described
by its scripts are clearly labeled SIMULATED.

## 1. Project Purpose

Build a weekly loop that reads another loop's accumulated logs
(progress.md), finds any failure or correction that happened more than
once, and proposes the smallest possible rules-file change that would
prevent it - as a pull request on a claude/ branch, never as a direct
commit. A human must review and merge before the change takes effect.

## 2. Concepts Used

- **Concept 12 (spine and improvement loop):** dreaming-state.md is the
  spine. It is read at the start of every run and updated only after a
  successful run, so the loop never re-reviews the same entries twice.
- **Concept 11 (maker-checker):** the dreaming loop drafts a proposal;
  it never grades or merges its own work. A separate check (a human in
  the real version; scripts\validate-evidence.ps1 and
  scripts\compare-gate.ps1 in this rehearsal) independently verifies
  the claims by re-reading the source files directly.
- **Concept 6 (schedule heartbeat):** this loop is designed to fire on
  a weekly schedule, distinct from and slower than the loops whose logs
  it reads.
- **Part 5 (human gate):** the loop only ever drafts a PR. Only a human
  merging that PR can make the proposed rule change (or deletion) real.

## 3. Architecture

```
progress.md (accumulated logs from another loop, e.g. Project 3 or 8)
  |
  v
dreaming-state.md (this loop's own memory: last reviewed date)
  |
  v
scripts\simulate-dreaming-loop.ps1
  |
  +--> detects repeated FAILURE entries (2+ occurrences)
  +--> collects exact-date evidence
  +--> proposes smallest rule addition
  +--> proposes one deletion, chosen by real keyword-overlap comparison
  +--> creates a simulated claude/ branch and PR description
  +--> writes transcripts\dreaming-run-001.md and reports\dreaming-report.md
  +--> updates dreaming-state.md ONLY if the run succeeded
  |
  v
scripts\validate-evidence.ps1 (independently re-derives every claim
  directly from progress.md and a SHA256 checksum of improvement-rules.md
  - it does not trust the transcript)
  |
  v
scripts\compare-gate.ps1 (final cross-file gate verdict)
  |
  v
HUMAN REVIEW of the (real or simulated) PR
  |
  v
Only human merge can change improvement-rules.md
```

## 4. Files

```
Project_12_Build-a-Dreaming-Loop/
|
+-- README.md
+-- .gitignore
+-- progress.md              <- accumulated dated logs (input)
+-- dreaming-state.md        <- this loop's spine (last reviewed date)
+-- dream-loop-prompt.md     <- the real Routine prompt, for later use
+-- improvement-rules.md     <- the rules file this loop may PROPOSE
|                                changes to, but never edit directly
+-- config/
|   +-- dreaming-config.json
|
+-- logs/
|   +-- README.md
|   +-- week-001.md
|   +-- week-002.md
|   +-- week-003.md
|
+-- transcripts/
|   +-- README.md
|   +-- dreaming-run-001.md
|
+-- reports/
|   +-- dreaming-report.md
|   +-- evidence-report.md
|   +-- gate-report.md
|
+-- evidence/
|   +-- README.md
|   +-- planted-failure-evidence.md
|   +-- evidence-citations.md
|   +-- rules-checksum.txt   <- created automatically by plant-test-failure.ps1
|
+-- skills/
|   +-- dreaming-loop-skill.md
|
+-- reviewers/
|   +-- dreaming-loop-reviewer.md
|
+-- scripts/
    +-- setup-check.ps1
    +-- plant-test-failure.ps1
    +-- simulate-dreaming-loop.ps1
    +-- validate-evidence.ps1
    +-- compare-gate.ps1
    +-- read-transcript.ps1
```

## 5. How the Dreaming Loop Works

1. Read dreaming-state.md's "Last reviewed date".
2. Read progress.md; keep only entries dated strictly after that date.
3. Among those, find lines prefixed "FAILURE - "; group by exact text
   after the prefix; count occurrences.
4. Any text with 2+ occurrences is a repeated pattern. Anything with
   exactly 1 occurrence is ignored, even though it is a real failure.
5. Collect the repeated pattern's exact dates as evidence.
6. Propose the smallest rule addition that names the exact missing
   check (never a vague fix).
7. Propose exactly one deletion: build a word list from every entry
   examined this run, then for every existing rule count how many of
   its own words appear in that list. The rule with the lowest overlap
   is proposed for deletion - a real, computed comparison shown
   alongside every other rule's overlap count.
8. Create a simulated claude/ branch and a simulated PR description
   citing all evidence.
9. Confirm improvement-rules.md's SHA256 hash is unchanged before and
   after, against a baseline recorded by scripts\plant-test-failure.ps1.
10. Update dreaming-state.md's "Last reviewed date" only if the run
    succeeded with verified evidence.

## 6. The Human Gate

The dreaming loop never merges anything. It only ever produces a draft
(a simulated PR here; a real PR when connected to a real Routine).
config\dreaming-config.json sets "autoMerge": false and
"requiresHumanApproval": true. Only a human, by reviewing and merging
the PR, can make improvement-rules.md actually change.

## 7. Evidence Requirement

Every proposal must cite: exact dates, the exact repeated text, the
occurrence count, and why the proposed rule prevents the failure. Vague
proposals like "be more careful" are never acceptable.
scripts\validate-evidence.ps1 independently re-checks every citation
against progress.md directly (not the transcript), and re-checks
improvement-rules.md's integrity via a SHA256 hash comparison against
the baseline scripts\plant-test-failure.ps1 recorded.

## 8. Expected Result

Running the full sequence below should end with:

```
SETUP CHECK: PASS
...
DREAMING LOOP RESULT: SUCCESS
...
EVIDENCE VALIDATION: PASS
...
GATE REHEARSAL RESULT: PASS
```

## 9. Safety Rules

- improvement-rules.md is never edited directly by any script in this
  project - only read. This is checked with a real SHA256 hash
  comparison before and after each run, not just asserted.
- No script ever performs or claims a merge.
- No real GitHub branch, PR, or API call is ever made by these local
  simulation scripts - every such action is explicitly labeled
  SIMULATED in its output.
- No real credentials are requested, stored, or printed anywhere.
- dreaming-state.md is only updated after a run both finds real,
  independently-verifiable evidence and passes its own internal checks
  - never on a failed or inconclusive run.

## 10. Exact Windows PowerShell Commands

```powershell
cd "C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Project_12_Build-a-Dreaming-Loop\scripts"
.\setup-check.ps1
.\plant-test-failure.ps1
.\simulate-dreaming-loop.ps1
.\validate-evidence.ps1
.\compare-gate.ps1
.\read-transcript.ps1 all
```

## Done When Checklist

- [ ] Setup check passes.
- [ ] `plant-test-failure.ps1` confirms (or plants) the repeated
      failure pattern in progress.md and records a baseline checksum
      of improvement-rules.md.
- [ ] `simulate-dreaming-loop.ps1` detects the repeated pattern (3
      occurrences), ignores the one-off failure, proposes a specific
      (not vague) rule addition, proposes a justified deletion (lowest
      keyword overlap), and ends with `DREAMING LOOP RESULT: SUCCESS`.
- [ ] `validate-evidence.ps1` independently re-derives the same
      findings directly from progress.md and the checksum file, and
      ends with `EVIDENCE VALIDATION: PASS`.
- [ ] `compare-gate.ps1` confirms every gate property and ends with
      `GATE REHEARSAL RESULT: PASS`.
- [ ] improvement-rules.md is byte-for-byte unchanged after every run
      (verified by hash, not just claimed).
- [ ] dreaming-state.md's "Last reviewed date" only advances after a
      successful, independently-verified run.
- [ ] No merge, real or simulated, ever occurs.
- [ ] No real credentials appear anywhere in this project.