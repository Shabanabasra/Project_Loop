# Evidence Folder

This folder holds proof artifacts for the Project 12 Dreaming Loop
rehearsal.

- planted-failure-evidence.md - proves the repeated failure was
  actually planted in and read from progress.md, not invented
- evidence-citations.md - the exact citation chain the proposal relies
  on (dates, text, counts)
- rules-checksum.txt - created automatically by scripts\plant-test-failure.ps1;
  a SHA256 baseline hash of improvement-rules.md, used by
  scripts\validate-evidence.ps1 and scripts\compare-gate.ps1 to prove
  the file was never modified directly. This file does not exist until
  you run plant-test-failure.ps1.

All evidence in this folder describes a LOCAL SIMULATION. No real
GitHub branch or pull request was created to produce it.