CREATE DATABASE First_Database;

USE First_Database;

-- PARENT TABLE
CREATE TABLE customers (
	customer_id INT PRIMARY KEY IDENTITY(1,1),
	customer_name VARCHAR(100) NOT NULL,
	phone BIGINT UNIQUE,
	CONSTRAINT chk_phone CHECK (PHONE>=6000000000 AND phone<=9999999999),
	dob DATE NOT NULL,
	age AS ((DATEDIFF(d,dob,GETDATE())/365.25)),  -- adding computed column
	email NVARCHAR(100),
	gender VARCHAR(10) NOT NULL CHECK (gender IN ('male','female','other')),
	);

-- add column 'state'
alter table customers
add state varchar(20);

-- add default constraint using 'add constraint' statment
alter table customers
add constraint dflt_state default 'karnataka' for state;

-- alter data type of email & also add not null constrant(b/z we cannot directly add not null constraint using 'add constraint' statment)
alter table customers
alter column email varchar(50) not null

-- add unique constraint to email using 'add constraint' statement
alter table customers
add constraint uq_email unique (email)

-- drop default constraint for state column unsing 'drop constrint'
alter table customers
drop constraint dflt_state

-- add check constraint to email for formatt (@gmail.com or @_%.in)
alter table customers
add constraint chk_email check(email like '[a-z][a-z0-9]%@gmail.com' OR email like '[a-z][a-z0-9]%@[a-z][a-z0-9]%.in');

-- drop check constraint for email column unsing 'drop constrint'
--- 1st way
alter table customers
drop constraint chk_email
--- OR 2nd way
alter table customers
NOCHECK constraint chk_email

select * from customers

delete from customers
where customer_id = 29

-- insert records
insert into customers (customer_name,phone,dob,email,gender) 
values ('Smith',7879639233,'1995-2-15','smith33@gmail.com','other')

-- insert records -> default constraint of state column is removed & explicitly specifying value
insert into customers (customer_name,phone,dob,email,gender,state) 
values ('Allen',6879639288,'2008-5-8','allen8@gmail.com','female','pune')

-- insert records -> default constraint of state column is removed % since not passing value, so it will store null value
insert into customers (customer_name,phone,dob,email,gender) 
values ('Allen',6879639299,'2008-5-8','allen9@gmail.com','female')

delete from customers
where customer_id = 30

select * from customers
truncate table customers
drop table customers;

--------------------
-- CHILD TABLE
CREATE TABLE orders (
	order_id UNIQUEIDENTIFIER DEFAULT NEWID(),
	order_date DATE DEFAULT GETDATE(),
	amount DECIMAL(7,2) NOT NULL,
	customer_id int,
	is_delivered BIT NOT NULL DEFAULT 0,
	rating VARCHAR(10) DEFAULT 'N/A',
	CONSTRAINT chk_rating check(rating='N/A' OR (rating like '[1-5]')),
	CONSTRAINT frnk_customer_id FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
	);

-- drop check constraint for rating
alter table orders
drop constraint chk_rating

-- add check constraint for rating
--alter table orders
--add constraint chk_rating check ( rating

-- drop default constraint for rating
alter table orders
drop constraint DF__orders__rating__14270015

-- alter rating column -> cannot alter b/z cannot convert datatype from varchar to numeric -> so we need to drop column
--alter table orders
--alter column rating decimal(1,1) null

-- drop rating column
alter table orders
drop column rating

-- add rating column (decimal datatype)
alter table orders
add rating FLOAT null,
constraint chk_rating check(rating > 0 and rating <=5)

-- add rating column (varchar datatype)
--alter table orders
--add rating varchar(10) DEFAULT 'N/A'
--constraint df_rating DEFAULT 'N/A' for rating,
--constraint chk_rating check(rating='N/A' OR (rating like '[1.0-5.0]'))

select * from orders

-- add check constraint for rating(for previos one when var data type)
--alter table orders
--add constraint chk_rating check(rating='N/A' OR (rating like '[1-5]'))

-- insert record with default values
insert into orders (amount,customer_id) values (2500,18);

-- insert records with specifying values for order_date but yet it not delivered
insert into orders (order_date,amount,customer_id) values ('2024-4-18',2499,10),('2024-4-22',999.9,18)

insert into orders (order_date,amount,customer_id) values ('2024-4-20',6500.6,25),('2024-4-23',125.25,18)


-- update records considering order delivered, so specifying the values for is_delivered & rating
update orders
set is_delivered = 1, rating=3.6
where order_date = '2024-04-25' and customer_id = 18

update orders
set is_delivered = 1, rating=4.2
where order_date = '2024-04-20' and customer_id = 25

select * from customers
select * from orders
truncate table orders
drop table orders









