
use CURSOR_Database

'------------------------ Cursor Revision  -------------------------------'

---  1st Problem
--cursor that selects the customer_id and customer_name columns from the "customers" table. It then iterates over the result set, 
--performing operations with each fetched row. The cursor is opened, fetched row by row, and closed and deallocated after the loop.

create table Customer(
CustomerId int primary key identity,
CustomerName nvarchar(max) not null,
Customer_UIN nvarchar(max)
)

--drop table Customer
select * from Customer

insert into Customer(CustomerName) values
('Scott'), ('Allen'), ('Smith'), ('King'),('Jack'), ('Miller')


declare @Id int,
		@Name nvarchar(max),
		@UIN nvarchar(max)

declare customer_cursor cursor for
select CustomerId, CustomerName from Customer

open customer_cursor;
fetch next from customer_cursor into @Id, @Name
while @@FETCH_STATUS = 0
begin

	Print concat('Id: ', @Id);
	Print concat('Name: ', @Name);

	IF LEN(@Name) > 3
    BEGIN
        PRINT 'Valid customer: ' + @Name;
    END
	else
	begin
		RAISERROR('Invalid Name %s', 16, 1, @Name);
	end

	set @UIN = UPPER(FORMATMESSAGE('CUST_UIN_%s_%d', @Name, @Id));

	begin try
	update Customer set Customer_UIN = @UIN where CustomerId  = @Id;
	print Concat('Customer UIN: ', @UIN);
	print ('-------- END --------------');
	end try
	begin catch
        print 'Error occurred while updating Customer_UIN for CustomerId: ' + CAST(@Id AS NVARCHAR);
    end catch;

	fetch next from customer_cursor into @Id, @Name

end
close customer_cursor;
deallocate customer_cursor;

select * from Customer

------------------------------------
----- 2nd problem
--cursor that selects the table_name and column_name columns from the information_schema.columns view for columns of the varchar data type. 
--It then constructs and executes dynamic SQL statements to count the number of NULL values in each varchar column of each table. 
--The cursor iterates over the result set, executing dynamic SQL statements for each fetched row.


SELECT name AS TableName
FROM sys.tables;
 
create table Users(
UserId int primary key identity,
UserName varchar(100),
Email varchar(100)
)

insert into Users(UserName, Email) values
('Scott','scott@gmail.com')
,(null,'smith@gmail.com')
,('Allen', null)
,(null, null)
,('Jack', null)

select * from Users

create table Book(
BookId int primary key identity,
Title varchar(100),
Description varchar(100)
)


insert into Book(Title, Description) values
('Book-1','Description for book-1')
,('Book-2',null)
,(null, 'Desc for Book-3')
,(null, null)
,(null, 'Description fro Book4')

select * from Users

DECLARE @table_name NVARCHAR(128);
DECLARE @column_name NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);
DECLARE @null_count INT;

DECLARE cursor_null_count CURSOR FOR
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'varchar';

OPEN cursor_null_count;

FETCH NEXT FROM cursor_null_count INTO @table_name, @column_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'SELECT @null_count = COUNT(*) FROM ' + QUOTENAME(@table_name) + 
               ' WHERE ' + QUOTENAME(@column_name) + ' IS NULL';
    
    EXEC sp_executesql @sql, N'@null_count INT OUTPUT', @null_count OUTPUT;
    
    PRINT 'Table: ' + @table_name + ', Column: ' + @column_name + ', NULL Count: ' + CAST(@null_count AS NVARCHAR(10));
    
    FETCH NEXT FROM cursor_null_count INTO @table_name, @column_name;
END;

CLOSE cursor_null_count;
DEALLOCATE cursor_null_count;

------------------------------

-- Create a temporary table to store the results
IF OBJECT_ID('tempdb..#NullCounts') IS NOT NULL
    DROP TABLE #NullCounts;

CREATE TABLE #NullCounts (
    TableName NVARCHAR(128),
    ColumnName NVARCHAR(128),
    NullCount INT
);


DECLARE @table_name NVARCHAR(128);
DECLARE @column_name NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);
DECLARE @null_count INT;

DECLARE cursor_null_count CURSOR FOR
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'varchar';

OPEN cursor_null_count;

FETCH NEXT FROM cursor_null_count INTO @table_name, @column_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        SET @sql = N'SELECT @null_count = COUNT(*) FROM ' + QUOTENAME(@table_name) + 
                   ' WHERE ' + QUOTENAME(@column_name) + ' IS NULL';
        
        EXEC sp_executesql @sql, N'@null_count INT OUTPUT', @null_count OUTPUT;
        
        INSERT INTO #NullCounts (TableName, ColumnName, NullCount)
        VALUES (@table_name, @column_name, @null_count);

		PRINT 'Table: ' + @table_name + ', Column: ' + @column_name + ', NULL Count: ' + CAST(@null_count AS NVARCHAR(10));
    END TRY
    BEGIN CATCH
        PRINT 'Error in table: ' + @table_name + ', column: ' + @column_name;
        PRINT ERROR_MESSAGE();
    END CATCH
    
    FETCH NEXT FROM cursor_null_count INTO @table_name, @column_name;
END;

CLOSE cursor_null_count;
DEALLOCATE cursor_null_count;

-- Display the results
SELECT TableName, ColumnName, NullCount
FROM #NullCounts;

-- Clean up
DROP TABLE #NullCounts;

