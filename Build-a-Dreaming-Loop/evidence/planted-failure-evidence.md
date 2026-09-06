# Planted Failure Evidence

This file documents the deliberately planted repeated failure used to
test the dreaming loop, and confirms it can be found in progress.md by
plain text search - not just by trusting the dreaming loop's own
claims.

## Planted repeated failure

Text: "validation step failed because required field was not checked."
(recorded in progress.md with the "FAILURE - " prefix so the scripts
can reliably identify it as a failure entry)

## Where it appears in progress.md

- Line: "- 2026-08-17: FAILURE - validation step failed because required field was not checked."
- Line: "- 2026-08-24: FAILURE - validation step failed because required field was not checked."
- Line: "- 2026-08-31: FAILURE - validation step failed because required field was not checked."

Three occurrences, all after the dreaming-state.md baseline date of
2026-08-10, so all three are eligible evidence.

## Planted one-off (negative control)

Text: "network timeout while fetching commit data (transient)."

- Line: "- 2026-08-26: FAILURE - network timeout while fetching commit data (transient)."

Exactly one occurrence. This exists specifically to verify the
dreaming loop does NOT turn a single occurrence into a proposal.

## How to independently re-verify

```powershell
Select-String -Path ..\progress.md -Pattern "validation step failed because required field was not checked"
Select-String -Path ..\progress.md -Pattern "network timeout while fetching commit data"
```

The first command should return exactly 3 matches. The second should
return exactly 1 match. scripts\validate-evidence.ps1 performs this
same kind of check programmatically, directly against progress.md.