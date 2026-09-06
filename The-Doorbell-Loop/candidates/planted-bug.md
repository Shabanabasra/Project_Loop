# Planted Bug: Off-by-One Pagination Error

## Bug Description
The function `getPageItems(items, pageNumber, pageSize)` is supposed to
return the correct slice of items for a given page number (1-indexed).
The planted bug makes it return one item too early, pulling in the last
item from the *previous* page instead of starting cleanly at the current
page's first item.

## Example Input