
' Section 9. Common Table Expression (CTE) '

create database CTE_Database

use CTE_Database;

/*
CTE – use common table expresssions to make complex queries more readable.
Recursive CTE – query hierarchical data using recursive CTE.
*/

' -------------- CTE ---------------------- '
/*
CTE stands for common table expression. A CTE allows you to define a temporary named result set that available temporarily 
	in the execution scope of a statement such as SELECT, INSERT, UPDATE, DELETE, or MERGE.

The following shows the common syntax of a CTE in SQL Server:

	WITH expression_name[(column_name [,...])]
	AS
		(CTE_definition)
	SQL_statement;

	---- or ----

	WITH my_cte AS (
		SELECT a,b,c
		FROM T1
	)
	SELECT a,c
	FROM my_cte
	WHERE ....

In this syntax:

First, specify the expression name (expression_name) to which you can refer later in a query.
Next, specify a list of comma-separated columns after the expression_name. The number of columns must be 
	the same as the number of columns defined in the CTE_definition.
Then, use the AS keyword after the expression name or column list if the column list is specified.
After, define a SELECT statement whose result set populates the common table expression.
Finally, refer to the common table expression in a query (SQL_statement) such as SELECT, INSERT, UPDATE, DELETE, or MERGE.
We prefer to use common table expressions rather than to use subqueries because common table expressions are more readable. 

*/

' A) Simple SQL Server CTE example '

WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

---- or -----
select first_name + ' ' + last_name staff, SUM(quantity * list_price * (1-discount)) sales, YEAR(order_date) year
from sales.orders o
inner join sales.order_items i on i.order_id = o.order_id
inner join sales.staffs s on s.staff_id = o.staff_id
where year(order_date) = 2018
group by first_name + ' ' + last_name, YEAR(order_date)

' B) Using a common table expression to make report averages based on counts '
-- This example uses the CTE to return the average number of sales orders in 2018 for all sales staffs.

with cte_sales 
as (
	select staff_id, COUNT(*) order_count
	from sales.orders 
	where YEAR(order_date) = 2018
	group by staff_id
	)

select AVG(order_count) average_orders_by_staff
from cte_sales
--- or ---
select AVG(order_count) average_orders_by_staff
from (select staff_id, COUNT(*) as order_count
	  from sales.orders
	  where YEAR(order_date) = 2018
	  group by staff_id) as cte_sales

' C) Using multiple SQL Server CTE in a single query example '
/* The following example uses two CTE cte_category_counts and cte_category_sales to return the number of the products and 
	sales for each product category. The outer query joins two CTEs using the category_id column.
*/

select * from production.products where product_id < 2
select * from production.categories where category_id < 2
select * from production.stocks where store_id < 2
select * from production.brands where brand_id < 2

select * from sales.customers where customer_id < 2
select * from sales.stores where store_id < 2

select p.category_id, COUNT(*)
from production.products p
inner join production.categories c on c.category_id =p.category_id
group by p.category_id

with cte_products as (
	select p.category_id c_id, COUNT(*) count_p
	from production.products p
	inner join production.categories c on c.category_id =p.category_id
	group by p.category_id
	) 
	select * from cte_products ct
	inner join production.categories c on c.category_id = ct.c_id

select p.category_id, category_name, COUNT(*) products_count
	from production.products p
	inner join production.categories c on c.category_id =p.category_id
	group by p.category_id, category_name
--- or ----
select c.category_id, c.category_name, products_count
from production.categories c
inner join (select p.category_id cid, COUNT(*) products_count
	from production.products p
	inner join production.categories c on c.category_id =p.category_id
	group by p.category_id) as sub_query 
	on sub_query.cid = c.category_id

select category_id, SUM(quantity*list_price)
from production.products p 
inner join production.stocks s on p.product_id = s.product_id
group by category_id

-----------------------------------

with cte_category_counts 
as (
	select p.category_id, category_name, COUNT(*) products_count
	from production.products p
	inner join production.categories c on c.category_id = p.category_id
	group by p.category_id, category_name
	),
cte_category_sales 
as (
	select category_id, SUM(quantity*i.list_price*(1-discount)) sales
	from sales.order_items i
	inner join sales.orders o on o.order_id = i.order_id
	inner join production.products p on p.product_id = i.product_id
	where order_status = 4
	group by category_id
	)

select c.category_id, category_name, products_count, sales
from cte_category_counts c
inner join cte_category_sales s on c.category_id = s.category_id

-----------------------------

--- this will give products_count different	but sales is right
select p.category_id, category_name, COUNT(distinct p.product_id) products_count, SUM(quantity*s.list_price*(1-discount)) sales
	from production.products p
	inner join production.categories c on c.category_id =p.category_id
	inner join sales.order_items s on s.product_id = p.product_id
	inner join sales.orders o on o.order_id = s.order_id
	where order_status = 4
	group by p.category_id, category_name
	order by category_id



' --------------- SQL Server Recursive CTE ------------------- '
/*
A recursive common table expression (CTE) is a CTE that references itself. By doing so, the CTE repeatedly executes, 
	returns subsets of data, until it returns the complete result set.

A recursive CTE is useful in querying hierarchical data such as organization charts where one employee reports to a 
	manager or multi-level bill of materials when a product consists of many components, and each component itself also 
	consists of many other components.

The following shows the syntax of a recursive CTE:

		WITH expression_name (column_list)
		AS
		(
			-- Anchor member
			initial_query  
			UNION ALL
			-- Recursive member that references expression_name.
			recursive_query  
		)
		-- references expression name
		SELECT *
		FROM   expression_name

In general, a recursive CTE has three parts:
	An initial query that returns the base result set of the CTE. The initial query is called an anchor member.
	A recursive query that references the common table expression, therefore, it is called the recursive member. 
		The recursive member is union-ed with the anchor member using the UNION ALL operator.
	A termination condition specified in the recursive member that terminates the execution of the recursive member.

The execution order of a recursive CTE is as follows:
	First, execute the anchor member to form the base result set (R0), use this result for the next iteration.
	Second, execute the recursive member with the input result set from the previous iteration (Ri-1) and 
		return a sub-result set (Ri) until the termination condition is met.
	Third, combine all result sets R0, R1, … Rn using UNION ALL operator to produce the final result set.

*/

