
-- DDL -> Data Definition operations

create database DDL_Database

use DDL_Database

-- backup database
--backup database DDL_Database
--to disk = 'F:\DotNet\DotNetProjects\Database Files\DDL_Database_backup';

--drop if exists database DDL_Database

-- create schema
create schema first_schema

-- drop schema
drop schema first_schema
drop schema if exists first_schema

create table Students ( 
	student_id int primary key identity(1,1),
	student_name varchar(50) not null,
	student_age int not null,
	address nvarchar(100)
	);

select * from Students;

insert into Students(student_name,student_age) values ('Arun', 19)

exec sp_rename 'Students', 'students' -- rename table

select * from students;

-- drop column single column
alter table students
drop column address

-- add column single column
alter table students
add class varchar(20) not null

-- add column multiple columns
alter table students
add dob date, address nvarchar(100)

insert into Students(student_name,student_age,dob,address) values ('Arun', 19,'2003-6-16','HSR Layout')

select * from Students

-- alter datatype for address column
alter table students
alter column address varchar(150)

-- add constraint for address column
alter table students
add constraint unq_address unique (address)

-- drop unique constraint for address column
alter table students
drop constraint unq_address

-- drop column multiple columns
alter table students
drop column address, class

select * from Students

-- add computed column
alter table students
add details as (student_name + ' ' + address)

insert into Students(student_name,student_age,dob,address) values ('Raj', 24,'2000-3-28','Marathalli')

select * from Students

-- select into -> copy data from one table to new table
select *
into students_copy
from Students

select * from students_copy

-- creating Temporal table
-- It is accessed within this cnnection
select * 
into #students_temp1
from students

select * from #students_temp1

drop table if exists #students_temp1

-- Global Temporal table creation
select * 
into ##students_gllobal_temp1
from students

select * from ##students_gllobal_temp1

drop table if exists ##students_gllobal_temp1

-- creating synonym for students table
create synonym students_synonym
for students

select * from students_synonym

drop synonym if exists students_synonym

-- truncate tabl
truncate table students

--- copy table records from this database to another database table
create database DDL_Database;

select *
into DDL_Database.dbo.students
from students

select * from DDL_Database.dbo.students
-----------------

-- drop table
drop table if exists students

-- backup database
backup database DDL_Database
to disk = 'F:\DotNet\DotNetProjects\Database Files\DDL_Database_backup';

drop database if exists DDL_Database







