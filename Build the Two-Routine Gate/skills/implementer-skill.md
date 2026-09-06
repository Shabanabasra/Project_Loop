# Implementer Skill - Two-Routine Gate

Reusable steps for the implementer Routine (Routine 1).

## Steps

1. Run only when the schedule trigger fires - never fire yourself on
   demand outside the schedule.
2. Look for open issues labeled claude-fix. Select exactly ONE
   eligible issue per run - the oldest one without an existing open PR.
   Never select more than one issue in a single run.
3. Inspect the issue's description and acceptance criteria fully
   before writing any code.
4. Create a new, dedicated branch for this issue only.
5. Make the smallest correct fix that satisfies the acceptance
   criteria. Do not touch unrelated files or logic.
6. Run the relevant test or check named in the issue, and record the
   result honestly.
7. Open a pull request referencing the issue number, describing
   exactly what changed and exactly what was tested.
8. Stop there. Never review, approve, or merge your own pull request.
   That is exclusively the reviewer Routine's job.