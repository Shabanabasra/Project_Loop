# Secrets Drill Skill

This is the project-specific knowledge a future Routine, reviewer, or
learner needs to understand the Project 10 Secrets Drill.

## The Mechanical Chain (memorize this, not just the rule)

```
.env is gitignored
  -> gitignored files do not reach GitHub
    -> a Routine starts from a fresh clone
      -> the fresh clone does not contain .env
        -> the secret is unavailable
          -> the task fails
```

## The Fix (both parts are required)

1. Put every secret in the Routine's **environment variables panel**,
   never in a `.env` file.
2. Add one clear line to the prompt: **"credentials are available as
   environment variables; do not look for a `.env` file."** Without
   this line, the model may still try the `.env` path out of habit and
   waste a turn on something that can never work.

## Steps to Rehearse This Safely

1. Use your OWN local `.env` file, with your OWN real key, kept
   strictly local and gitignored. Never paste a real key into a chat,
   a script, a config file, or any generated document.
2. First, rehearse the failure: simulate a fresh clone that excludes
   `.env` (because it is gitignored) and confirm the key cannot be
   found inside that simulated clone.
3. Second, rehearse the fix: set the same key as a real process
   environment variable instead, add the required prompt line, and
   confirm the key is now found.
4. Compare both transcripts side by side and confirm you can state, in
   your own words, the mechanical reason the first attempt failed.

## Reporting Discipline

Never print a secret's raw value in a transcript, report, config file,
or script output. Always report status as `[AVAILABLE]` or
`[NOT AVAILABLE]` only. This applies even during local rehearsal with
your own real key - the whole point of the drill is to build the habit
of never exposing the value, regardless of how sensitive it actually
is.