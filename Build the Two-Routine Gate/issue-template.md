# Issue Template - Two-Routine Gate

Use this template for any new issue you want the implementer Routine
to pick up. Copy this structure into a new file under issues\.

```
# Issue <number>: <short title>

Label: claude-fix

## Description

<what is wrong, in plain language>

## Acceptance Criteria

- <criterion 1>
- <criterion 2>

## Expected Test / Check

<the specific command or check that proves the fix works>

## Expected Branch Name

claude/fix-issue-<number>
```

Keep each issue small, safe, and independently fixable. Never require a
destructive operation (no deleting data, no force-pushing over other
work, no touching production systems).