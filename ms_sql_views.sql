
' SQL Server Views '

/*
--> When you use the SELECT statement to query data from one or more tables, you get a result set.

*/

create database Views_Database;
use Views_Database;

drop database Views_Database;

create schema production;

CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) 
        REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

/*
Next time, if you want to get the same result set, you can save this query into a text file, open it, and execute it again.

SQL Server provides a better way to save this query in the database catalog through a view.

A view is a named query stored in the database catalog that allows you to refer to it later.

So the query above can be stored as a view using the CREATE VIEW statement as follows:
*/

create schema sales; 

create view sales.product_info
as
select product_name, brand_name, list_price
	from production.products p
	inner join production.brands b
	on p.brand_id = b.brand_id;

select * from sales.product_info;

-- When receiving this query, SQL Server executes the following query:

SELECT 
    *
FROM (
    SELECT
        product_name, 
        brand_name, 
        list_price
    FROM
        production.products p
    INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;
);

' By definition, views do not store data except for indexed views. '

/*
Advantages of views

1. Security :
You can restrict users to access directly to a table and allow them to access a subset of data via views.

EX: you can allow users to access customer name, phone, email via a view but restrict them to access the bank account and other sensitive information.

2. Simplicity : 
A relational database may have many tables with complex relationships e.g., one-to-one and one-to-many that make it difficult to navigate.

However, you can simplify the complex queries with joins and conditions using a set of views.

3. Consistency : 
Sometimes, you need to write a complex formula or logic in every query.

To make it consistent, you can hide the complex queries logic and calculations in views.

Once views are defined, you can reference the logic from the views rather than rewriting it in separate queries.
*/

/*
syntax: 
		CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)]
		AS
			select_statement;

If you don’t explicitly specify a list of columns for the view, SQL Server will use the column list derived from the SELECT statement.

In case you want to redefine the view e.g., adding more columns to it or removing some columns from it, 
	you can use the OR ALTER keywords after the CREATE VIEW keywords.
*/

CREATE VIEW sales.daily_sales
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.list_price AS sales
FROM
    sales.orders AS o
INNER JOIN sales.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN production.products AS p
    ON p.product_id = i.product_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY
    y, m, d, product_name;

/*
Redefining the view example
To add the customer name column to the sales.daily_sales view, you use the CREATE VIEW OR ALTER as follows:
*/
select * from production.products
select * from sales.orders
select * from sales.customers
select * from sales.daily_sales

drop view sales.daily_sales

CREATE OR ALTER view sales.daily_sales (
    y,
    m,
    d,
    customer_name,
    product_id,
    product_name,
	sales
)
AS
SELECT
    year(order_date),
    month(order_date),
    day(order_date),
    concat(
        first_name,
        ' ',
        last_name
    ),
    p.product_id,
    product_name,
    quantity * i.list_price
FROM
    sales.orders AS o
    INNER JOIN
        sales.order_items AS i
    ON o.order_id = i.order_id
    INNER JOIN
        production.products AS p
    ON p.product_id = i.product_id
    INNER JOIN sales.customers AS c
    ON c.customer_id = o.customer_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY 
    y, 
    m, 
    d, 
    customer_name;

/*
Creating a view using aggregate functions example
The following statement creates a view named staff_salesthose summaries the sales by staffs and years using the SUM() 
	aggregate function:
*/

CREATE VIEW sales.staff_sales (
        first_name, 
        last_name,
        year, 
        amount
)
AS 
    SELECT 
        first_name,
        last_name,
        YEAR(order_date),
        SUM(list_price * quantity) amount
    FROM
        sales.order_items i
    INNER JOIN sales.orders o
        ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
        ON s.staff_id = o.staff_id
    GROUP BY 
        first_name, 
        last_name, 
        YEAR(order_date);

SELECT  
    * 
FROM 
    sales.staff_sales
ORDER BY 
	first_name,
	last_name,
	year;


' ---------- SQL Server Rename View ------------ '

' 1. SQL Server rename view using Server Server Management Studio (SSMS)'

' 2. using syntax: '

create view sales.product_catalog
as
	select * from production.brands;

