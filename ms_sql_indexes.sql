
' SQL Server Indexes '

/*
-> Indexes are special data structures associated with tables or views that help speed up the query. 
-> SQL Server provides two types of indexes: clustered index and non-clustered index.

*/

' ======================= SQL Server Clustered Indexes ======================== '

create database Indexes_Database;
use Indexes_Database;
Go

create schema production;

CREATE TABLE production.parts(
    part_id   INT NOT NULL, 
    part_name VARCHAR(100)
);

INSERT INTO  production.parts(part_id, part_name)
VALUES (1,'Frame'), 
		(2,'Head Tube'), 
		(3,'Handlebar Grip'), 
		(4,'Shock Absorber'), 
		(5,'Fork');

select * from production.parts;

drop table production.parts;

/*
--> The production.parts table does not have a primary key. Therefore SQL Server stores its rows 
	in an unordered structure called a heap.
-->  When you query data from the production.parts table, the query optimizer needs to scan the whole table to search.
*/

select * from production.parts where part_id = 5;

/*
--> A clustered index stores data rows in a sorted structure based on its key values. Each table has only one clustered index 
	because data rows can be only sorted in one order. A table that has a clustered index is called a clustered table.

--> A clustered index organizes data using a special structured so-called B-tree (or balanced tree) which enables searches, inserts, 
	updates, and deletes in logarithmic amortized time.

--> In this structure, the top node of the B-tree is called the root node. The nodes at the bottom level are called the leaf nodes. 
	Any index levels between the root and the leaf nodes are known as intermediate levels.

--> In the B-Tree, the root node and intermediate-level nodes contain index pages that hold index rows. 
	The leaf nodes contain the data pages of the underlying table. The pages in each level of the index are linked using 
	another structure called a doubly-linked list.

--> When you create a table with a primary key, SQL Server automatically creates a corresponding clustered index that 
	includes primary key columns.
*/

CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
);

/*
If you add a primary key constraint to an existing table that already has a clustered index, 
	SQL Server will enforce the primary key using a non-clustered index:
*/

alter table production.parts
add constraint pk_part_id primary key(part_id);
--- or ---
ALTER TABLE production.parts
ADD PRIMARY KEY(part_id);

alter table production.parts
drop constraint pk_part_id;

/* syntax:
		CREATE CLUSTERED INDEX index_name
		ON schema_name.table_name (column_list);  
*/

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);  


' ======================= SQL Server Non-Clustered Indexes ======================== '

/*
--> A nonclustered index is a data structure that improves the speed of data retrieval from tables. 
	Unlike a clustered index, a nonclustered index sorts and stores data separately from the data rows in the table. 
	It is a copy of selected columns of data from a table with the links to the associated table.

--> Like a clustered index, a nonclustered index uses the B-tree structure to organize its data.

--> A table may have one or more nonclustered indexes and each non-clustered index may include one or more columns in a table.

--> Besides storing the index key values, the leaf nodes also store row pointers to the data rows that contain the key values. 
	These row pointers are also known as row locators.

--> If the underlying table is a clustered table, the row pointer is the clustered index key. 
	In case the underlying table is a heap, the row pointer points to the row of the table.

syntax: 
		CREATE [NONCLUSTERED] INDEX index_name
		ON table_name(column_list);
*/

create schema sales;

CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);

SELECT customer_id, city
FROM sales.customers
WHERE city = 'Atwater';

CREATE INDEX ix_customers_city
ON sales.customers(city);

SELECT customer_id, city
FROM sales.customers
WHERE city = 'Atwater';

select customer_id, first_name, last_name
from sales.customers
where last_name = 'Berg' AND first_name = 'Monika';

create index ix_customers_name
on sales.customers(first_name, last_name);

select customer_id, first_name, last_name
from sales.customers
where last_name = 'Berg' AND first_name = 'Monika';

'  ------- SQL Server Rename Index --------- '

