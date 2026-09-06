# Evidence Folder

This folder exists to hold this project's guiding rule: diagnosis in
Project 7 is only ever allowed to use two sources of evidence.

1. logs\loop.log - the observable run-by-run record
2. progress.md - the spine, holding the latest known state

Nothing else counts as evidence for diagnose-failure.ps1. Specifically,
diagnosis must NOT be based on:

- Re-running scripts\morning-brief.ps1 to see what happens
- Reading source-data.txt to guess what should have happened
- Replaying or re-triggering the failed run in any way

This restriction is intentional. It simulates a real unattended loop
failing overnight, when nobody is there to watch it live. If your log
and your spine are not enough to explain a failure on their own, that is
itself an important finding: it means the loop is not observable enough
yet, and needs a clearer log line before anything else.