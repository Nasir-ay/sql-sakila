--date range
select min(rental_date) as first_rental, max(rental_date) as last_rental
from rental
;

-- checking the available months in the dataset
select date_format(rental_date, '%Y-%m') as rental_month, count(*) as rentals
from rental
group by rental_month
order by rental_month
;

-- checking how many categories each film has
select film_id, count(*) as n
from film_category
group by film_id
having count(*) > 1
;

-- store mismatch
select count(*) as total_rentals, sum(i.store_id <> c.store_id) as mismatch_count, round((sum(i.store_id <> c.store_id)/count(*))*100, 1) as mismatch_pct
from rental r
join inventory i on r.inventory_id = i.inventory_id
join customer c on r.customer_id = c.customer_id
where r.rental_date < '2005-09-01'
;

-- films that have no copies = 42
select f.film_id, f.title, count(i.inventory_id) as n_copies
from film f left join inventory i on f.film_id = i.film_id
group by f.film_id
having n_copies = 0

-- rentals per copy
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