' Renaming an index using the system stored procedure sp_rename : '
/*The sp_rename is a system stored procedure that allows you to rename any user-created object in the current database 
	including table, index, and column.
*/
/*
The statement renames an index:

	EXEC sp_rename 
		index_name, 
		new_index_name, 
		N'INDEX';  

	or you can use the explicit parameters:

	EXEC sp_rename 
		@objname = N'index_name', 
		@newname = N'new_index_name',   
		@objtype = N'INDEX';

	--- or ----

	Renaming an index using the SQL Server Management Studio (SSMS)

*/

EXEC sp_rename 
        N'sales.customers.ix_customers_city',
        N'ix_cust_city' ,
        N'INDEX';

exec sp_rename 
		'sales.customers.ix_cust_city',
		'ix_customers_city',
		'INDEX'

'  ------- SQL Server Disable Indexes --------- '

/* 
syntax:
		ALTER INDEX index_name
		ON table_name
		DISABLE;

To disable all indexes of a table, you use the following form of the ALTER INDEX statement:

		ALTER INDEX ALL ON table_name
		DISABLE;

--> When you disable an index on a table, SQL Server keeps the index definition in the metadata and the index statistics 
		in nonclustered indexes. However, if you disable a nonclustered or clustered index on a view, SQL Server will 
		physically delete all the index data.
*/

alter index ix_customers_city
on sales.customers
disable;

select * from sales.customers where city = 'San Jose';

' Note: If you disable a clustered index of a table, you cannot access the table data using data manipulation language 
	such as SELECT, INSERT, UPDATE, and DELETE until you rebuild or drop the index. '

' Disabling all indexes of a table example '

alter index all on sales.customers
disable;

-- Here, you cannot access data in the table anymore.

SELECT * FROM sales.customers;
' o/p: The query processor is unable to produce a plan because the index 'PK__customer__CD65CB85F6202859' 
	on table or view 'customers' is disabled.'

'  ------- SQL Server Enable Indexes --------- '
/*
Sometimes, you need to disable an index before doing a large update on a table. By disabling the index, you can speed up 
	the update process by avoiding the index writing overhead.

	In SQL Server, you can rebuild an index by using the ALTER INDEX statement or DBCC DBREINDEX command.

syntax:
	ALTER INDEX index_name 
	ON table_name  
	REBUILD;

This statement uses the CREATE INDEX statement to enable the disabled index and recreate it:

	CREATE INDEX index_name 
	ON table_name(column_list)
	WITH(DROP_EXISTING=ON)

The following statement uses the ALTER INDEX statement to enable all disabled indexes on a table:

	ALTER INDEX ALL ON table_name
	REBUILD;

*/

alter index all on sales.customers
rebuild;

' Unique indexes – enforce the uniqueness of values in one or more columns. '


'  ------- SQL Serve DROP Indexes --------- '
/*
The DROP INDEX statement removes one or more indexes from the current database. Here is the syntax of the DROP INDEX statement:

	DROP INDEX [IF EXISTS] index_name
	ON table_name;

The DROP INDEX statement does not remove indexes created by PRIMARY KEY or UNIQUE constraints. 
	To drop indexes associated with these constraints, you use the ALTER TABLE DROP CONSTRAINT statement.

To remove multiple indexes from one or more tables at the same time, you specify a comma-separated list of index names 
	with the corresponding table names after the DROP INDEX clause as shown in the following query:

	DROP INDEX [IF EXISTS] 
		index_name1 ON table_name1,
		index_name2 ON table_name2,
		...;
*/
-- revove unique indexing
DROP INDEX IF EXISTS ix_cust_email
ON sales.customers;

DROP INDEX if exists
    ix_customers_city ON sales.customers,
    ix_cust_fullname ON sales.customers;

	
' Indexes with included columns – guide you on how to add non-key columns to a nonclustered index to improve the speed of queries. '

' Filtered indexes – learn how to create an index on a portion of rows in a table. '

' Indexes on computed columns – walk you through how to simulate function-based indexes using the indexes on computed columns. '