' A) Simple SQL Server recursive CTE example '
-- This example uses a recursive CTE to returns weekdays from Monday to Saturday:

with cte_weekdays (n, weekday) 
as (
	select 
		0, 
		DATENAME(DW, 0)
	UNION ALL
	select 
		n + 1,
		DATENAME(DW, n)
	from cte_weekdays
	where n < 5
	)
select weekday
from cte_weekdays


' B) Using a SQL Server recursive CTE to query hierarchical data '

select distinct s1.staff_id, s1.first_name, s1.manager_id
from sales.staffs s1
join sales.staffs s2 on (s1.manager_id is null or s1.manager_id = s2.staff_id)  -- **************
order by manager_id
' ---- or using cte-recursion --- '
with cte_org
as (
	select staff_id, first_name,  manager_id
		from sales.staffs
		where manager_id is null
	UNION ALL
	select s.staff_id, s.first_name, s.manager_id
	from sales.staffs s
	inner join cte_org o on o.staff_id = s.manager_id
	)
select * from cte_org
order by manager_id

------
select * 
into employees
from DQL_Database.dbo.EMPLOYEES

select * from employees
drop table employees

------------------------

create table sales (
	branch varchar(50) not null,
	date date not null,
	seller varchar(50) not null,
	item nvarchar(50) not null,
	quantity int not null,
	unit_price int not null
	);

select * from sales;
truncate table sales;

insert into sales(branch, date, seller, item, quantity, unit_price)
values ('Paris-1','2021-12-07','Charles', 'Headphones A2', 1, 80)
		,('London-1','2021-12-06','John', 'Cell Phone X2', 2, 120)
		,('London-2','2021-12-07','Mary', 'Headphones A1', 1, 60)
		,('Paris-1','2021-12-07','Charles', 'Battery Charger', 1, 50)
		,('London-2','2021-12-07','Mary', 'Cell Phone B2', 2, 90)
		,('London-1','2021-12-06','John', '	Headphones A0', 5, 75)
		,('London-1','2021-12-07','Sean', 'Cell Phone X1', 2, 100)

select * from sales;

update sales set date = '2021-12-07' where quantity = 5

select branch, date, MAX(unit_price) highest_price_Perday
from sales
group by branch, date


with cte_highest 
as (
	select branch, date, MAX(unit_price) highest_price
		from sales
		group by branch, date
	)
select sales.*, h.highest_price
from sales
join cte_highest h on h.branch = sales.branch
	and h.date = sales.date
--select s.*, h.highest_price
--from sales s
--join cte_highest h on h.branch = s.branch
--	and h.date = s.date


----- Total Revenue -----
select branch, SUM(quantity*unit_price) total_revenue
from sales
group by branch

----- Daily Revenue -----
select branch as b,date, SUM(quantity*unit_price) daily_revenue
from sales
group by branch,date

----- Max Daily Revenue -----
with DailyRevenueTable 
as (
	select branch,date, SUM(quantity*unit_price) daily_revenue
	from sales
	group by branch,date
	)
select branch, MAX(daily_revenue) max_daily_revenue
from DailyRevenueTable
group by branch 

' Using CTEs in Advanced SQL Queries '
/*
Suppose we want a report with the total monthly revenue in London in 2021, but we also want the revenue for each branch 
	in London in the same report. Here, we create two CTEs then join them in the main query.
month	london_revenue	london1_revenue	london2_revenue
12		1055			815				240
*/

select '12' as Month

select '12' as Month, SUM(quantity*unit_price) total_london_revenue
from sales
where branch like '%london%'

with londonrevenue_table
as (
	select branch, SUM(quantity*unit_price) london_revenue
	from sales
	where branch like '%london%'
	group by branch
	)
select SUM(london_revenue) total_london_revenue
from londonrevenue_table

select 1 from sales

SELECT month(date) as month, SUM(unit_price * quantity) AS revenue
  FROM sales
  WHERE YEAR(date) = 2021 AND branch = 'London-1'
  GROUP BY month(date)
			
WITH london1_monthly_revenue AS (
  SELECT
    MONTH(date) as month,
    SUM(unit_price * quantity) AS revenue
  FROM sales
  WHERE YEAR(date) = 2021
    AND branch = 'London-1'
  GROUP BY MONTH(date)
),
london2_monthly_revenue AS (
  SELECT
    MONTH(date) as month,
    SUM(unit_price * quantity) AS revenue
  FROM sales
  WHERE YEAR(date) = 2021
    AND branch = 'London-2'
  GROUP BY MONTH(date)
)
SELECT
  l1.month,
  l1.revenue + l2.revenue AS london_revenue,
  l1.revenue AS london1_revenue,
  l2.revenue AS london2_revenue
FROM london1_monthly_revenue l1, london2_monthly_revenue l2
WHERE l1.month = l2.month


WITH tickets AS (
  SELECT distinct
    branch,
    date,
    unit_price * quantity AS ticket_amount,
    ROW_NUMBER() OVER (
      PARTITION BY branch
      ORDER by unit_price * quantity DESC
    ) AS position
  FROM sales
  ORDER BY 3 DESC
  offset 0 rows
)
SELECT
  branch,
  date,
  ticket_amount
FROM tickets
WHERE position =1




