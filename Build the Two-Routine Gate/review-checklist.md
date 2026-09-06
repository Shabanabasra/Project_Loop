# Review Checklist - Two-Routine Gate

The reviewer Routine applies this checklist to every pull request,
item by item. This checklist is what turns "grading" into a real,
objective, machine-checkable process rather than vague judgment.

## Required Checks

1. **PR corresponds to an open labeled issue** - the PR description
   references a real issue number that was labeled claude-fix.
2. **Requested issue is actually addressed** - the change described in
   the PR actually satisfies the issue's acceptance criteria.
3. **Changes are scoped to the issue** - no unrelated files or
   unrelated logic were changed.
4. **Implementation is understandable** - the PR description explains
   what changed and why, in plain language a reviewer can follow.
5. **Tests/checks were run** - the PR description states that the
   issue's Expected Test / Check was actually run.
6. **Tests/checks pass** - the recorded result of that test/check is a
   pass, not a failure or "assumed passing".
7. **No obvious unrelated changes** - nothing outside the scope of the
   issue appears to have been touched.
8. **No secrets exposed** - the PR diff and description contain no
   credentials, tokens, or key values.
9. **Branch/PR identity is correct** - the branch name matches the
   issue's Expected Branch Name convention.
10. **Implementer did not provide its own PASS/FAIL verdict** - the PR
    description does not contain a self-graded verdict of any kind.

## Verdict Rule

- **PASS** = every required check above is satisfied.
- **FAIL** = one or more required checks are not satisfied. List the
  specific failing item(s) and why.

Never use a verdict other than exactly PASS or exactly FAIL. Never use
softer language such as "mostly good," "looks okay," or "almost
passes."