
' SQL SERVER TRIGGERS '

create database TRIGGERS_Database;

use TRIGGERS_Database;

' SQL Server CREATE TRIGGER statement '
/*
The CREATE TRIGGER statement allows you to create a new trigger that is fired automatically whenever an 
	event such as INSERT, DELETE, or UPDATE occurs against a table.
syntax:
		CREATE TRIGGER [schema_name.]trigger_name
		ON table_name
		AFTER  {[INSERT],[UPDATE],[DELETE]}
		[NOT FOR REPLICATION]
		AS
		{sql_statements}

*/

' “Virtual” tables for triggers: INSERTED and DELETED '
/*
SQL Server provides two virtual tables that are available specifically for triggers called INSERTED and DELETED tables. 
SQL Server uses these tables to capture the data of the modified row before and after the event occurs.
*/

create schema production;

create table production.products (
	product_id int primary key identity,
	product_name varchar(100) not null,
	brand_id int not null,
	category_id int not null,
	model_year smallint not null,
	list_price dec(10,2) not null
	);

drop table production.products;
select * from production.products;

' 1) Create a table for logging the changes '
/*The following statement creates a table named production.product_audits to record information when an 
	INSERT or DELETE event occurs against the production.products table:
*/

CREATE TABLE production.product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);

select * from production.product_audits;

' 2) Creating an after DML trigger '

create trigger production.trgAfter_product_audit
on production.products
after insert,delete
as
begin
	set nocount on;

	insert into production.product_audits (product_id,product_name,brand_id,category_id,model_year,list_price,updated_at,operation)
	select product_id,product_name,brand_id,category_id,model_year,list_price,GETDATE(),'INS'
		from inserted i
	union all
	select product_id,product_name,brand_id,category_id,model_year,list_price,GETDATE(),'DEL'
		from deleted as d;
end

drop trigger production.trgAfter_product_audit

' 3) Testing the trigger '

--- Before Insert ---
select * from production.products;
select * from production.product_audits;

INSERT INTO production.products(product_name, brand_id, category_id, model_year, list_price)
VALUES ('Test product-2', 2, 1, 2019, 450);

delete from production.products where product_id = 1

--- After Insert ---
select * from production.products;
select * from production.product_audits;


------------------
create schema sales;

CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

' 1) Basic INSERT example '
INSERT INTO sales.promotions (promotion_name,discount,start_date, expired_date)
VALUES('2018 Summer Promotion',0.15, '20180601','20180901');

select * from sales.promotions;

' 2) Insert and return inserted values '
INSERT INTO sales.promotions (promotion_name,discount,start_date, expired_date)
OUTPUT inserted.promotion_id,
	 inserted.promotion_name,
	 inserted.discount,
	 inserted.start_date,
	 inserted.expired_date
VALUES('2019 Fall Promotion',0.25, '20181001','20181101');

' 3) Insert explicit values into the identity column '
/*To insert explicit value for the identity column, you must execute the following statement first:
SET IDENTITY_INSERT table_name ON;

To switch the identity insert off, you use the similar statement:
SET IDENTITY_INSERT table_name OFF;
*/

SET IDENTITY_INSERT sales.promotions ON; 
	INSERT INTO sales.promotions (promotion_id,promotion_name,discount,start_date, expired_date)
	VALUES(4,'2019 Spring Promotion',0.05, '20190201','20190301');
SET IDENTITY_INSERT sales.promotions OFF;

select * from sales.promotions;

------------------

'======================= 1). DML TRIGGERS =================== '

'---- AFTER INSERT ---- '

create table Employees (
	[Emp_id] [int]  identity(1,1) primary key,
	[Emp_name] [varchar](100)not null,
	[Emp_sal] [decimal](10,2) not null,
	[Emp_dob] [datetime] not null,
	[Emp_experience] [int] not null,
	[Record_datetime] [datetime] not null,
	);
	
create trigger trgAfterInsert_Employees
on Employees
after insert
as
declare @Emp_dob varchar(20);
declare @Age int;
declare @Emp_experience int;

