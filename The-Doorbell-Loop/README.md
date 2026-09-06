# Project 6: The Doorbell Loop 🔔

Source: *Loop Engineering: A Crash Course* — Practice Projects, Project #6.

## 1. Project Name
The Doorbell Loop

## 2. Project Number
Project 6 of 12 in the Loop Engineering Crash Course.

## 3. Goal
Build a loop that automatically reviews a GitHub Pull Request the moment
it is opened or updated — with no prompt typed by a human. The PR event
itself is the "doorbell" that rings and starts the loop.

## 4. Concept 7 — Event-Driven Loop
Most loops so far in this course started because of a timer (in-session),
a condition (conditional), or a schedule (scheduled). This project uses a
different kind of heartbeat entirely: a real-world **event**. Nothing
happens until something occurs out in the world — here, a pull request
being opened or updated. The loop is silent and dormant until that event
fires it.

## 5. Concept 10 — Connectors
A connector is what lets an agent actually see and act on an external
system — in this case, GitHub. The connector is what turns "a PR was
opened" into something an agent can read (the diff) and respond to
(a review comment). This project scaffolds the *event wiring*; the
*connector to an actual AI agent* is added later, in a clearly marked
spot.

## 6. Why GitHub Pull Request Events Are the Heartbeat
Every time someone opens or updates a pull request, GitHub emits an
event. If a workflow is listening for that event, it fires automatically.
That event **is** the heartbeat for this loop — not a clock, not you.

## 7. Timer Heartbeat vs Event Heartbeat
- **Timer heartbeat** (e.g. Projects 1 and 3): fires on a schedule,
  whether or not anything interesting happened — "check every minute,"
  "run every morning."
- **Event heartbeat** (this project): fires only when something specific
  actually happens — no PR opened, no fire. One PR opened, one fire.
  Ten PRs opened, ten fires.

## 8. What the `opened` Event Does
`opened` fires exactly once: the moment a new pull request is first
created. This is the loop's very first "doorbell ring" for that PR.

## 9. What the `synchronize` Event Does
`synchronize` fires every time **new commits are pushed** to a PR that is
already open. This is what proves the loop isn't a one-time script — if
you push a fix after the first review, the loop rings again, on its own,
without you re-triggering anything by hand.

## 10. Maker/Checker Separation
Even though no AI is wired in yet, the scaffold keeps the roles separate
from the start:
- `skills/pr-review-skill.md` — instructions for the **reviewer/maker of
  the review** (writes the review comment; this is the "implementer" of
  the review itself).
- `reviewers/reviewer.md` — instructions for a **separate checker** that
  grades whether that review actually did its job (found the bug,
  explained it correctly) and