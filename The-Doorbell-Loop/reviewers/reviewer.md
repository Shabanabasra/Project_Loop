# Reviewer Skill — Checker Instructions

This is the CHECKER role — separate from the PR review step in
`skills/pr-review-skill.md`. The checker does not write the review; it
grades whether that review actually did its job.

## What the Checker Must Do

1. **Inspect the PR diff.**
   Look at the same changed code the reviewer looked at.

2. **Check the acceptance criteria.**
   Compare the review that was produced against the acceptance criteria
   listed in `candidates/planted-bug.md`.

3. **Verify the planted bug was detected.**
   Confirm the review explicitly names the off-by-one pagination error
   — not just a vague mention of "possible issues."

4. **Verify the technical explanation is correct.**
   Confirm the review correctly explains actual vs. expected behavior,
   and correctly points to the start-index calculation as the cause.

5. **Reject incomplete reviews.**
   If the review is vague, generic, or misses the specific bug, this is
   a FAIL — regardless of how well-written or confident it sounds.

6. **Never modify implementation files.**
   The checker only reads and grades. It never touches source code.

7. **Never fix the bug.**
   Fixing is completely out of scope for this role.

8. **Return a clear verdict.**
   The verdict must be exactly one of: