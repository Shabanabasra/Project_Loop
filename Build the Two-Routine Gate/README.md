# Project 11: Build the Two-Routine Gate

Source: Loop Engineering: A Crash Course - Appendix: Routines, end to
end, Practice: three routine drills, Project 11.

This is a safe, mostly-offline LOCAL SIMULATION of a real two-Routine
system. It never calls any AI model, API, GitHub, or the network. No
real credentials are ever requested, stored, or printed anywhere in
this project.

## 1. Project Goal

Build a two-Routine maker-checker system where several implementer
Routines each try to fix something on their own, and a completely
separate reviewer Routine independently decides which results are
actually good - with nothing merging automatically just because the
implementer says it is done.

## 2. A3 - Triggers

This project uses two different trigger types together, permanently
wired into one system:
- The IMPLEMENTER Routine uses a SCHEDULE trigger (fires repeatedly).
- The REVIEWER Routine uses a PULL REQUEST EVENT trigger (fires only
  when there is something to grade).

## 3. A4 - Secrets, State, and Identity

A real two-Routine system needs identity and permissions configured
correctly: the reviewer Routine needs read access to PR diffs; neither
Routine should need more access than its job requires. This project
never stores or requests real credentials - see "Real Routine Setup"
below for how authentication is handled in the real version.

## 4. A6 - Wiring a Multi-Routine Gate

The appendix's end-to-end pattern for wiring multiple Routines into one
coherent gate: separate triggers, separate responsibilities, and a
shared labeling convention that connects them. The label
(claude-fix) is what tells the implementer "here is work for you"; the
PR is what tells the reviewer "here is something to grade".

## 5. Implementer Role (Routine 1)

- Trigger: schedule (repeating)
- Finds ONE open issue labeled claude-fix per run
- Works on its own branch
- Drafts a fix, runs relevant tests/checks
- Opens a pull request
- NEVER reviews, approves, or merges its own work

See routine-implementer-prompt.md and skills\implementer-skill.md.

## 6. Reviewer Role (Routine 2)

- Trigger: pull_request event (opened / synchronize)
- Reads the PR diff
- Applies review-checklist.md item by item
- Leaves exactly PASS or FAIL, with reasons if FAIL
- NEVER implements, fixes, modifies code, or merges

See routine-reviewer-prompt.md and skills\reviewer-skill.md.

## 7. Trigger Flow

```
Schedule fires (repeating)
  -> Implementer picks one labeled issue
    -> Implementer opens a PR
      -> PR event fires
        -> Reviewer grades the PR independently
          -> PASS / FAIL, never an automatic merge
```

## 8. Label Convention

Issues eligible for the implementer Routine must carry the label
claude-fix. See issue-template.md and issues\issue-001.md through
issue-003.md for examples.

## 9. Branch Convention

One new, dedicated branch per issue, never reused across runs. See
each issue's "Expected Branch Name" field.

## 10. PR Flow

Implementer opens the PR referencing the issue number and describing
what changed and what was tested. The reviewer then reacts to that PR
via its own trigger - it never opens or authors a PR itself.

## 11. Review Checklist

See review-checklist.md for the full, objective, machine-checkable
list the reviewer must apply. PASS requires every required check to
pass; FAIL requires at least one specific, named failing check.

## 12. No-Auto-Merge Rule

Neither Routine ever merges a pull request, regardless of verdict.
config\implementer-config.json and config\reviewer-config.json both
set "autoMerge": false. Merging (if ever desired) is a separate, human
decision outside the scope of this gate.

## 13. Local Simulation

Because connecting real Routines requires a real repository and real
GitHub access, this project ships local PowerShell simulations so you
can rehearse and verify the pattern safely first:

```powershell
cd scripts
.\setup-check.ps1
.\simulate-implementer.ps1
.\simulate-reviewer.ps1
.\compare-gate.ps1
.\read-transcript.ps1 all
```

Every simulated action is clearly labeled SIMULATED in its output
files. No real GitHub issue, branch, pull request, or review comment is
ever created by these scripts.

## 14. Real Routine Setup (Later)

To connect this pattern to a real repository:
1. Create Routine 1 (implementer) with a schedule trigger, using the
   prompt in routine-implementer-prompt.md.
2. Create Routine 2 (reviewer) with a pull-request trigger, using the
   prompt in routine-reviewer-prompt.md.
3. Label 2-3 real issues with claude-fix.
4. Provide any needed authentication (e.g. GITHUB_TOKEN) only through
   each Routine's environment variables panel - never in a prompt,
   config file, or chat message.
5. Let both Routines run and read every transcript, per the A5 lesson
   from Project 9: a green status does not mean the task succeeded.

## 15. Safety Precautions

- Never paste a real GitHub token, Claude credential, or any other
  secret into this project's files or into any chat.
- Reference credentials only by environment variable name (e.g.
  GITHUB_TOKEN), never by value.
- Keep autoMerge false until you have manually verified the gate
  behaves correctly on real, low-stakes issues.
- Start with a small number of labeled issues, exactly as this
  rehearsal does with three.

## 16. Exact PowerShell Commands

```powershell
cd "C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Project_11_Two-Routine-Gate\scripts"
.\setup-check.ps1
.\simulate-implementer.ps1
.\simulate-reviewer.ps1
.\compare-gate.ps1
.\read-transcript.ps1 implementer
.\read-transcript.ps1 reviewer
.\read-transcript.ps1 all
```

## 17. Expected Results

`.\simulate-implementer.ps1` produces three transcripts, each showing
exactly one issue selected and "Task Result: PR OPENED (SIMULATED)".

`.\simulate-reviewer.ps1` produces three transcripts, each showing an
explicit "Verdict: PASS" or "Verdict: FAIL" derived from genuine checks
against the implementer's transcript content.

`.\compare-gate.ps1` ends with:
```
GATE REHEARSAL RESULT: PASS
```
(or FAIL, with specific problems listed, if any separation check did
not hold).

## Done When Checklist

- [ ] Setup check passes.
- [ ] Three independent implementer runs each select exactly one
      labeled issue and produce their own simulated branch and PR.
- [ ] Three independent reviewer runs each fire only in response to a
      simulated PR (never a schedule) and produce a genuine PASS/FAIL.
- [ ] No implementer transcript contains a Verdict line.
- [ ] No reviewer transcript claims to have created a branch or
      modified code.
- [ ] No transcript anywhere claims a merge occurred.
- [ ] `compare-gate.ps1` reports GATE REHEARSAL RESULT: PASS.
- [ ] You can explain, in your own words, why this gate only works
      because the two roles and two triggers stay strictly separate.
- [ ] No real credentials were ever requested, pasted, or stored
      anywhere in this project.