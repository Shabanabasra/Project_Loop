# Failure Report

Run ID: ROUTINE-RUN-20260829-161757
Timestamp: 2026-08-29 16:17:57

## What failed

The simulated Routine attempted to read
candidates\file-that-does-not-exist.txt, which does not exist.

## Why it failed

The prompt named a file path that was never created in this
project, on purpose, to safely rehearse what a real failed Routine
run looks like.

## Which file was missing

candidates\file-that-does-not-exist.txt (full path attempted: C:\Users\FIVE STAR COMPUTER\Documents\Project_Loop\Rehearse-a-Routine-for-Free\candidates\file-that-does-not-exist.txt)

## Why transcript reading matters

The simulated session still completed without an infrastructure
error (PowerShell caught the missing-file error and the script kept
running normally), so Platform Status: GREEN. Only reading the
transcript in transcripts\failed-run.md reveals that the actual task
result was FAILED. A real Routine's status column would look the
same in both cases; this is the whole A5 lesson.

## What a human should do next

Confirm the expected input file, fix the prompt or the missing
file, and rehearse again with a one-off run before scheduling
anything repeating.
