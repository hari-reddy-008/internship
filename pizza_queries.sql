-- Retrieve the total number of orders placed.
select COUNT(*) as total_orders from orders;
-- Calculate the total revenue generated from pizza sales.
SELECT CONCAT("₹", " ",ROUND(SUM(od.quantity * p.price), 2)) as total_sales FROM pizza_sales.order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
;

-- Identify the highest-priced pizza.
select name,  price from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
order by price desc
limit 1
;
-- Identify the most common pizza size ordered.
SELECT size, COUNT(od.order_details_id) as no_of_orders FROM pizzas as p
join order_details as od
on od.pizza_id = p.pizza_id
group by size
order by no_of_orders desc
limit 1
;

-- List the top 5 most ordered pizza types along with their quantities.
select name, SUM(od.quantity) as qantity from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by name
order by qantity desc
limit 5
;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT category, SUM(od.quantity)as total_qantity FROM pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by category
order by total_qantity desc
;
-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) as hour, COUNT(*)as total_orders FROM pizza_sales.orders
group by hour
;
-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, COUNT(name)as pizzaname FROM pizza_types as p
group by category;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT name, SUM(od.quantity * p.price) as total_revenu FROM pizza_sales.pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by name
order by total_revenu desc
limit 3
;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT name, CONCAT(ROUND(SUM(od.quantity * p.price / (select ROUND(SUM(od.quantity * p.price), 2) as total_sales FROM pizza_sales.pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id)) * 100, 2), "%") as total_salesl 
FROM pizza_sales.pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by name
order by total_salesl desc
;

-- Analyze the cumulative revenue generated over time.
select order_date, SUM(revenu) over(order by order_date) as cum_revenu 
from
(SELECT order_date, ROUND(SUM(od.quantity * p.price), 2) as revenu FROM pizza_sales.order_details as od
join orders as o
on od.order_id = o.order_id
join pizzas as p
on od.pizza_id = p.pizza_id
group by order_date)as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, category, total_revenu, RANK() OVER(partition by category order by total_revenu desc) as rank_by_category from
(SELECT name, category, SUM(od.quantity * p.price) as total_revenu FROM pizza_sales.pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by name, category
order by total_revenu desc
) as orders;