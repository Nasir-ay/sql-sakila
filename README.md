# sql-sakila

## Business Question (draft)
Which film category has the highest revenue relative to rental count in each store, so that the rental chain's manager can decide whether to increase or reduce inventory of the specific category?

### Note:
The structure is good: it has a measure, a comparison, and a decision. The measure is the problem.

Revenue relative to rental count is just revenue per rental. In Sakila, that is mostly the average rental price of the films in a category, because rental rates are fixed per film. So the ratio tells you which categories are priced highest, not which are in demand or short of stock. A manager can't decide "buy more or fewer copies" from it.

A hint to think about, not answer yet: if a category earns a high revenue per rental, would that be a reason to stock more of it? Why or why not? And what two quantities would you compare to see whether a category's copies are being used heavily or sitting idle? (Look back at the supply side I mentioned, the inventory table.)

## Approach

## Key Findings

## Recommendations