EXEC sp_rename 
    @objname = 'sales.product_catalog',
    @newname = 'product_list';


' ------ SQL Server List Views ----- '

SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name
FROM 
	sys.views as v;

SELECT 
	OBJECT_SCHEMA_NAME(o.object_id) schema_name,
	o.name
FROM
	sys.objects as o
WHERE
	o.type = 'V';

' Creating a stored procedure to show views in SQL Server Database '

CREATE PROC usp_list_views(
	@schema_name AS VARCHAR(MAX)  = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name view_name
FROM 
	sys.views as v
WHERE 
	(@schema_name IS NULL OR 
	OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
	(@view_name IS NULL OR
	v.name LIKE '%' + @view_name + '%');

-- testing
EXEC usp_list_views @view_name = 'sales'


' ------- How to Get Information About a View in SQL Server --------- '

' 1. Getting the view information using the sql.sql_module catalog '

' 2. Getting view information using the sp_helptext stored procedure '

EXEC sp_helptext 'sales.product_list' ;

' 3. Getting the view information using OBJECT_DEFINITION() function '

SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;


' ------------- SQL Server DROP VIEW ---------------------- '

/*
syntax: DROP VIEW [IF EXISTS] schema_name.view_name;

To remove multiple views, you use the following syntax:

DROP VIEW [IF EXISTS] 
    schema_name.view_name1, 
    schema_name.view_name2,
    ...;
*/

DROP VIEW IF EXISTS sales.daily_sales;

drop view if exists
	sales.staff_sales,
	sales.product_list;


' Creating an indexed view – show you how to create an indexed view against tables that have infrequent 
	modification to optimize the performance of the view. '
/*
Regular SQL Server views are the saved queries that provide some benefits such as query simplicity, business logic consistency, 
	and security. However, they do not improve the underlying query performance.

Unlike regular views, indexed views are materialized views that stores data physically like a table hence may provide some the 
	performance benefit if they are used appropriately.

To create an indexed view, you use the following steps:

First, create a view that uses the WITH SCHEMABINDING option which binds the view to the schema of the underlying tables.
Second, create a unique clustered index on the view. This materializes the view.

When the data of the underlying tables changes, the data in the indexed view is also automatically updated. 
	This causes a write overhead for the referenced tables. It means that when you write to the underlying table, 
	SQL Server also has to write to the index of the view. Therefore, you should only create an indexed view against 
	the tables that have in-frequent data updates.
*/

CREATE VIEW production.product_master
WITH SCHEMABINDING
AS 
SELECT
    product_id,
    product_name,
    model_year,
    list_price,
    brand_name,
    category_name
FROM
    production.products p
INNER JOIN production.brands b 
    ON b.brand_id = p.brand_id
INNER JOIN production.categories c 
    ON c.category_id = p.category_id;

drop view product_master

/*
Before creating a unique clustered index for the view, let’s examine the query I/O cost statistics by querying data 
	from a regular view and using the SET STATISTICS IO command:
*/

SET STATISTICS IO ON
GO

SELECT 
    * 
FROM
    production.product_master
ORDER BY
    product_name;
GO 

-- As you can see clearly from the output, SQL Server had to read from three corresponding tables before returning the result set.

-- Let’s add a unique clustered index to the view:

CREATE UNIQUE CLUSTERED INDEX 
    ucidx_product_id 
ON production.product_master(product_id);

-- This statement materializes the view, making it have a physical existence in the database.

-- You can also add a non-clustered index on the product_name column of the view:

CREATE NONCLUSTERED INDEX 
    ucidx_product_name
ON production.product_master(product_name);

/*
Note that this feature is only available on SQL Server Enterprise Edition. If you use the SQL Server Standard or Developer Edition, 
	you must use the WITH (NOEXPAND) table hint directly in the FROM clause of the query which you want to use the view like the 
	following query:
*/
SELECT * 
FROM production.product_master 
   WITH (NOEXPAND)
ORDER BY product_name;

/* Note: 
Instead of reading data from three tables, SQL Server now reads data directly from the materialized view product_master.
*/


--==============================================================================================


