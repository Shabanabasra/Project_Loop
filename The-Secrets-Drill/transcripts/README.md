# Transcripts Folder

This folder holds the full run transcripts for both simulated Routine
runs in the Project 10 Secrets Drill:

- failed-env-file-run.md - the transcript for the first run, which
  relies on a .env file a fresh clone never receives
- successful-environment-run.md - the transcript for the second run,
  which uses the environment variables panel instead

Both files are regenerated every time you run
scripts\simulate-env-failure.ps1 or
scripts\simulate-environment-success.ps1.

## Why Transcripts Matter (the A4 Lesson)

.env is gitignored, so it never reaches the cloud clone. The Routine
finds no credentials and fails or improvises. The only way to confirm
this mechanically, rather than just believing it, is to actually
rehearse both runs and read what each transcript shows.

Neither transcript in this project ever prints the real OpenRouter key
value. Both report the key's status as [AVAILABLE] or [NOT AVAILABLE]
only.