select @Emp_dob = i.Emp_dob from inserted i;
select @Emp_experience = i.Emp_experience from inserted i;

-- Employees's age should no be above 25
set @Age = YEAR(GETDATE()) - YEAR(@Emp_dob);
if @Age > 25
	begin
		print 'Emp_Age: ' + cast(@Age as nvarchar(20));
		print 'Not eligible: Age is greater than 25';
		Rollback
	end

-- Employees's should have experience more than 5 years
else if @Emp_experience < 5
	begin 
		print 'emp_experience: ' + cast(@Emp_experience as nvarchar(20)); 
		print 'Not eligible: Experience is less than 5 years';
		Rollback
	end
else
	begin 
	print 'Employee details inserted successfully'
	end

drop trigger trgAfterInsert_Employees

-- Now test the trigger---
select * from Employees

insert into Employees(Emp_name, Emp_sal,Emp_dob,Emp_experience,Record_datetime)
values ('Smith',5000,'1990-01-03',4,GETDATE())

insert into Employees(Emp_name, Emp_sal,Emp_dob,Emp_experience,Record_datetime)
values ('Smith',5000,'2000-01-03',4,GETDATE())

insert into Employees(Emp_name, Emp_sal,Emp_dob,Emp_experience,Record_datetime)
values ('Allen',4500,'2001-05-21',7,GETDATE())

select * from Employees

'---- AFTER UPDATE ---- '

create table Employee_History (
	Emp_id int not null,
	field_name varchar(100) not null,
	old_value varchar(100) not null,
	new_value varchar(100) not null,
	Record_datetime datetime not null
	)

select * from Employee_History
select * from Employees

create trigger trgAfterUpdate_Employees
on Employees
after update
as

set nocount on

declare @emp_Id int,
		@emp_name varchar(100),
		@old_emp_name varchar(100),
		@emp_sal decimal(10,2),
		@old_emp_sal decimal(10,2);

select @emp_Id = i.Emp_id from inserted i;
select @emp_name = i.Emp_name from inserted i;
select @old_emp_name = d.Emp_name from deleted d;
select @emp_sal = i.Emp_sal from inserted i;
select @old_emp_sal = d.Emp_sal from deleted d;

if UPDATE(Emp_name)
	begin
		insert into Employee_History(Emp_id,field_name,old_value,new_value,Record_datetime)
		values (@emp_Id,'Emp_name',@old_emp_name,@emp_name,GETDATE());
	end
if UPDATE(Emp_sal)
	begin
		insert into Employee_History(Emp_id,field_name,old_value,new_value,Record_datetime)
		values (@emp_Id,'Emp_sal',@old_emp_sal,@emp_sal,GETDATE());
	end

drop trigger trgAfterUpdate_Employees

--- Before Update ---
select * from Employee_History;
select * from Employees;

Update Employees set Emp_name = 'Clerk' where Emp_id = 12;

update Employees set Emp_sal = 15000 where Emp_id = 12

--- After Update ---
select * from Employee_History;
select * from Employees;

'---- AFTER DELETE ---- '

create table Employee_Backup (
	[Emp_id] [int] not null,
	[Emp_name] [varchar](100) not null,
	[Emp_sal] [decimal](10,2) not null,
	[Emp_dob] [datetime] not null,
	[Emp_experience] [int] not null,
	[Record_datetime] [datetime] not null,
	);

alter trigger trgAfterDelete_Employees
on Employees
after delete
as

set nocount on

--insert into Employee_Backup
--select * from deleted [as d];

insert into Employee_Backup (Emp_id,Emp_name,Emp_sal,Emp_dob,Emp_experience,Record_datetime)
select Emp_id,Emp_name,Emp_sal,Emp_dob,Emp_experience,GETDATE()
from deleted;
print 'Employee details deleted successfully';

drop table Employee_Backup
drop trigger trgAfterDelete_Employees

--- Before Deleete ----
select * from Employees;
select * from Employee_Backup;

