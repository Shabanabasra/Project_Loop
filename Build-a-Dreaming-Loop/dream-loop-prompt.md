# Dream Loop Prompt

This is the prompt for the DREAMING loop Routine. It runs on a WEEKLY
schedule trigger and does exactly one job per run: look back over the
week's logs, find any failure or correction that happened more than
once, and propose the smallest possible fix as a pull request - never
as a direct commit.

## The Prompt

```
On each weekly run:

1. Read dreaming-state.md and note the "Last reviewed date".
2. Read progress.md and consider only entries dated strictly after
   that date.
3. Among those entries, identify the ones describing a failure (lines
   prefixed "FAILURE - "). Group them by their exact description text
   and count how many times each exact text repeats.
4. Any description repeating 2 or more times is a repeated pattern.
   Ignore any description that appears only once, even though it is a
   real failure - a single occurrence is not a pattern.
5. For the repeated pattern with the most occurrences, collect its
   exact dates as evidence.
6. Propose the smallest possible change to improvement-rules.md that
   would have prevented this repeated failure. Do not propose a vague
   fix like "be more careful" - name the exact check that was missing.
7. Also propose exactly one existing rule in improvement-rules.md to
   delete: compare each rule's own words against the words actually
   used in the entries you reviewed this run, and propose the rule
   with the least overlap - the one recent runs demonstrably had the
   least to do with.
8. Create a new branch whose name starts with claude/, and open a pull
   request from it containing your proposed addition and your proposed
   deletion, citing the exact dates and occurrence count as evidence.
9. Do NOT edit improvement-rules.md directly. Your only output is the
   pull request.
10. If, and only if, this run completes successfully with real,
    verifiable evidence, update dreaming-state.md's "Last reviewed
    date" to the most recent date you examined. If no repeated pattern
    is found, or your evidence cannot be verified, do NOT update it.

The proposed rule change only takes effect if a human reviews and
merges the pull request. You never merge your own pull request.
```

## Trigger

Schedule trigger (weekly), configured in config\dreaming-config.json.

## Role Boundary

This loop only reads logs and drafts a proposal. It never edits
improvement-rules.md directly, and it never merges its own PR. A human
must review and merge before any rule actually changes.