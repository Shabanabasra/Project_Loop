Project 7: Break It on Purpose

Source: Loop Engineering: A Crash Course - Practice Projects, Project 7.

This is a safe, fully offline, local scaffold. It does NOT require CCR, Claude Code, OpenCode, or any AI model. Everything here runs with plain PowerShell and plain text files on your own machine.

1. What Project 7 Teaches

Project 7 teaches you to deliberately break your own loop, on purpose, while you are watching and it costs nothing - instead of discovering for the first time during a real overnight run that your loop fails silently and you have no idea why. It also teaches you to work out roughly how much a loop costs to run every month.

2. What Observability Means

Observability means being able to tell what happened to a loop after the fact, just from the traces it leaves behind (a log file and a progress file), without needing to watch it live or re-run it. A loop that is observable tells you clearly: what failed, when, and whether a human needs to step in.

3. What Concept 13 (Cost) Means

Concept 13 is the simple math of turning "tokens per beat" (one run) into a real monthly number, by multiplying the tokens used in one run by how often the loop fires (its cadence). This project simulates that math with estimate-cost.ps1, using numbers you enter yourself.

4. What Concept 14 Means

Concept 14, used alongside observability and cost, is the discipline of designing loops so they fail loudly and clearly instead of quietly doing nothing. A loop that fails silently is dangerous precisely because nobody notices. A loop that fails loudly, with a clear NEEDS HUMAN note, is safe to leave running unattended.

5. Folder Structure
Project_7_Break_It_on_Purpose/
|
+-- README.md
+-- progress.md
+-- source-data.txt
|
+-- logs/
|   +-- loop.log
|
+-- scripts/
|   +-- morning-brief.ps1
|   +-- sabotage-loop.ps1
|   +-- diagnose-failure.ps1
|   +-- estimate-cost.ps1
|   +-- setup-check.ps1
|
+-- config/
|   +-- loop-config.json
|   +-- sabotage-config.json
|
+-- reports/
|   +-- cost-report.md
|   +-- diagnosis-report.md
|
+-- evidence/
|   +-- README.md
|
+-- skills/
|   +-- morning-brief-skill.md
|   +-- observability-skill.md
|
+-- reviewers/
    +-- failure-reviewer.md
6. How to Run setup-check.ps1

Open PowerShell, go to the scripts folder, and run it:

cd Project_7_Break_It_on_Purpose\scripts
.\setup-check.ps1

It prints [OK] or [MISSING] for every required file, and finishes with SETUP CHECK: PASS or SETUP CHECK: FAIL.

7. How to Run the Normal Loop

From the scripts folder:

.\morning-brief.ps1

This reads source-data.txt, writes a simulated brief, updates progress.md, and appends a line to logs\loop.log. It should succeed.

8. How to Run Cost Estimation

From the scripts folder:

.\estimate-cost.ps1

It will ask you for approximate input tokens per beat, output tokens per beat, runs per day, and a price per 1 million tokens for input and output. It then prints and saves a monthly estimate to reports\cost-report.md. All numbers are clearly labeled as estimates, not real provider pricing.

9. How to Activate Sabotage Method 1 (Missing File)

Open config\sabotage-config.json and set:

"sabotageEnabled": true,
"method": "missingFile",
"maxAttempts": 3

Then run:

.\sabotage-loop.ps1
10. How to Activate Sabotage Method 2 (Impossible Condition)

Open config\sabotage-config.json and set:

"sabotageEnabled": true,
"method": "impossibleCondition",
"maxAttempts": 3

Then run:

.\sabotage-loop.ps1
11. How the Maximum Attempt Limit Protects Against Infinite Execution

sabotage-loop.ps1 reads maxAttempts from config\sabotage-config.json (for example 3) and runs morning-brief.ps1 in sabotage mode at most that many times. Every attempt is counted and printed. Once the limit is reached, the loop stops itself, writes a final FAILED log line with NEEDS_HUMAN=true, and updates progress.md to say NEEDS HUMAN: YES. It can never run forever, by design.

12. How to Diagnose the Failure

From the scripts folder:

.\diagnose-failure.ps1

This script reads ONLY logs\loop.log and progress.md. It does not re-run morning-brief.ps1, does not look at source-data.txt, and does not replay anything. It writes its findings to reports\diagnosis-report.md.

13. How to Inspect logs\loop.log

Open the file directly in Notepad, or run:

Get-Content ..\logs\loop.log

Each line is one run record, with fields like RUN_ID, TIMESTAMP, STATUS, ATTEMPT, NEEDS_HUMAN, and REASON when a run failed.

14. How to Inspect progress.md

Open the file directly in Notepad, or run:

Get-Content ..\progress.md

progress.md always reflects the latest known state: the last run, its status, attempt number, failure reason if any, whether a human is needed, and a suggested next action.

15. How Diagnosis Works Without Replaying the Run

diagnose-failure.ps1 treats logs\loop.log and progress.md as the only source of truth. It parses the text of those two files, pulls out the most recent FAILED entries and the current spine state, and builds its report from that alone. This mirrors real unattended loops: at 3 AM, nobody is there to watch it fail live, so the log and the spine are all you get.

16. How to Restore Normal Operation After the Exercise

Open config\sabotage-config.json and set:

"sabotageEnabled": false

Then run the normal loop again to confirm it succeeds:

.\morning-brief.ps1
17. What Counts as Project 7 Complete

See the Done-When Checklist below. Project 7 is complete when every box is checked.

Done-When Checklist
 Setup check passes.
 Normal loop runs successfully.
 progress.md is updated.
 loop.log contains an observable run record.
 Monthly token/cost estimate is calculated.
 Sabotage method 1 works OR method 2 works.
 Maximum attempt limit prevents infinite execution.
 Failure is clearly logged.
 progress.md contains NEEDS HUMAN: YES.
 Failure can be diagnosed from log + progress.md alone.
 diagnosis-report.md is generated.
 Diagnosis identifies what failed and when.
 Normal configuration can be restored.
 No CCR/Claude Code/OpenCode is required for the local demonstration.