## Issue Number
001

## Title
Off-by-one error in pagination

## Label
claude-fix

## Description
The function getPageItems(items, pageNumber, pageSize) returns one
extra item from the previous page because the start index is
calculated incorrectly.

## Acceptance Criteria
- Calling getPageItems(items, 2, 3) on [1..10] must return [4, 5, 6]
- Existing pagination tests must pass
- No other function behavior should change

## Expected Test/Check
test/pagination.test.js

## Expected Branch Name
fix/issue-001-pagination-off-by-one