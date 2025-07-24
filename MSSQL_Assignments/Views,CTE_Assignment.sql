

use BikeStores
--Q1

create view vwactiveproducts as
select p.product_id,p.product_name,b.brand_name,c.category_name,p.list_price,p.model_year
from production.products p 
inner join production.brands b
on p.brand_id = b.brand_id
inner join production.categories c
on p.category_id = c.category_id
where p.model_year > 2018

select*from vwactiveproducts
order by category_name,product_name

select*from production.categories
select*from production.products
select*from production.stocks

select*from sales.orders
select*from sales.order_items
select*from sales.customers


-- Q2
with prodCTE as(
select p.product_name,p.list_price,c.category_name,
ROW_NUMBER() over(partition by c.category_name order by p.list_price desc) as Final 
from production.products p
join production.categories c
on p.category_id = c.category_id)
select category_name,product_name,list_price
from prodCTE
where Final = 1
order by category_name


-- Q3
create view vwunsold as
select p.product_id,p.product_name,b.brand_name,p.list_price,p.model_year,c.category_name
from production.products p 
join production.brands b on
p.brand_id = b.brand_id
join production.categories c on
p.category_id = c.category_id
where product_id not in ( select distinct product_id from sales.order_items)

select*from vwunsold

-- Q4
create view vwhighvalue as
select c.customer_id,c.first_name as customer_name,o.order_id,o.order_date,
sum(oi.quantity*oi.list_price) as total_amt
from sales.customers c
join sales.orders o on
c.customer_id = o.customer_id
join sales.order_items oi on
o.order_id = oi.order_id
group by c.customer_id,c.first_name,o.order_id,o.order_date
having sum(oi.quantity*oi.list_price) > 10000

select*from vwhighvalue



-- Create a view called vwhighvaluecustomer that lists customers who have made purchases totaling more than 10,000 
--The view should include:
--customer_id,customer_name,order_id,total_amt,order_date


create view vwhighvaluecustomer as
select c.customer_id,c.first_name as customer_name,o.order_id,o.order_date,
sum(oi.quantity*oi.list_price) as total_amt
from sales.customers c
join sales.orders o on
c.customer_id = o.customer_id
join sales.order_items oi on
o.order_id = oi.order_id
group by c.customer_id,c.first_name,o.order_id,o.order_date
having sum(oi.quantity*oi.list_price) > 10000






