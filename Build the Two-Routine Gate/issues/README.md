# Issues Folder

This folder holds three example issues, each labeled claude-fix, used
to test the two-Routine gate with multiple independent runs. In a real
repository, these would be actual GitHub issues carrying the claude-fix
label. Here they are written out as files so the local simulation
scripts can read them.

- issue-001.md - pagination off-by-one fix
- issue-002.md - null-check crash fix
- issue-003.md - discount calculation fix

Each is small, safe, and independently fixable, so the implementer
Routine (or its simulation) can complete it in a single run without
touching unrelated code.