# sql-sakila

## Business Question (draft)
Which film category has the highest revenue relative to rental count in each store, so that the rental chain's manager can decide whether to increase or reduce inventory of the specific category?

## Approach
**Scope:** I used rentals from 24th May to 31st August 2005 because it is a continuous period, excluding the missing subsequent months and the last partial month. I also handled duplicates in the query rather than removing them from the table.

**Data check:** The date range showed 24th May 2005 to 14th February 2006. However, the first and last months are partial, while the months September 2005 to January 2006 do not exist in the dataset. I excluded February 2006 because of the missing data from prior months, which could potentially skew the data.

```
select min(rental_date) as first_rental, max(rental_date) as last_rental
from rental
;
```

```
SELECT DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
       COUNT(*) AS rentals
FROM rental
GROUP BY rental_month
ORDER BY rental_month
;
```

**Store attribution:** I used inventory.store_id because the decision is about shelf stock. I tested this by whether inventory.store_id and customer.store_id match, and found 50% of rentals mismatch, indicating that about 50% of rentals occur at a store other than the customer's home store. Therefore, I can't use customer.store_id.
```
select count(*) as total_rentals, sum(i.store_id <> c.store_id) as mismatch_count, round((sum(i.store_id <> c.store_id)/count(*))*100, 1) as mismatch_pct
from rental r
join inventory i on r.inventory_id = i.inventory_id
join customer c on r.customer_id = c.customer_id
where r.rental_date < '2005-09-01'
;
```

**Measure:** rentals per copy per store and category, over 24 May to 31 August 2005,  with store assigned by inventory.store_id. 

## Key Findings

## Recommendations
