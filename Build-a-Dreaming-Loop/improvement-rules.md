# Improvement Rules

These are the current operating rules for the implementer loops (for
example the morning-brief loop or the dependency-audit loop). The
dreaming loop may PROPOSE changes to this file, as a simulated pull
request on a claude/ branch, but must NEVER edit this file directly.
Only a human, by reviewing and merging that PR, can actually change
these rules.

scripts\simulate-dreaming-loop.ps1 picks a deletion candidate by
comparing each rule's own words against the words actually used in the
log entries it reviewed that run - the rule with the least overlap is
proposed for deletion. This is a real, computed comparison, not a
guess, and it needs no special tagging in this file.

## Current Rules

1. Always run relevant tests before opening a PR.
2. Keep changes scoped to the issue at hand.
3. Never commit directly to main.
4. Double-check dependency versions before upgrading.
5. Use clear, descriptive commit messages.