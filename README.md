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

**Measure:** rentals per copy per store and category, 24 May to 31 August 2005, store from inventory.store_id, idle copies kept (4581 copies). 42 films have no copies and can't appear in any rental-based result. 

```
with copies as (
select i.store_id as store_id, c.name as category, count(distinct i.inventory_id) as n_inventory
from inventory i 
    join film_category fc on i.film_id = fc.film_id
    join category c on c.category_id = fc.category_id
group by c.name, i.store_id
),
rentals_in_period as (
select i.store_id as store_id, c.name as category, count(rental_id) as n_rentals 
from inventory i 
	join rental r on i.inventory_id = r.inventory_id
    join film_category fc on i.film_id = fc.film_id
    join category c on c.category_id = fc.category_id
where r.rental_date < '2005-09-01'
group by c.name, i.store_id
)
select cp.store_id, cp.category, cp.n_inventory, rp.n_rentals, round(COALESCE(rp.n_rentals, 0)/cp.n_inventory, 2) as rental_per_copy
from copies cp
	left join rentals_in_period rp on cp.store_id = rp.store_id and cp.category = rp.category
order by rental_per_copy desc
;    
```


## Key Findings
1. Store 2 Documentary: 3.65 rentals per copy, the highest of 32 store-category combinations.
2. The lowest is store 2 Horror at 3.32, implying the strongest and weakest combinations differ by only about 10%.
3. In store 2, the highest and lowest categories by rentals per copy are Documentary and Horror, respectively.
4. Drama has the highest rentals per copy in Store 1, while Sports and New are the lowest.


## Recommendations
