## Issue Number
003

## Title
Incorrect discount calculation

## Label
claude-fix

## Description
applyDiscount(price, discountPercent) subtracts the raw percent number
instead of the percentage amount, giving a wrong final price for any
value other than exactly 100.

## Acceptance Criteria
- applyDiscount(200, 10) returns 180
- applyDiscount(50, 20) returns 40
- Existing discount tests must pass

## Expected Test/Check
test/discount.test.js

## Expected Branch Name
fix/issue-003-discount-calculation