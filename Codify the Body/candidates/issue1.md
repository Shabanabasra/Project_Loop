# Issue 1: Off-by-one error in pagination

## Description
The function `getPageItems(items, pageNumber, pageSize)` is supposed to return
the correct slice of items for a given page number (1-indexed). Currently it
returns one extra item from the previous page because the start index is
calculated incorrectly.

## Example of the bug
Given items = [1,2,3,4,5,6,7,8,9,10], pageSize = 3, pageNumber = 2:
- Expected result: [4, 5, 6]
- Actual (buggy) result: [3, 4, 5]

## Location (example)
File: `src/pagination.js`
Function: `getPageItems`

## Acceptance criteria
- Calling `getPageItems(items, 2, 3)` on the example array must return [4, 5, 6]
- Existing tests in `test/pagination.test.js` must pass
- No other function behavior should change