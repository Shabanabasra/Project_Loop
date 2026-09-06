# Issue 3: Incorrect discount calculation

## Description
The function `applyDiscount(price, discountPercent)` is supposed to reduce
`price` by `discountPercent` percent. Currently it subtracts the raw
`discountPercent` number instead of the percentage amount, giving a wrong
final price.

## Example of the bug
- `applyDiscount(100, 10)` should return 90 (10% off of 100)
- Currently it returns 90 by accident only when price = 100; for other
  values it is wrong, e.g. `applyDiscount(200, 10)` should return 180,
  but currently returns 190 (it subtracts 10 directly instead of 10% of 200)

## Location (example)
File: `src/discount.js`
Function: `applyDiscount`

## Acceptance criteria
- `applyDiscount(200, 10)` returns 180
- `applyDiscount(50, 20)` returns 40
- Existing tests in `test/discount.test.js` must pass