-----------------------------------------------
------ 3rd Problem
--cursor that selects the product_id and product_name columns from the "products" table for products with a price less than 50. 
--It then updates the product_price by increasing it by 10% for each fetched row. The cursor iterates over the result set, 
--performing an update operation for each fetched row.

create table Products(
ProductId int primary key identity,
ProductName varchar(100),
Price decimal(5,2)
)
--drop table Products
insert into Products(ProductName, Price) values
('Pen', 10)
,('Notebook', 45)
,('Textbook', 250)

select * from Products

declare @id int;
declare	@name varchar(100),
		@oldPrice decimal(5,2),
		@newPrice decimal(5,2);
declare update_products_price_cursor cursor for
select ProductId, ProductName, Price from Products
where Price < 50

open update_products_price_cursor;
fetch next from update_products_price_cursor into @id, @name, @oldPrice

while @@FETCH_STATUS = 0
begin

	update Products set Price = @oldPrice*1.1 where ProductId = @Id
	select @newPrice = Price from Products;
	print 'ProductId: ' + CAST(@id AS VARCHAR(10)) + 
          ', ProductName: ' + @name + 
          ', OldPrice: ' + CAST(@oldPrice AS VARCHAR(10)) + 
          ', NewPrice: ' + CAST(@newPrice AS VARCHAR(10));
	fetch next from update_products_price_cursor into @id, @name, @oldPrice

end

close update_products_price_cursor;
deallocate  update_products_price_cursor;

select * from Products

-------------------------------------
------- 4th Problem
--a cursor is used to select employee_id, employee_name, and department_id from the "employees" table. 
--The fetched values are then inserted into the "new_employees" table using an INSERT statement. 
--The cursor iterates over the result set, performing the insert operation for each fetched row.

create table Employees (
   Employee_id INT PRIMARY KEY identity,
    Employee_name VARCHAR(100),
    Email VARCHAR(100),
    Salary DECIMAL(10, 2),
    Department_id INT
);
--drop table Employees
INSERT INTO Employees (Employee_name, Email, Salary, Department_id) VALUES
('John Doe', 'john.doe@example.com', 55000.00, 101),
('Jane Smith', 'jane.smith@example.com', 62000.00, 102),
('Emily Davis', 'emily.davis@example.com', 48000.00, 101),
('Michael Brown', 'michael.brown@example.com', 53000.00, 103),
('Linda Johnson', 'linda.johnson@example.com', 49000.00, 102);

select * from Employees

create table New_EmployeesTable (
    EmployeeID INT primary key,
    EmployeeName VARCHAR(100),
    DepartmentID INT
);

select * from New_EmployeesTable

declare @emp_id int;
declare	@emp_name varchar(100),
		@dept_id int;
declare Insert_Employees_into_New_EmployeeTabe_Cursor cursor for
select Employee_id, Employee_name, Department_id from Employees

open Insert_Employees_into_New_EmployeeTabe_Cursor;
fetch next from Insert_Employees_into_New_EmployeeTabe_Cursor into @emp_id, @emp_name, @dept_id

while @@FETCH_STATUS = 0
begin

	insert into New_EmployeesTable (EmployeeID, EmployeeName, DepartmentID) values
		(@emp_id, @emp_name, @dept_id);
	
	fetch next from Insert_Employees_into_New_EmployeeTabe_Cursor into @emp_id, @emp_name, @dept_id

end

close Insert_Employees_into_New_EmployeeTabe_Cursor;
deallocate  Insert_Employees_into_New_EmployeeTabe_Cursor;

select * from Employees
select * from New_EmployeesTable

--------------------------------
---- 5th Problem
--a cursor that selects the customer_id and the count of orders (total_orders) for each customer from the "orders" table. 
--The cursor then performs an UPDATE operation on the "customers" table, setting the order_count column to the corresponding 
--total_orders value. The cursor iterates over the result set, updating the rows in the "customers" table for each fetched row.

create table Customers (
   Customer_id INT PRIMARY KEY identity,
    Customer_name VARCHAR(100) not null,
    Total_Orders int,
);

-- AddressTable with Customer_id can be done

insert into Customers(Customer_name) values
('Scott'), ('Allen'), ('John'), ('Amith')

create table Orders(
Order_id int primary key identity,
Item varchar(255) not null,
Order_date date default getdate(),
Customer_id int foreign key references Customers(Customer_id)
)

insert into Orders(Item, Customer_id) values
('Water Bottle', 4), ('Shirt', 3), ('Mobile', 2), ('Shoes', 1), ('Watch', 4)
, ('TShirts', 2), ('Laptop', 4), ('Airpods', 3), ('Mobile', 1)

select * from Customers
select * from Orders

declare @Orders_Count int,
		@Customer_id int

declare Update_TotaOrders_Cursor cursor for
select Customer_id from Customers

open Update_TotaOrders_Cursor;
fetch next from Update_TotaOrders_Cursor into @Customer_id;
while @@FETCH_STATUS = 0
begin
	set nocount on;
	select @Orders_Count = COUNT(*) from Orders
	where Customer_id = @Customer_id;

	update Customers set Total_Orders = @Orders_Count 
	where Customer_id = @Customer_id;

	fetch next from Update_TotaOrders_Cursor into @Customer_id;
end
close Update_TotaOrders_Cursor;
deallocate Update_TotaOrders_Cursor;

select * from Customers;
select * from Orders;










 