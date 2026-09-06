# Secrets Drill Reviewer - Project 10

This file defines the checklist used to judge whether the Project 10
Secrets Drill was completed correctly. This reviewer never modifies any
file; it only inspects the evidence and reports a verdict.

## What the Reviewer Checks

1. Is .env actually gitignored?
   - The project's .gitignore file must list `.env` on its own line.

2. Does a local .env exist only for rehearsal purposes?
   - The learner's own local .env file should exist on their machine
     for their own use, but this project must never read, copy, or
     print its real contents.

3. Does the simulated fresh clone actually lack .env?
   - evidence\fresh-clone-simulation\ must exist, and must NOT contain
     a .env file, proving the exclusion was real, not just claimed.

4. Did the first run fail because the secret was unavailable?
   - transcripts\failed-env-file-run.md must show OPENROUTER_API_KEY =
     [NOT AVAILABLE] and Task Result: FAILED, with the mechanical
     reason explained (gitignored file never reaches the fresh clone).

5. Did the second run succeed through the environment variable?
   - transcripts\successful-environment-run.md must show
     OPENROUTER_API_KEY = [AVAILABLE] and Task Result: SUCCESS, sourced
     from a process environment variable, not a file.

6. Does the required prompt instruction exist?
   - routine-prompt.md's "Second Run Prompt" section must contain the
     exact line: "credentials are available as environment variables;
     do not look for a .env file."

7. Is the real secret ever printed anywhere?
   - No transcript, report, config file, skill file, reviewer file, or
     script may contain a real OpenRouter API key value. All must use
     [AVAILABLE] / [NOT AVAILABLE] status reporting instead.

8. Were both transcripts actually reviewed?
   - reports\comparison-report.md must reference specific details from
     both transcripts, not just repeat the status line.

9. Does the comparison report exist and match both runs?
   - reports\comparison-report.md must exist and show differing Task
     Result values (FAILED vs SUCCESS) for the two runs.

10. Can the learner explain the mechanical reason?
    - reports\comparison-report.md or reports\failure-report.md must
      state, in the learner's own words or close to it, the mechanical
      chain: .env is gitignored -> does not reach GitHub -> fresh
      clone lacks it -> secret unavailable -> task fails.

## Verdict

The verdict must be exactly one of:

PASS

or

FAIL

If FAIL, list the specific missing or incorrect items from the
checklist above. Do not use soft verdicts like "mostly good" or "looks
okay".