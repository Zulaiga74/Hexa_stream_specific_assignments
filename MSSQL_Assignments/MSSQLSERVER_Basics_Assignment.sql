-- List all stores whose total revenue is greater than ₹100,000

select*from sales.stores
select*from sales.orders

select s.store_name,
sum(oi.quantity*oi.list_price) as total_revenue
from sales.stores s
join sales.orders o on
s.store_id = o.store_id
join sales.order_items oi on
o.order_id = oi.order_id
group by store_name
having sum(oi.quantity*oi.list_price) > 100000
order by total_revenue desc


--Total Sales by Store (Only High-Performing Stores)
-- List each store's name and the total sales amount (sum of quantity × list price) for all orders. Only include stores where the total sales amount exceeds $50,000.

select s.store_name,
sum(oi.quantity*oi.list_price) as total_sales_amount
from sales.stores s
join sales.orders o on
s.store_id = o.store_id
join sales.order_items oi on
o.order_id = oi.order_id
group by store_name
having sum(oi.quantity*oi.list_price) > 1800000
order by total_sales_amount desc

-- Find the top 5 best-selling products by total quantity ordered

select top 5
p.product_id,p.product_name,
sum(oi.quantity) as total_quantity_ordered
from production.products p
join sales.order_items oi on
p.product_id = oi.product_id
join sales.orders o on
o.order_id = oi.order_id 
group by p.product_id,p.product_name
order by total_quantity_ordered desc

-- how monthly sales totals (sum of line total) for the year 2016.

select month(o.order_date) as month_no,
sum(oi.quantity*oi.list_price) as total_sales_by_month
from sales.orders o
join sales.order_items oi
on o.order_id = oi.order_id
where order_date >= '2016-01-01' and order_date <= '2016-12-31'
group by month(o.order_date)
order by month_no


