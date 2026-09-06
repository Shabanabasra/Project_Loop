# Morning Brief Skill

These are the steps the morning-brief loop follows on every run (every
beat), whether running normally or under a sabotage test.

## Steps

1. Read the current state from progress.md before doing anything else.
2. Read source-data.txt (the input for this run).
3. Produce a short brief summarizing what was read.
4. Check whether the run's success condition is met.
   - In normal mode, success means the source file was read and a brief
     was produced.
   - In sabotage mode, the success condition is deliberately broken, so
     the run is expected to fail.
5. Write one clear, structured log line to logs\loop.log, recording:
   run ID, timestamp, mode, attempt number, status, needs-human flag,
   whether the source was read, whether output was written, and the
   failure reason if any.
6. Rewrite progress.md with the latest state: last run, status, attempt,
   failure reason, needs-human flag, and a clear next action.
7. Never fail silently. If something goes wrong, the log line and
   progress.md must both say so clearly, not just stop without a trace.