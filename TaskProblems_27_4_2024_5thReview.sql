
-- Task problems -> 27-4-2024 => 5th Review

create database TaskProblems_Database_27_4_2024_5thReview


--create synonym employees 
--for DQL_Database.dbo.EMPLOYEES

-- Problem-1
select * from DQL_Database.dbo.DEPARTMENT
select * from DQL_Database.dbo.EMPLOYEES

update DQL_Database.dbo.EMPLOYEES
set DEPT_NO = 20							-- 20
where EMP_ID = 7369

-- Problem-2
create table products (
	product_id int primary key identity(1,1),
	product_name varchar(100) not null,
	product_price int not null,
	constraint chk_p_price check(product_price > 0),
	discount int  default 0,
	constraint chk_discount check(discount >= 0 ndd discount <= product_price)
	discounted_price as (product_price - discount) persisted check(discounted_price >= 0)
	);

drop table products

insert into products(product_name,product_price,discount)
values ('product1',1500,100), 
	('product2',2540,75), 
	('product3',5000,250), 
	('product4',3800,200), 
	('product5',7400,340)

insert into products(product_name,product_price,discount) values('product6',0,50)

insert into products(product_name,product_price) values('product7',1000)

select * from products

-- Problem-3
create table sales ( 
	id int primary key identity,
	price int not null,
	catagory varchar(100) not null,
	sold_date date not null  -- order_date
	);

drop table sales

insert into sales (price,catagory,sold_date) 
values (15000,'mobile','2024-04-12'),
		(2000,'mobile','2023-12-20'),
		(38500,'Laptop','2024-02-10'),
		(40000,'Laptop','2023-10-23'),
		(50000,'Laptop','2023-08-15'),
		(10000,'mobile','2024-06-14')

select * from sales

select *, DATEPART(QUARTER,sold_date), DATEPART(QUARTER,GETDATE()), DATEPART(YEAR, sold_date), DATEPART(YEAR, GETDATE())
-- ---- or 
select *, DATEPART(QUARTER,sold_date), DATEPART(QUARTER,GETDATE()), YEAR(sold_date), YEAR(GETDATE()) from sales

select *, DATEDIFF(M,sold_date,GETDATE()) months_diff from sales

-- sales happened in last quarter of the year
select catagory, sum(price) as total_sales_price from sales
where YEAR(sold_date) = YEAR(GETDATE())-1 and DATEPART(quarter, sold_date) = 4 
group by catagory

-- total sales price in last 4 months
select catagory, sum(price) as total_sales_price from sales
where DATEDIFF(M,sold_date,GETDATE()) >= 0 and DATEDIFF(M,sold_date,GETDATE()) <= 4
group by catagory

select *, DATEDIFF(M,sold_date,GETDATE()) months_diff from sales

select catagory, sum(price) as total_sales_price from sales
where DATEPART(QUARTER, sold_date) = DATEPART(QUARTER, GETDATE()) 
group by catagory

select JOB, SUM(SAL) total_sal
from employees
group by JOB
order by total_sal desc

select top 3 JOB, SUM(SAL) total_sal
from employees
group by JOB
order by total_sal desc

select * from sales

-- Problem-4
create table orders (
	order_id int primary key identity,
	empi_id int,
	constraint frk_emp_id foreign key(empi_id) references DQL_Database.dbo.EMPLOYEES(EMP_ID)
	);

select * from DQL_Database.dbo.EMPLOYEES

insert into orders (empi_id) values (7499),(7566),(null)

select e.EMP_NAME, e.DEPT_NO
from DQL_Database.dbo.EMPLOYEES e
inner join DQL_Database.dbo.DEPARTMENT d
on e.DEPT_NO = d.DEPT_NO

-- problem-5
--OrderID	CustomerName	CustomerEmail	ProductID	ProductName	UnitPrice	Quantity	TotalPrice
--these are columns of a table , normalize it

create table cusomers (
	CustomerID Primary Key identity,
	CustomerName varchar(100) not null,
	CustomerEmail varchar(100) unique
	);
create table products (
	ProductID Primary Key identity,
	ProductName varchar(100) not null,
	UnitPrice int
	);

create table orders (
	OrderID Primary Key identity,
	Quantity int,
	TotalPrice int,
	CustomerID int Foreign Key(CustomerID) references Customers(CustomerID),
	ProductID int Foreign Key(ProductID) references Products(ProductID)
	);








