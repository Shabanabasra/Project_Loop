# Routine Rehearsal Skill

These are the reusable steps for safely rehearsing any Routine prompt
before committing it to a repeating schedule. This applies both to this
local simulation and to a real Remote Claude Routine later.

## Steps

1. **Never start with a repeating schedule.** Always prove a prompt
   works using a one-off run first (either a one-off scheduled run, or
   Run now). One-off scheduled runs do not count against the daily
   Routine cap, which is what makes this rehearsal free.

2. **Write a small, self-contained, checkable task first.** The prompt
   should do one specific thing whose result you can verify at a
   glance, such as "summarize yesterday's commits onto a
   claude/summary branch".

3. **Fire the normal version once.** Run it, then open the FULL
   transcript, not just the status indicator.

4. **Confirm real success in the transcript**, not just a green status.
   Check that the files it claims to have read were actually read, and
   that the output it claims to have produced actually matches what you
   asked for.

5. **Deliberately break the prompt once, on purpose.** The simplest,
   safest way (used in this project) is to point it at a file that does
   not exist. This lets you rehearse a real failure in a controlled way.

6. **Fire the broken version once**, the same way (one-off / Run now).

7. **Open this second transcript too.** Compare its status color to the
   first run's status color.

8. **State the A5 lesson in one sentence**: a green status only means
   the session ended without an infrastructure error - it does not mean
   the task itself succeeded. The only way to know the real outcome is
   to read the transcript.

9. **Only after both rehearsals pass this check** should a prompt be
   trusted enough to put on a real repeating schedule.