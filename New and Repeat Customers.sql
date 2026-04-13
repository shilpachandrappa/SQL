use Ankit_Bansal_SQL;

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000)
;
select * from customer_orders;
/*
How many new customers and how many repeat customers
order_date , new_customer_count, repeat_customer_count 
on day 1 - (3)all 3 are new customer and no repeat cusotomer as it's the first day(0)
on day 2 - (2)400 , 500 new customer and 100 is repeat customer (1)
on day 3 - (1)600 is the new custoer and 100, 400 is the repeat customer(2)
*/
WITH first_visit as(
SELECT  customer_id,  min(order_date) as First_date 
from customer_orders GROUP BY customer_id
)
SELECT C.order_date,
sum(CASE WHEN FV.First_date = C.order_date THEN 1 ELSE 0 END ) AS first_visit_customer,
sum(CASE WHEN FV.First_date != C.order_date THEN 1 ELSE 0 END) AS repeated_Customer
from customer_orders C
JOIN first_visit FV ON FV.customer_id = C.customer_id
GROUP BY C.order_date;

