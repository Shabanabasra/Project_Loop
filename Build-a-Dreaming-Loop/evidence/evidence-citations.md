# Evidence Citations

This is the exact citation chain the dreaming loop's proposal in
transcripts\dreaming-run-001.md relies on. Every claim below can be
independently checked against progress.md and improvement-rules.md
directly.

## Citation 1

Claim: repeated failure "validation step failed because required field
was not checked." occurred 3 times.
Source lines: progress.md, dated 2026-08-17, 2026-08-24, 2026-08-31,
each prefixed "FAILURE - ".

## Citation 2

Claim: one-off failure "network timeout while fetching commit data
(transient)." occurred only once and was correctly excluded.
Source line: progress.md, dated 2026-08-26.

## Citation 3

Claim: Rule 5 ("Use clear, descriptive commit messages.") has the
lowest keyword overlap (1 match) with the vocabulary of all 9 entries
reviewed this window, compared to Rule 1 (4 matches), Rule 2 (3
matches), Rule 3 (2 matches), and Rule 4 (3 matches).
Source: scripts\simulate-dreaming-loop.ps1 builds a word list from
every reviewed entry's text and counts, for each rule, how many of the
rule's own words appear in that list. This is a real, computed
comparison performed fresh each run - not a fixed tag or a guess.

## Citation 4

Claim: improvement-rules.md was not modified by this run.
Source: SHA256 hash of improvement-rules.md, recorded as a baseline by
scripts\plant-test-failure.ps1 into evidence\rules-checksum.txt, and
re-compared by both scripts\validate-evidence.ps1 and
scripts\compare-gate.ps1. Any difference would be reported as a
failure, not silently ignored.