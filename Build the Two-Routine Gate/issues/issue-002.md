## Issue Number
002

## Title
Missing null check causes crash

## Label
claude-fix

## Description
getUserDisplayName(user) crashes when user is null or undefined. It
should return "Guest" in that case instead.

## Acceptance Criteria
- getUserDisplayName(null) returns "Guest" (no crash)
- getUserDisplayName(undefined) returns "Guest" (no crash)
- getUserDisplayName({ firstName: "Sam" }) still returns "Sam"

## Expected Test/Check
test/user.test.js

## Expected Branch Name
fix/issue-002-null-check-crash