delete from Employees where Emp_id = 13

--- After Deleete ----
select * from Employees;
select * from Employee_Backup;

' --------------- SQL Server DISABLE TRIGGER --------------------- '

/*
Sometimes, for the troubleshooting or data recovering purpose, you may want to disable a trigger temporarily. 
To do this, you use the DISABLE TRIGGER statement:

DISABLE TRIGGER [schema_name.][trigger_name] 
ON [object_name | DATABASE | ALL SERVER]

specify the table name or view that the trigger was bound to if the trigger is a DML trigger. 
Use DATABASE if the trigger is DDL database-scoped trigger, or SERVER if the trigger is DDL server-scoped trigger.

*/

create schema sales;
CREATE TABLE sales.members (
    member_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    member_level CHAR(10) NOT NULL
);

create trigger sales.trg_members_insert
on sales.members
after insert
as
begin
	print 'A new member is inserted';
end

INSERT INTO sales.members(customer_id, member_level)
VALUES(1,'Silver');

DISABLE trigger sales.trg_members_insert
on sales.members;

INSERT INTO sales.members(customer_id, member_level)
VALUES(2,'Gold');

' ---- Disable all trigger on a table --- '
-- syntax: DISABLE TRIGGER ALL ON table_name;

CREATE TRIGGER sales.trg_members_delete
ON sales.members
AFTER DELETE
AS
BEGIN
    PRINT 'A new member has been deleted';
END;

delete from sales.members where member_id = 2;

select * from sales.members;

Disable trigger all on sales.members;


delete from sales.members where member_id = 1;

' ---- Disable all triggers on a database --- '
-- syntax: Disable all triggers on a database

' --------------- SQL Server ENABLE TRIGGER --------------------- '
/*
The ENABLE TRIGGER statement allows you to enable a trigger so that the trigger can be fired whenever an event occurs.
syntax: 
		ENABLE TRIGGER [schema_name.][trigger_name] 
		ON [object_name | DATABASE | ALL SERVER]

*/

INSERT INTO sales.members(customer_id, member_level)
VALUES(3,'Silver');

ENABLE TRIGGER sales.trg_members_insert on sales.members;

INSERT INTO sales.members(customer_id, member_level)
VALUES(4,'Platinum');

' Enable all triggers of a table '
-- syntax: ENABLE TRIGGER ALL ON table_name;

' Enable all triggers of a database '
-- syntax: ENABLE TRIGGER ALL ON DATABASE; 

'---------------- SQL Server View Trigger Definition -------------------- '
' 1. Getting trigger definition by querying from a system view '
-- You can get the definition of a trigger by querying data against the sys.sql_modules view:

SELECT 
    definition   
FROM 
    sys.sql_modules  
WHERE 
    object_id = OBJECT_ID('sales.trg_members_delete'); 

' 2. Getting trigger definition using OBJECT_DEFINITION function '
-- You can get the definition of a trigger using the OBJECT_DEFINITION function as follows:

SELECT 
    OBJECT_DEFINITION (
        OBJECT_ID(
            'sales.trg_members_delete'
        )
    ) AS trigger_definition;

' 3. Getting trigger definition using sp_helptext stored procedure  ********************* '
-- The simplest way to get the definition of a trigger is to use the sp_helptext stored procedure as follows:

EXEC sp_helptext 'sales.trg_members_delete' ;

' 4. Getting trigger definition using SSMS '

------------------------------

'---------------- SQL Server DROP TRIGGER -------------------- '
-- To list all triggers in a SQL Server, you query data from the sys.triggers view:

SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR';

'---------------- SQL Server View Trigger Definition -------------------- '
/*
The SQL Server DROP TRIGGER statement drops one or more triggers from the database.
For DML triggers -> syntax: DROP TRIGGER [ IF EXISTS ] [schema_name.]trigger_name [ ,...n ];
For DDL triggers -> syntax: DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ] ON { DATABASE | ALL SERVER };
To remove a LOGON event trigger, you use the following syntax:
	DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]   
	ON ALL SERVER;
*/

