-- Write SQL queries to perform the following tasks using the Sakila database:
-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

select film.title, count(inventory.inventory_id) as current_inventory
from film
left join inventory
using (film_id)
group by film.title
having film.title = 'Hunchback Impossible'
;

#using subquery
select nf.title, count(inventory.inventory_id) as current_inventory
from (select film_id, title 
     from film 
     where title = 'Hunchback Impossible') as nf
left join inventory
using (film_id)
group by nf.title
;

-- List all films whose length is longer than the average length of all the films in the Sakila database.
select film.title, film.length
from category
left join film_category
	using (category_id)
left join film
	using (film_id)
where film.length > (select avg(length) from film);


-- Use a subquery to display all actors who appear in the film "Alone Trip".
select actor.first_name, actor.last_name, film.title
from film
left join film_actor
	using(film_id)
left join actor
	using(actor_id)
having film.title = 'Alone Trip';

#with subquery
select actor.first_name, actor.last_name, at.title
from (select film_id, title 
     from film 
     where title = 'alone trip') as at
left join film_actor
	using(film_id)
left join actor
	using(actor_id);
    

-- Bonus:
-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

select fam.name, film.title
from (select category.name, category_id
		from category 
        where category.name like '%family%') as fam
left join film_category
	using(category_id)
left join film
	using(film_id);

-- Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.

select customer.last_name, customer.email, can.country
from (select country.country, country.country_id
		from country
        where country.country like '%Canada%') as can
inner join city
	using(country_id)
inner join address
	using(city_id)
inner join customer
	using (address_id);


-- Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

select actor.last_name, actor.actor_id, count(film_actor.actor_id) as frequency
from actor
left join film_actor
	using(actor_id)
left join film
	using(film_id)
group by actor.last_name, actor.actor_id
order by frequency desc
limit 1;


select film.title, actor.actor_id
from actor
left join film_actor
	using(actor_id)
left join film
	using(film_id)
where actor_id = (select actor.actor_id
				from actor
				left join film_actor
					using(actor_id)
				left join film
					using(film_id)
				group by actor.actor_id
				order by count(film_actor.actor_id) desc
				limit 1)
;

-- Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select customer.customer_id, sum(payment.amount) as total_payment
from payment
inner join customer
	using(customer_id)
group by customer.customer_id
order by total_payment desc
limit 1;


select film.title, customer.customer_id
from film
inner join inventory
	using(film_id)
inner join rental
	using(inventory_id)
inner join customer
	using(customer_id)
where customer.customer_id = (select customer.customer_id
								from payment
								inner join customer
									using(customer_id)
								group by customer.customer_id
								order by sum(payment.amount) desc
								limit 1)
                                ;

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

# this one was too hard so I asked chatgpt

select customer.customer_id, sum(payment.amount) as total_payment
from payment
inner join customer
	using(customer_id)
group by customer.customer_id
having sum(payment.amount) > (select avg(total_amount_spent) 
								from (select customer_id, SUM(amount) AS total_amount_spent 
									from payment group by customer_id) as avg_total);


