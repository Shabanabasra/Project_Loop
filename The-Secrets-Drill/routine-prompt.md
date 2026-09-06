# Routine Prompt - Project 10 Secrets Drill

This file documents the two prompts used in this rehearsal: the broken
first-run prompt (which relies on a `.env` file that a fresh clone will
never receive) and the corrected second-run prompt (which uses the
environment variables panel instead).

## First Run Prompt (deliberately relies on .env, will fail)

```
Read the OPENROUTER_API_KEY value needed for this task and confirm
that it is available. Look in the project's .env file if needed. Do
not print the key.
```

This prompt is deliberately naive about where secrets live. It assumes
a `.env` file might be available, the way it would be on a developer's
own machine. A real cloud Routine's fresh clone never receives this
file, because it is gitignored.

## Second Run Prompt (corrected, uses the environment variables panel)

```
Read OPENROUTER_API_KEY from the environment and confirm that it is
available. Do not print the key. Credentials are available as
environment variables; do not look for a .env file.
```

This is the corrected prompt. It contains the exact instruction
required for this drill: "credentials are available as environment
variables; do not look for a .env file." This removes any ambiguity
about where to look, and stops the model from wasting a turn trying an
`.env` path that can never work in a fresh clone.

## Which Script Uses Which Prompt

- scripts\simulate-env-failure.ps1 acts out the First Run Prompt above.
- scripts\simulate-environment-success.ps1 acts out the Second Run
  Prompt above.

## Security Note

This drill uses OPENROUTER_API_KEY only as a variable NAME. No real key
is ever written into any file in this project. Your real OpenRouter key
should only ever exist in your own local `.env` file (gitignored) or be
set directly as a process environment variable on your own machine -
never pasted into this chat, never committed to a repository, and never
printed by any script in this project. The drill is about where a
secret lives, not the key's actual value.