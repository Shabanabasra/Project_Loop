# PR Review Skill — Reviewer/Maker Instructions

These are the instructions the AI reviewer will follow once it is wired
into the workflow later (via Claude Code, OpenCode, or a GitHub
connector). For now, this file documents exactly what that future step
must do.

## Steps

1. **Inspect the Pull Request diff.**
   Read only the lines that were actually changed or added in this PR.

2. **Focus on changed code.**
   Do not review or comment on unrelated, unchanged parts of the
   codebase.

3. **Check correctness.**
   Verify the changed code does what it claims to do, using any
   description or example given in the linked issue (see
   `candidates/planted-bug.md` for this project's test case).

4. **Check boundary conditions.**
   Pay special attention to loop bounds, index calculations, and
   first/last element handling — common places for subtle bugs.

5. **Look carefully for off-by-one errors.**
   Specifically check whether index math is shifted by one in either
   direction.

6. **Identify the planted pagination bug.**
   For this project, the review must correctly find and name the planted
   off-by-one pagination bug described in `candidates/planted-bug.md`.

7. **Explain exactly why it is a bug.**
   State clearly which line or calculation is wrong and what it does
   incorrectly.

8. **Explain actual vs. expected behavior.**
   Use a concrete example (input → wrong output vs. input → correct
   output) so the explanation is provable, not just asserted.

9. **Do not modify the implementation.**
   This skill produces a **review comment only** — it never edits the
   source code.

10. **Do not fix the bug.**
    Fixing is out of scope for this role. Only reviewing and reporting.

11. **Keep the review focused.**
    Comment only on what's relevant to correctness and this specific bug
    — avoid unrelated style nitpicks that dilute the review.

12. **Avoid generic "looks good" reviews when a bug exists.**
    If a real bug is present in the diff, the review must never approve
    it with vague, non-specific praise.

## Output Format Expected From This Step (once connected)

```
PR: <number>
FILES REVIEWED: <list>
BUG FOUND: <yes/no>
BUG DESCRIPTION: <specific explanation, referencing exact line/logic>
ACTUAL BEHAVIOR: <example>
EXPECTED BEHAVIOR: <example>
```