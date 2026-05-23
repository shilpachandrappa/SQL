CREATE SCHEMA IF NOT EXISTS `leetcode_medium`;
USE `leetcode_medium`;

/*
LeetCode 1445: Apples & Oranges

(sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
The fruit column contains values restricted to 'apples' and 'oranges'.
This table records the daily sales quantities for both fruits.  

GoalWrite an SQL query to report the difference between the number of apples and oranges sold each day.  
$$\{Difference} = {Apples Sold} - {Oranges Sold}$$
Return the result table ordered by sale_date.

*/

CREATE TABLE IF NOT EXISTS `Sales`(
	`sales_date` DATE NOT NULL ,
    `fruit` ENUM('apples','oranges') NOT NULL,
    `sold_num` INT NOT NULL ,
    PRIMARY KEY (`sales_date`,`fruit`)
) ;

INSERT INTO Sales (`sales_date`, `fruit`, `sold_num`) VALUES
('2020-05-01', 'apples', 10),
('2020-05-01', 'oranges', 8),
('2020-05-02', 'apples', 15),
('2020-05-02', 'oranges', 15),
('2020-05-03', 'apples', 20),
('2020-05-03', 'oranges', 0),
('2020-05-04', 'apples', 15),
('2020-05-04', 'oranges', 16);

SELECT sales_date ,
	ABS(SUM(CASE
		WHEN fruit = 'apples' THEN sold_num
        ELSE -sold_num
        END)) AS DIFF
FROM Sales
GROUP BY sales_date
ORDER BY sales_date;


with cte as (SELECT sales_date,  sold_num, LEAD(sold_num, 1) OVER(PARTITION BY sales_date) as orange_num FROM Sales)
select sales_date, abs(sold_num-orange_num) as diff  from cte where orange_num is not null ;



/*
If I am using group by then I must use max , min ,sum , count or I will get error that's the rule
this can also be done using join and subquery also 
*/