-- The following statement drops a DML trigger named sales.trg_member_insert:

DROP TRIGGER IF EXISTS sales.trg_member_insert;

-- The following statement removes(DDL trigger) the trg_index_changes trigger:

DROP TRIGGER IF EXISTS trg_index_changes;

-- =================================================================

'======================= 2). DDL TRIGGERS =================== '

/*
SQL Server DDL triggers respond to server or database events rather than to table data modifications. 
These events created by the Transact-SQL statement that normally starts with one of the following keywords 
	CREATE, ALTER, DROP, GRANT, DENY, REVOKE, or UPDATE STATISTICS.

The DDL triggers are useful in the following cases:
1. Record changes in the database schema.
2. Block the user prevent some specific changes to the database schema or drop table or drop pocedure etc.
3. Respond to a change in the database schema.
4. Track the DDL Statement which is fired.
5. To identify who have dropped tha table or who have modified the table.
6. To track Date & Time when DDL Statement if fired.
7. Allow the DDL changes only during a specified window(i.e. only during particular hours of the day).

Types: 2
1. Database Scope DDL Trigger.
1. Server Scope DDL Trigger.

The following shows the syntax of creating a DDL trigger:
		CREATE TRIGGER trigger_name
		ON { DATABASE |  ALL SERVER}
		[WITH ddl_trigger_option]
		FOR {event_type | event_group }
		AS {sql_statement}

 // trigger_name
Specify the user-defined name of trigger after the CREATE TRIGGER keywords. Note that you don’t have to specify a schema for a DDL trigger because it isn’t related to an actual database table or view.

//  DATABASE | ALL SERVER
Use DATABASE if the trigger respond to database-scoped events or ALL SERVER if the trigger responds to the server-scoped events.

 // ddl_trigger_option
The ddl_trigger_option specifies ENCRYPTION and/or EXECUTE AS clause. ENCRYPTION encrypts the definition of the trigger. EXECUTE AS defines the security context under which the trigger is executed.

 // event_type | event_group
The event_type indicates a DDL event that causes the trigger to fire e.g., CREATE_TABLE, ALTER_TABLE, etc.

// The event_group is a group of event_type event such as DDL_TABLE_EVENTS.

// A trigger can subscribe to one or more events or groups of events.

*/

-- First, create a new table named index_logs to log the index changes:
CREATE TABLE index_logs (
    log_id INT IDENTITY PRIMARY KEY,
    event_data XML NOT NULL,
    changed_by SYSNAME NOT NULL
);
GO

-- Next, create a DDL trigger to track index changes and insert events data into the index_logs table:

CREATE TRIGGER trg_index_changes
ON DATABASE
FOR	
    CREATE_INDEX,
    ALTER_INDEX, 
    DROP_INDEX
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO index_logs (
        event_data,
        changed_by
    )
    VALUES (
        EVENTDATA(),
        USER
    );
END;
GO

-- In the body of the trigger, we used the EVENTDATA() function that returns the information about 
--	server or database events. The function is only available inside DDL or logon trigger.

-- Then, create indexes for the first_name and last_name columns of the sales.customers table:

create table sales.customers(
	customer_id int primary key identity,
	first_name varchar(50) not null,
	last_name varchar(50) not null
	);

CREATE NONCLUSTERED INDEX nidx_fname
ON sales.customers(first_name);
GO

CREATE NONCLUSTERED INDEX nidx_lname
ON sales.customers(last_name);
GO

-- After that, query data from the index_changes table to check whether the index creation event was captured 
-- by the trigger properly:

SELECT * FROM index_logs;

--------------------------------------------
create database Test_DDLTrigger_Database;
use Test_DDLTrigger_Database;

create table test ( int int );

use Test_DDLTrigger_Database
go
create trigger TrgPreventCreateTable
on database
For Create_Table
as
begin
	print 'You cannot createn a table in this database';
	Rollback Transaction;
end

create table test2 (id int );

--

