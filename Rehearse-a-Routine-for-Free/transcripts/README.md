# Transcripts Folder

This folder holds the full run transcripts for both simulated Routine
runs in this local rehearsal:

- successful-run.md - the transcript for the normal, working prompt
- failed-run.md - the transcript for the deliberately broken prompt

Both files are regenerated every time you run scripts\simulate-success.ps1
or scripts\simulate-failure.ps1. The content already present in these
files (before you run anything) is example content showing the expected
shape of a real run.

## Why Transcripts Matter (the A5 Lesson)

A real cloud Routine shows a green or red status for every run. Per the
Loop Engineering Crash Course appendix: "a green status means the
session ended without an infrastructure error. It does not mean your
task succeeded." The only way to know what actually happened is to open
and read the full transcript - never just the status color.

This rehearsal deliberately produces two runs that BOTH show: