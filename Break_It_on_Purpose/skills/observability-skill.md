# Observability Skill

These are the rules that make a loop's failures diagnosable after the
fact, without watching it live or re-running it.

## Rules

1. Every run must write exactly one log line to logs\loop.log, whether
   it succeeds or fails.
2. The log line must include, at minimum: a run ID, a timestamp, the
   attempt number and maximum attempts, a status (SUCCESS or FAILED),
   a needs-human flag (YES or NO), and a reason when the status is
   FAILED.
3. progress.md must always be rewritten after every run to reflect the
   CURRENT state, not left showing an old, stale state.
4. When a loop reaches its maximum attempt limit while still failing,
   the final log line and progress.md must both clearly say
   NEEDS_HUMAN=true / Needs human: YES. This must never be left
   ambiguous or missing.
5. A human reading only logs\loop.log and progress.md, with no other
   context, must be able to answer: what failed, when, on which
   attempt, why, and what to do next.
6. If a failure cannot be explained from the log and progress.md alone,
   that is itself a bug in the loop's observability, and the first fix
   is always to add a clearer log line - not to add more guesswork.