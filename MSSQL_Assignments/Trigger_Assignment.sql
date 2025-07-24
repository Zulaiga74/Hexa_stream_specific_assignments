select*from production.products

-- Q1
create table price_change_log
(
log_id int identity(1,1) primary key,
product_id int,
old_price decimal(10,4),
new_price decimal(10,4),
change_date date,
foreign key(product_id) references production.products(product_id)
)

drop table price_change_log

select*from production.products
select*from price_change_log

create trigger trg_afterupdates_product
on production.products
for update
as
begin
     declare @id int
     declare @oldlistprice decimal(10,4),@newlistprice decimal(10,4)
     
     select product_id,list_price into #temptable from inserted

     while(Exists(select product_id from #temptable))
     begin
          
          select top 1 @id = product_id,
          @newlistprice = list_price
          from #temptable

          select @oldlistprice = list_price 
          from deleted where product_id = @id

          if(@oldlistprice <> @newlistprice)
             begin
                  insert into price_change_log(product_id,old_price,new_price,change_date)
                  values(@id,@oldlistprice,@newlistprice,cast(getdate() as date))
             end

             delete from #temptable where product_id = @id
            end
    end

update production.products set list_price = 849.99 where product_id = 2  
update production.products set list_price = 3899.99 where product_id = 4

--Q2

select*from sales.orders
select*from production.stocks

create trigger trg_preventdeletion
on production.products
instead of delete
as
begin
     if exists(select 1 from deleted d
     join sales.order_items oi on 
     d.product_id = oi.product_id
     join sales.orders o on 
     oi.order_id = o.order_id
     where o.order_status not in (3,2))
 begin
     print('Cannot delete open order products')
     rollback
 end
end


