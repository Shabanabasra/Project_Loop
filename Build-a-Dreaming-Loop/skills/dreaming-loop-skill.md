# Dreaming Loop Skill

Reusable steps for the dreaming loop, whether run as a real weekly
Routine or this local simulation.

## Steps

1. Read dreaming-state.md first. Note the "Last reviewed date" - never
   hardcode a date.
2. Read progress.md. Consider only entries dated strictly after the
   last reviewed date - entries on or before that date were already
   handled by a previous run.
3. Among those entries, identify the ones prefixed "FAILURE - ". Strip
   the prefix and group the remaining text by exact match, counting
   occurrences.
4. Any text appearing 2 or more times is a repeated pattern. Any text
   appearing exactly once must be ignored - it is a one-off, not a
   pattern, even if it is a genuine failure.
5. For the repeated pattern with the most occurrences, collect every
   exact date it appears on. This is your evidence.
6. Propose the smallest possible addition to improvement-rules.md that
   would prevent this specific repeated failure. Name the exact missing
   check - never write a vague fix like "be more careful".
7. Also propose exactly one existing rule to delete: build a word list
   from every entry considered this run, then for each existing rule
   count how many of the rule's own words appear in that list. Propose
   the rule with the lowest overlap - it is the one recent runs
   demonstrably had the least to do with. This is a real computation,
   not a fixed tag.
8. Create a branch name starting with claude/. Write a pull request
   description that cites your evidence explicitly: dates, exact text,
   occurrence count, and why the proposed rule prevents the failure.
9. NEVER edit improvement-rules.md directly. Your only output is a
   simulated (or real) pull request.
10. NEVER merge your own pull request. A human must review and merge
    before either the addition or the deletion takes effect.
11. Only update dreaming-state.md's "Last reviewed date" if this run
    completed successfully with verified evidence. If no repeated
    pattern is found, or evidence cannot be verified, do NOT update it.