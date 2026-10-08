# sql-sakila

## Business Question (draft)
Which film category has the highest revenue relative to rental count in each store, so that the rental chain's manager can decide whether to increase or reduce inventory of the specific category?

### Note:
The structure is good: it has a measure, a comparison, and a decision. The measure is the problem.

Revenue relative to rental count is just revenue per rental. In Sakila, that is mostly the average rental price of the films in a category, because rental rates are fixed per film. So the ratio tells you which categories are priced highest, not which are in demand or short of stock. A manager can't decide "buy more or fewer copies" from it.

A hint to think about, not answer yet: if a category earns a high revenue per rental, would that be a reason to stock more of it? Why or why not? And what two quantities would you compare to see whether a category's copies are being used heavily or sitting idle? (Look back at the supply side I mentioned, the inventory table.)

## Approach
**Scope:** I used rentals from 24th May to 31st August 2005 because there are several missing months. 
**Data check:** The date range showed 24th May 2005 to 14th February 2006. However, the first and last months are partial, while the months September 2005 to January 2006 do not exist in the dataset. I excluded February 2006 because of the missing data from prior months, which could potentially skew the data.
**Store attribution:** I used inventory.store_id because it covers both the supply and demand sides of the business question. I tested this by whether inventory.store_id and customer.store_id match, and found 50% of rentals mismatch.
**Measure:** (leave blank, we finalise it tomorrow)

## Key Findings

## Recommendations
