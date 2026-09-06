# Issue 2: Missing null check causes crash

## Description
The function `getUserDisplayName(user)` crashes with a
"Cannot read property 'firstName' of null" error whenever `user` is null
or undefined. It should instead return the string "Guest" in that case.

## Example of the bug
- `getUserDisplayName(null)` → currently throws an error
- `getUserDisplayName(undefined)` → currently throws an error
- `getUserDisplayName({ firstName: "Sam" })` → should still return "Sam"

## Location (example)
File: `src/user.js`
Function: `getUserDisplayName`

## Acceptance criteria
- `getUserDisplayName(null)` returns "Guest" (no crash)
- `getUserDisplayName(undefined)` returns "Guest" (no crash)
- `getUserDisplayName({ firstName: "Sam" })` still returns "Sam"
- Existing tests in `test/user.test.js` must pass