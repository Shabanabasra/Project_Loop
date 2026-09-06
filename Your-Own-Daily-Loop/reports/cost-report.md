# Cost Report - Project 8 Daily Dependency Audit Loop

This is an EXAMPLE report showing the shape of the output. Run
scripts\estimate-cost.ps1 to replace this with your own real estimate.
ALL VALUES BELOW ARE ESTIMATES, not real current provider pricing.

## Inputs (example)

Input tokens per run: 1800
Output tokens per run: 600
Runs per day: 1
Input price per 1,000,000 tokens (estimate): 3.0
Output price per 1,000,000 tokens (estimate): 15.0
Days per month used for this estimate: 30

## Results (example, estimates only)

Runs per month: 30
Monthly input tokens: 54000
Monthly output tokens: 18000
Monthly total tokens: 72000
Estimated monthly input cost: 0.162
Estimated monthly output cost: 0.27
Estimated monthly TOTAL cost: 0.432

Note: these example numbers are intentionally small and illustrative.
Your real per-run token usage may be much higher depending on how many
dependencies are audited and how detailed the report is. Always re-run
scripts\estimate-cost.ps1 with your own numbers.