use Test_DDLTrigger_Database
go
alter trigger TrgPreventCreateTable
on database
For Create_Table, Alter_Table,Drop_Table
as
begin
	print 'You cannot createn or alter or drop a table in this database';
	Rollback Transaction;
end

create table test2 ( id int )
--- or
alter table test
add name varchar(50);
-- or 
drop table test;

/*
1. DDL_TABL_EVENTS, 2. DDL_PROCEDURE_EVENTS 3. DDL_ROLE_EVENTS, 4. DDL_FUNCTINS_EVENTS
create/alter/drop_Table/Procedures/Role/Functions
*/

create trigger TrgEventGroup
on database
for DDL_TABLE_EVENTS
as
begin
print 'You cannot create, alter. or drop table';
Rollback Transaction
end

create table test2 ( id int )
--- or
alter table test
add name varchar(50);
-- or 
drop table test;

' o/p: You cannot createn or alter or drop a table in this database '

' Use of Event Groups on Server Level '
create trigger TrgServerAll
on All Server
for DDL_TABLE_EVENTS
as
begin
	print 'You cannot create, alter, drop table in any database';
	Rollback Transaction
end

create database Test_DDLTrigger_DB1;
create database Test_DDLTrigger_DB2;
create database Test_DDLTrigger_DB3;

use Test_DDLTrigger_DB1
go
create table test(var int);
--- or ---
use Test_DDLTrigger_DB2
go
create table test(id int);
--- or ---
use Test_DDLTrigger_DB3
go
create table test(id int);

' o/p: You cannot create, alter, drop table in any database '


' --------------------- Track Schema Changes Event (Audit Trigger) -------------------- '
/*
EVENTDATA(): is an inbuilt function of DDL trigger in SQL Server, which will return the Transaction event details
	witth numerous fields in XML Format.
	*). EventType(Create Table, Alter Table, Drop Table, etc...)
	*). PostTime(Event Trigger Time)
	*). SPID(SQL Server Session ID)
	*). ServerName(SQL Server instance name)
	*). LoginName(SQL Server Login name)
	*). UserName(username for login, by default dbo schema as username)
	*). DatabaseName(Name of database where DDL Trigger was executed)
	*). SchemaName(schema name of the table)
	*). ObjectName(Name of the Table)
	*). ObjectType(Object types, such as Table, views, procedures, etc...)
	*). TSQLCommand(Schema deployment Query which is executed by user)
	*). SetOptions(Set Options which are applied while Creating table or Modify it)

*/

disable trigger TrgServerAll
on all server;

drop trigger TrgServerAll
on all server;

use Test_DDLTrigger_DB1
go
create table AuditTable(
	DatabaseName nvarchar(250),
	TableName  nvarchar(250),
	EventType  nvarchar(250),
	LoginName  nvarchar(250),
	SQLCommand  nvarchar(2500),
	AuditDateTime datetime
	);

drop table AuditTable;

select * from AuditTable;

create trigger TrgAuditTableChangesInAllDatabases
on all server
for create_table,alter_table,drop_table
as
begin
	declare @EventData XML
	select @EventData = EVENTDATA();
	insert into Test_DDLTrigger_DB1.AuditTable(DatabaseName,TableName,EventType,LoginName,SQLCommand,AuditDateTime)
	values (
	@EventData.value('(/Event_Instance/DatabaseName)[1]', 'varchar(250)'),
	@EventData.value('(/Event_Instance/ObjectName)[1]', 'varchar(250)'),
	@EventData.value('(/Event_Instance/EventType)[1]', 'nvarchar(250)'),
	@EventData.value('(/Event_Instance/LoginName)[1]', 'varchar(250)'),
	@EventData.value('(/Event_Instance/TSQLCommand)[1]', 'nvarchar(250)'),
	GETDATE()
	)
end

--  **************** pending(not getting output)

drop trigger TrgAuditTableChangesInAllDatabases
on all server;

create table tt(id int);

use Test_DDLTrigger_DB1
go
create table test(id int)

drop table test;

--------------------------------------------

create table  t(id int)




