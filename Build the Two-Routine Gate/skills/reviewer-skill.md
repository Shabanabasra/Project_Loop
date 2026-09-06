# Reviewer Skill - Two-Routine Gate

Reusable steps for the reviewer Routine (Routine 2).

## Steps

1. Run only when triggered by a pull-request event (opened or
   synchronize) - never on a schedule, never on demand.
2. Inspect the pull request and its full diff.
3. Apply every item in review-checklist.md, one by one, to this PR.
4. Based strictly on that checklist, produce exactly one verdict: PASS
   or FAIL. Never use a softer or vaguer verdict.
5. If FAIL, list every specific checklist item that did not pass, with
   a short reason for each.
6. Leave the verdict and reasons as a review comment on the PR.
7. Never modify any file in the PR, never fix anything yourself, and
   never merge the PR, regardless of your verdict. Your only output is
   a verdict and, if FAIL, your reasons.