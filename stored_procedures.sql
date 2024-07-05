
' STORED PROCEDURES '

create database Stored_Procedures_Database

use Stored_Procedures_Database

/*
SQL Server stored procedures are used to group one or more Transact-SQL statements into logical units. 
The stored procedure is stored as a named object in the SQL Server Database Server.

When you call a stored procedure for the first time, SQL Server creates an execution plan and stores it in the cache. 
In the subsequent executions of the stored procedure, SQL Server reuses the plan to execute the stored procedure very fast 
with reliable performance.

*/

-----------------------------------------------------------------

create procedure uspEmployeeList
as
begin
	select EMP_ID, EMP_NAME, SAL  from employees
	order by EMP_NAME
end

uspEmployeeList

/*
The AS keyword separates the heading and the body of the stored procedure.
If the stored procedure has one statement, the BEGIN and END keywords surrounding the statement are optional. 
	However, it is a good practice to include them to make the code clear.
Note that in addition to the CREATE PROCEDURE keywords, you can use the CREATE PROC keywords to make the statement shorter.
*/

alter proc uspEmployeeList
as
begin 
	select EMP_ID, EMP_NAME, SAL from employees 
	where SAL < 2500
	order by SAL desc
end

drop proc uspEmployeeList

uspEmployeeList

create proc uspInlineParam_FindEmployees(@min_salary int)
as
begin
	select * from employees
	where SAL >= @min_salary
	order by SAL
end

uspInlineParam_FindEmployees 1500

uspInlineParam_FindEmployees 2500

alter proc uspInlineParam_FindEmployees(@min_salary int, @max_salary int)
as
begin
	select * from employees
	where SAL >= @min_salary and SAL <= @max_salary
	order by SAL desc
end

uspInlineParam_FindEmployees 1500, 3000
--- or ----
uspInlineParam_FindEmployees @max_salary = 3000, @min_salary = 1500

alter proc uspInlineParam_FindEmployees(@min_salary int, @max_salary int, @name varchar(20))
as
begin
	select * from employees
	where SAL between @min_salary and @max_salary
	and EMP_NAME like '%' + @name + '%'
	order by SAL desc
end

uspInlineParam_FindEmployees 1500, 3000, 'll'

uspInlineParam_FindEmployees 1000, 3000, 'll'

create proc uspOptionalParam_FindEmployees(
	@min_salary int = 1000, 
	@max_salary int = 3000, 
	@name varchar(20))
as
begin
	select * from employees
	where SAL between @min_salary and @max_salary
	and EMP_NAME like '%' + @name + '%'
	order by SAL desc
end;

uspOptionalParam_FindEmployees @name = 'er'

uspOptionalParam_FindEmployees @name = 'er', @min_salary = 1500

create procedure uspOptionalNullParam_Findemployees(
	@min_salary int = 1000,
	@max_salary int = null,
	@name varchar(20)
	)
as
begin
	select * from employees
	where SAL >= @min_salary and (@max_salary is null or sal <= @max_salary)
	and EMP_NAME like '%' + @name + '%'
	order by sal desc
end;

drop procedure uspOptionalNullParam_Findemployees

uspOptionalNullParam_Findemployees @name = 'r'
--- or --- both are same
uspOptionalNullParam_Findemployees @name = 'r', @max_salary = null

uspOptionalNullParam_Findemployees @name = 'r', @max_salary = 2000

'----- Variables ---- '
/*
A variable is an object that holds a single value of a specific type e.g., integer, date, or varying character string.

We typically use variables in the following cases:
	As a loop counter to count the number of times a loop is performed.
	To hold a value to be tested by a control-of-flow statement such as WHILE.
	To store the value returned by a stored procedure or a function

DECLARE syntax: DECLARE @vaiable_name1 [AS](OPTIONAL) Datatype,
						@vaiable_name2 [AS](OPTIONAL) Datatype,
						@vaiable_namen [AS](OPTIONAL) Datatype;

By default, when a variable is declared, its value is set to NULL.

INITIALIZATION / SET / ASSIGNING syntax: SET @vaiable_name = value;

*/

Declare @hire_year int;
set @hire_year = 1987;
select EMP_NAME, HIREDATE, SAL from employees
	where YEAR(HIREDATE) = @hire_year
	order by EMP_NAME;

Declare @emp_count int;
Select @emp_count = COUNT(*) from employees;
SELECT @emp_count as emp_count;

Declare @distinct_sal_count int;
Select @distinct_sal_count = COUNT(distinct SAL) from employees;
--PRINT @distinct_sal_counts;  -- *******
--- or ---
PRINT 'The number of Distinct salary count: ' + cast(@distinct_sal_count as varchar(100))

' To hide the number of rows affected messages, you use the following statement: SET NOCOUNT ON;   '

Declare @empName varchar(100),
		@salary decimal(7,2);

select @empName = EMP_NAME, @salary = SAL from employees
	where EMP_ID = 7566

Select @empName as empName,
		@salary salary;

' Accumulating values into a variable '

create proc uspGetEmpListIntoVariable(
	@deptNo smallint
	)
as
begin

	Declare @EmpList varchar(max);
	Set @EmpList = '';

	select @EmpList = @EmpList + EMP_NAME + char(10)
		from employees
		where DEPT_NO = @deptNo
		order by EMP_NAME;

		PRINT @EmpList;
end;

uspGetEmpListIntoVariable 20

' Note that the CHAR(10) returns the line feed character. '

' Stored Procedure Output Parameters '
/*
To create an output parameter for a stored procedure, you use the following syntax:
	parameter_name data_type OUTPUT

A stored procedure can have many output parameters. In addition, the output parameters can be in any valid data type 
	e.g., integer, date, and varying character.
*/

create proc uspOutputParam_FindEmployee(
	@deptNo smallint,
	@employees_count int Output
	)
as
begin
	
	select * from  employees
	where DEPT_NO = @deptNo

	Select @employees_count = @@ROWCOUNT;
end

drop proc uspOutputParam_FindEmployee

declare @emp_count smallint;
exec uspOutputParam_FindEmployee @deptNo = 20, @employees_count = @emp_count Output;
select @emp_count as emp_count;

' Note that the @@ROWCOUNT is a system variable that returns the number of rows read by the previous statement. '

create proc uspOutputParam_FindEmployee2(
	@deptNo smallint,
	@empployees_count int Output
	)
as
begin
	--declare @emp_count int;
	--select @emp_count = COUNT(*) from  employees
	--where DEPT_NO = @deptNo
	----select @emp_count as emp_count1 -- 5
	--Set @empployees_count = @emp_count 

	select @empployees_count = COUNT(*) from  employees
	where DEPT_NO = @deptNo
end

drop proc uspOutputParam_FindEmployee2

declare @empployees_count2 smallint;
exec uspOutputParam_FindEmployee2 20, @empployees_count2 output;
select @empployees_count2 as emp_count2; 

declare @empployees_count3 smallint;
exec uspOutputParam_FindEmployee2 30, @empployees_count3 output;
select @empployees_count3 as 'Number of employees found'

' Note that if you forget the OUTPUT keyword after the @count variable, the @count variable will be NULL. '

----------------------------------------------------------

' NON-PARAMETER STORED PROCEDURE '

select *
into employees
from DQL_Database.dbo.EMPLOYEES;

select * from employees;
drop SYNONYM employees
---------

create procedure spNonParam_GetEmployee1
as
begin 
	select * from employees where Dept_no = 10;
	select * from employees where emp_name = 'Turner';
end;

spNonParam_GetEmployee1
exec spNonParam_GetEmployee1
execute spNonParam_GetEmployee1

alter proc spNonParam_GetEmployee1
as 
begin
	select * from employees where job = 'manager';
	select * from employees WHERE sal > 2500;
end

spNonParam_GetEmployee1

drop procedure spNonParam_GetEmployee1

' INPUT PARAMETERIZED STORED PROCEDURE '

create proc spInputParam_GetEmpoyeeList
@deptNo int,
@salary int
as
begin
	select * from employees where dept_no = @deptNo;
	select * from employees WHERE sal < @salary
	order by sal desc;
end

drop proc spInputParam_GetEmpoyeeList

spInputParam_GetEmpoyeeList 20, 2500

spInputParam_GetEmpoyeeList 10, 1500

' Named Parameters value '
spInputParam_GetEmpoyeeList @salary = 2000, @deptNo = 30

spInputParam_GetEmpoyeeList @deptNo = 30, @salary = 2000

create table employees2(
	emp_id int primary key identity,
	empName varchar(50) not null,
	salary int not null
	)

select * from employees2

drop table employees2

create procedure spAddEmployees(
@emp_name varchar(50),
@sal int
)
as
begin
insert into employees2(empName,salary) values (@emp_name,@sal)
end;

drop procedure spAddEmployees

spAddEmployees 'Tom', 30000
exec spAddEmployees  'Jerry', 40000
execute spAddEmployees 'Smith', 50000

select * from employees2

' Default Parameter / Optional Parameter: Parameter(s) with value(s)(default)  '

create proc spDefaultParam_GetEmployees
@deptNo int = 30,
@salary int = 2000
as
begin
	select * from employees where dept_no = @deptNo;
	select * from employees WHERE sal < @salary
	order by sal desc;
end 

spDefaultParam_GetEmployees 

spDefaultParam_GetEmployees 20, 1000

spDefaultParam_GetEmployees @salary = 1000  --- *********

create proc spDefaultNullParam_GetEmployees(
	@min_salary int = 1000,
	@max_salary int = null
	)
as
begin
	select * from employees
	where SAL >= @min_salary and 
	(@max_salary is null or SAL <= @max_salary)
	order by SAL desc
end

drop proc spDefaultNullParam_GetEmployees

spDefaultNullParam_GetEmployees @max_salary = 2000

spDefaultNullParam_GetEmployees @max_salary = null
--- or --- both are same
spDefaultNullParam_GetEmployees 

' OUTPUT PARAMETER STORED PROCEDURE '

create proc spOutputParam_AddDigits
@num1 int,
@num2 int,
@Result int Output
as
begin
	set @Result = @num1 + @num2;
end

drop proc spOutputParam_AddDigits

declare @Result int;
exec spOutputParam_AddDigits 2,5,@Result Output;  -- exec keyword is must
select @Result;

declare @Sum int;
exec spOutputParam_AddDigits 24, 14, @Sum Output;
select @Sum;

' Stored Procedures Security (wwith encryption)'

sp_helptext spOutputParam_AddDigits

alter proc spOutputParam_AddDigits
@num1 int,
@num2 int,
@Result int Output
with encryption
as
begin
	set @Result = @num1 + @num2;
end

sp_helptext spOutputParam_AddDigits


'================ Section 2. Control-of-flow statements ==================== '
/*
BEGIN…END – create a statement block that consists of multiple Transact-SQL statements that execute together.
IF ELSE – execute a statement block based on a condition.
WHILE – repeatedly execute a set of statements based on a condition as long as the condition is true.
BREAK – exit the loop immediately and skip the rest of the code after it within a loop.
CONTINUE – skip the current iteration of the loop immediately and continue the next one.

*/

' ------- 1. BEGIN...END ---------- '
/*
The BEGIN...END statement is used to define a statement block. A statement block consists of a set of SQL statements 
	that execute together. A statement block is also known as a batch.

In other words, if statements are sentences, the BEGIN...END statement allows you to define paragraphs.

The following illustrates the syntax of the BEGIN...END statement:

BEGIN
    { sql_statement | statement_block}
END

The BEGIN... END statement bounds a logical block of SQL statements. We often use the BEGIN...END at the start and end of a 
	stored procedure and function. But it is not strictly necessary.

However, the BEGIN...END is required for the IF ELSE statements, WHILE statements, etc., where you need to wrap multiple statements.

*/

BEGIN
	select EMP_ID, EMP_NAME, SAL from employees
	where SAL > 50000;

	if @@ROWCOUNT = 0
	PRINT 'No Employees found with salary greater than 5000';

END

' Nesting BEGIN... END '

BEGIN
Declare @name varchar(50);
	select top 1 @name = EMP_NAME from employees
	order by SAL desc;

	if @@ROWCOUNT <> 0
	begin
	Print 'The most expensive emloyee : ' + @name;
	end
	else 
	begin
	Print 'The emloyee not found ';
	end
END

' ------- 2. IF ELSE ---------- '
/*
The IF...ELSE statement is a control-flow statement that allows you to execute or skip a statement block based on a 
	specified condition.

syntax:
		IF boolean_expression   
		BEGIN
			{ statement_block }
		END

Note that if the Boolean expression contains a SELECT statement, you must enclose the SELECT statement in parentheses.

*/

select *
into department
from DQL_Database.dbo.DEPARTMENT

select * from department;
drop table department
---------

begin
declare @sum_sal int;
	select @sum_sal = SUM(sal)
	from employees e
	inner join department d on e.DEPT_NO = d.DEPT_NO
	where YEAR(HIREDATE) = 1981;

	select @sum_sal;

	if @sum_sal > 10000
	begin
	print 'Great, In 1981, Empoyees found for sum of salary > 10000'
	end
end

begin
declare @sum_sal int;
	select @sum_sal = SUM(sal)
	from employees e
	inner join department d on e.DEPT_NO = d.DEPT_NO
	where YEAR(HIREDATE) = 1987;

	select @sum_sal;

	if @sum_sal > 10000
	begin
	print 'Great, In 1981, Empoyees found for sum of salary > 10000'
	end
	else
	begin
	print 'In 1987, Empoyees not found for sum of salary > 10000'
	end
end

' Nested IF...ELSE '

begin
	declare @x int = 10,
			@y int = 20;
	if @x > 0
	begin
		if @x < @y
			print 'x > 0 and x < y '
		else
			print 'x > 0 and x > y '
	end
end

' ------- 3. WHILE ---------- '	  
/*
syntax: 
	WHILE Boolean_expression   
     { sql_statement | statement_block}  

Second, sql_statement | statement_block is any Transact-SQL statement or a set of Transact-SQL statements. 
	A statement block is defined using the BEGIN...END statement.

Note that if the Boolean_expression contains a SELECT statement, it must be enclosed in parentheses.

To exit the current iteration of the loop immediately, you use the BREAK statement. 
To skip the current iteration of the loop and start the new one, you use the CONTINUE statement.

*/

declare @counter int = 1;

while @counter <= 5

begin
	Print @counter;
	set @counter = @counter + 1;
end

' ------- 4. BREAK ---------- '	  
/*
To exit the current iteration of a loop(WHILEs), you use the BREAK statement.

syntax:
	WHILE Boolean_expression
	BEGIN
		-- statements
	   IF condition
			BREAK;
		-- other statements    
	END

Suppose we have a WHILE loop nested inside another WHILE loop:

WHILE Boolean_expression1
BEGIN
    -- statement
    WHILE Boolean_expression2
    BEGIN
        IF condition
            BREAK;
    END
END
Code language: SQL (Structured Query Language) (sql)
In this case, the BREAK statement only exits the innermost loop in the WHILE statement.

Note that the BREAK statement can be used only inside the WHILE loop. 
The IF statement is often used with the BREAK statement but it is not required.
*/

declare @counter int = 0;
while @counter <= 5
begin
	set @counter += 1;
	if @counter = 4
		break;
	Print @counter;
end
-- O/P: 1 2 3

' ------- 5. CONTINUE ---------- '	  
/*
The CONTINUE statement stops the current iteration of the loop and starts the new one. 

The following illustrates the syntax of the CONTINUE statement:

WHILE Boolean_expression
BEGIN
    -- code to be executed
    IF condition
        CONTINUE;
    -- code will be skipped if the condition is met
END

*/

declare @counter int = 0;
while @counter < 5
begin
	set @counter += 1;
	if @counter = 3
		continue;
	print @counter;
end

-- O/P: 1 2 4 5


'================ Section 2. Handling Exceptions ==================== '

/*
TRY CATCH – learn how to handle exceptions gracefully in stored procedures.
RAISERROR – show you how to generate user-defined error messages and return it back to the application using 
	the same format as the system error.
THROW – walk you through the steps of raising an exception and transferring the execution to the CATCH block of a 
	TRY CATCH construct.
*/


' ----- 1. TRY CATCH ----- '

/*
The TRY CATCH construct allows you to gracefully handle exceptions in SQL Server. To use the TRY CATCH construct, 
you first place a group of Transact-SQL statements that could cause an exception in a BEGIN TRY...END TRY block,
Then you use a BEGIN CATCH...END CATCH block immediately after the TRY block: as follows:
syntax:
	BEGIN TRY  
	   -- statements that may cause exceptions
	END TRY 
	BEGIN CATCH  
	   -- statements that handle exception
	END CATCH  

The CATCH block functions : 
Inside the CATCH block, you can use the following functions to get the detailed information on the error that occurred:

ERROR_LINE() returns the line number on which the exception occurred.
ERROR_MESSAGE() returns the complete text of the generated error message.
ERROR_PROCEDURE() returns the name of the stored procedure or trigger where the error occurred.
ERROR_NUMBER() returns the number of the error that occurred.
ERROR_SEVERITY() returns the severity level of the error that occurred.
ERROR_STATE() returns the state number of the error that occurred.

Note that you only use these functions in the CATCH block. If you use them outside of the CATCH block, 
	all of these functions will return NULL.

Nested TRY CATCH constructs : 
You can nest TRY CATCH construct inside another TRY CATCH construct. However, either a TRY block or a CATCH block 
	can contain a nested TRY CATCH, for example:

	BEGIN TRY
		--- statements that may cause exceptions
	END TRY
	BEGIN CATCH
		-- statements to handle exception
		BEGIN TRY
			--- nested TRY block
		END TRY
		BEGIN CATCH
			--- nested CATCH block
		END CATCH
	END CATCH

*/

create proc uspTC_divide(
	@a decimal,
	@b decimal,
	@c decimal Output
	)
as
begin
	BEGIN TRY
		set @c = @a / @b;
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_MESSAGE() AS ErrorMessage,
			ERROR_LINE() AS ErrorLine
	END CATCH
end;
GO

declare @Result decimal;
exec uspTC_divide 10, 2, @Result Output;
select @Result as Result;

declare @Result decimal;
exec uspTC_divide 10, 0, @Result Output;
select @Result as Result;

/*
SQL Serer TRY CATCH with transactions
Inside a CATCH block, you can test the state of transactions by using the XACT_STATE() function.

If the XACT_STATE() function returns -1, it means that an uncommittable transaction is pending, 
	you should issue a ROLLBACK TRANSACTION statement.
In case the XACT_STATE() function returns 1, it means that a committable transaction is pending. 
	You can issue a COMMIT TRANSACTION statement in this case.
If the XACT_STATE() function return 0, it means no transaction is pending, therefore, 
	you don’t need to take any action.
It is a good practice to test your transaction state before issuing a COMMIT TRANSACTION or ROLLBACK TRANSACTION 
	statement in a CATCH block to ensure consistency.
*/

' Using TRY CATCH with transactions example '
create schema sales;

CREATE TABLE sales.persons
(
    person_id  INT
    PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL
);

CREATE TABLE sales.deals
(
    deal_id   INT
    PRIMARY KEY IDENTITY, 
    person_id INT NOT NULL, 
    deal_note NVARCHAR(100), 
    FOREIGN KEY(person_id) REFERENCES sales.persons(
    person_id)
);

insert into sales.persons(first_name, last_name)
values ('John','Doe'), ('Jane','Doe');

select * from sales.persons

insert into sales.deals(person_id, deal_note)
values (1,'Deal for John Doe');

-- Next, create a new stored procedure named usp_report_error that will be used in a CATCH block to 
	-- report the detailed information of an error:

CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

-- Then, develop a new stored procedure that deletes a row from the sales.persons table:

CREATE PROC usp_delete_person(
	@person_id INT
	)
as
begin
	BEGIN TRY
		BEGIN TRANSACTION
			-- delete the person
			delete from sales.persons
			where person_id = @person_id;
			-- if person delete succeed, commit the transaction
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		-- report exception
		EXEC usp_report_error;

		-- Test if the transaction is uncommittable.  
		if (XACT_STATE()) = -1
		BEGIN
			PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.' 
			ROLLBACK TRANSACTION;
		END

		-- Test if the transaction is committable.  
		if (XACT_STATE()) = 1
		BEGIN
			PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
			COMMIT TRANSACTION;
		END	

	END CATCH
end;
GO

EXEC usp_delete_person 2;

' ----- 2. RAISERROR ----- '

/*
The RAISERROR statement allows you to generate your own error messages and return these messages back to the 
	application using the same format as a system error or warning message generated by SQL Server Database Engine. 
	In addition, the RAISERROR statement allows you to set a specific message id, level of severity, and state 
	for the error messages.

If you develop a new application, you should use the THROW statement instead.

syntax :
		RAISERROR ( { message_id | message_text | @local_variable }  
			{ ,severity ,state }  
			[ ,argument [ ,...n ] ] )  
			[ WITH option [ ,...n ] ];

*/
/*
message_id : 
The message_id is a user-defined error message number stored in the sys.messages catalog view.

To add a new user-defined error message number, you use the stored procedure sp_addmessage. A user-defined error 
	message number should be greater than 50,000. By default, the RAISERROR statement uses the message_id 50,000 
	for raising an error.

The following statement adds a custom error message to the sys.messages view:
*/

exec sp_addmessage
	@msgnum = 500005,
	@severity = 1,
	@msgtext = 'A custom eroror message'

select * from sys.messages where message_id = 500005

-- To use this message_id, you execute the RAISEERROR statement as follows:
RAISERROR ( 500005,1,1)

EXEC sp_dropmessage 
    @msgnum = 500005; 

'--- message_text -' 
-- When you specify the message_text, the RAISERROR statement uses message_id 50000 to raise the error message.
RAISERROR('Whoops, an error occurred.',1,1)

' severity '
/* The severity level is an integer between 0 and 25, with each level representing the seriousness of the error.

0–10 Informational messages
11–18 Errors
19–25 Fatal errorss
*/

' state '
/*
The state is an integer from 0 through 255. If you raise the same user-defined error at multiple locations, you can use a unique 
	state number for each location to make it easier to find which section of the code is causing the errors. 
	For most implementations, you can use 1.

WITH option : 
The option can be LOG, NOWAIT, or SETERROR:

WITH LOG logs the error in the error log and application log for the instance of the SQL Server Database Engine.
WITH NOWAIT sends the error message to the client immediately.
WITH SETERROR sets the ERROR_NUMBER and @@ERROR values to message_id or 50000, regardless of the severity level.
*/

' SQL Server RAISERROR examples '
-- A) Using SQL Server RAISERROR with TRY CATCH block example

declare @ErrorMessage nvarchar(150),
		@ErrorSeverity int,
		@ErrorState int;

BEGIN TRY
	RAISERROR('Error occured in try block', 17, 1);
END TRY
BEGIN CATCH
	SELECT @ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

	-- return the error inside the CATCH block
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

-- B) Using SQL Server RAISERROR statement with a dynamic message text example

DECLARE @MessageText NVARCHAR(100);
SET @MessageText = N'Cannot delete the sales order %s';

RAISERROR(
    @MessageText, -- Message text
    16, -- severity
    1, -- state
    N'2001' -- first argument to the message text
);

/*
When to use RAISERROR statement: 
You use the RAISERROR statement in the following scenarios:

Troubleshoot Transact-SQL code.
Return messages that contain variable text.
Examine the values of data.
Cause the execution to jump from a TRY block to the associated CATCH block.
Return error information from the CATCH block to the callers, either calling batch or application.
*/


' ----- 3. THROW ----- '
/*
The THROW statement raises an exception and transfers execution to a CATCH block of a TRY CATCH construct.
suntax: 
		THROW [ error_number ,  
				message ,  
				state ];

error_number: 
The error_number is an integer that represents the exception. The error_number must be greater than 50,000 and less than or equal to 2,147,483,647.

message:
The message is a string of type NVARCHAR(2048) that describes the exception.

state:
The state is a TINYINT with the value between 0 and 255. The state indicates the state associated with the message.

If you don’t specify any parameter for the THROW statement, you must place the THROW statement inside a CATCH block:

		BEGIN TRY
			-- statements that may cause errors
		END TRY
		BEGIN CATCH
			-- statement to handle errors 
			THROW;   
		END CATCH

In this case, the THROW statement raises the error that was caught by the CATCH block.

Note that the statement before the THROW statement must be terminated by a semicolon (;)

*/
/* THROW vs. RAISERROR :
The following table illustrates the difference between the THROW statement and RAISERROR statement:

RAISERROR																		THROW
The message_id that you pass to RAISERROR must be defined in sys.messages view.	The error_number parameter does not have to be defined in the sys.messages view.
The message parameter can contain printf formatting styles such as %s and %d.	The message parameter does not accept printf style formatting. Use FORMATMESSAGE() function to substitute parameters.
The severity parameter indicates the severity of the exception.					The severity of the exception is always set to 16.
*/

'SQL Server THROW statement examples '
--  A) Using THROW statement to raise an exception

THROW 50005, N'An Error occured', 1

-- B) Using THROW statement to rethrow an exception
CREATE TABLE t1(
    id int primary key
);
GO

BEGIN TRY
	insert into t1(id) values(1);
	-- cause error
	insert into t1(id) values(1);
END TRY
BEGIN CATCH
	PRINT ('Raise the caught error again');
	THROW;
END CATCH

/*
Unlike the RAISERROR statement, the THROW statement does not allow you to substitute parameters in the message text. 
	Therefore, to mimic this function, you use the FORMATMESSAGE() function.
*/

-- The following statement adds a custom message to the sys.messages catalog view:
exec sys.sp_addmessage
	@msgnum = 50010,
	@severity = 16,
	@msgtext = N'The order number %s cannot be deleted b/z it doesnot exist.',
	@lang = 'us_english';
GO

exec sys.sp_dropmessage @msgnum = 50010, @lang = 'us_english';

declare @MessageText nvarchar(2048);
set @MessageText = FORMATMESSAGE(50010, N'1001');

THROW 50010, @MessageText, 1;	

------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
drop table Employees

create table Employees (
	EmployeeId int primary key, 
	EmployeeName nvarchar(30) not null, 
	Email nvarchar(30), 
	Salary numeric(18, 0), 
	Gender nvarchar(10), 
	constraint chk_gender Check(Gender in ('Male', 'Female', 'Others')),
	Role nvarchar(20),
	constraint chk_role Check (Role in ('Backend Developer', 'Frontend Developer', 'FullStack Developer', 'Manager', 'H.R', 'CEO')));

Select * from Employees;



truncate table Employees

---------------------------
alter table Employees
add constraint chk_gender Check(Gender in ('Male', 'Female', 'Others')),
constraint chk_role Check (Role in ('Backend Developer', 'Frontend Developer', 'FullStack Developer', 'Manager', 'H.R', 'CEO'));

------- Insert
alter procedure usp_InsertEmployee(
@EmployeeId int,
@EmployeeName nvarchar(30),
@Email nvarchar(30),
@Salary numeric(18, 0),
@Gender nvarchar(10),
@Role nvarchar(20)
)
as
begin
	begin try
			insert into Employees(EmployeeId, EmployeeName, Email, Salary, Gender, Role)
			values (@EmployeeId, @EmployeeName, @Email, @Salary, @Gender, @Role)
	end try
	begin catch
			PRINT  'Error in Insert Employee';
			--print ERROR_Message();
			Throw;
	end catch
end;

exec usp_InsertEmployee 3,  'Allen', 'allen123@gmail.com', 20500, 'Female', 'Employee'
exec usp_InsertEmployee 1,  'Allen', 'allen123@gmail.com', 20500, 'Female', 'Frontend Developer'
exec usp_InsertEmployee 2,  'Scott', 'scott123@gmail.com', 34000, 'Male', 'Backend Developer'

Select * from Employees;
drop procedure Employees

-- --------- Fetch
alter proc usp_FetchEmployees(
@EmployeeId int = null,
@EmployeeName nvarchar(30) = null,
@Email nvarchar(30) = null,
@Salary numeric(18, 0) = null,
@Gender nvarchar(10) = null,
@Role nvarchar(20) = null
)
as
begin
	begin try
		select * from Employees
		where ((@EmployeeId is null or EmployeeId =  @EmployeeId) and (@EmployeeName is null or EmployeeName = @EmployeeName) and 
		(@Email is null or Email = @Email) and (@Salary is null or Salary = @Salary) and (@Gender is null or Gender = @Gender) and 
		(@Role is null or Role = @Role))
	end try
	begin catch
		THROW;
	end catch
end;

exec  usp_FetchEmployees @EmployeeName = 'Allen'
exec  usp_FetchEmployees 1
exec  usp_FetchEmployees @Salary = 34000
exec  usp_FetchEmployees @Salary = 34000, @EmployeeId = 2

select * from Employees

--------- Update
alter procedure usp_UpdateEmployee(
@EmployeeId int,
@EmployeeName nvarchar(30),
@Email nvarchar(30),
@Salary numeric(18, 0),
@Gender nvarchar(10),
@Role nvarchar(20)
)
as
begin
	begin try
		update Employees set EmployeeName = @EmployeeName, Email = @Email, Salary = @Salary, Gender =  @Gender, Role = @Role
		where EmployeeId = @EmployeeId
		if (@@ROWCOUNT = 0)
		begin
			declare @ErrorMessage nvarchar(100);
			set @ErrorMessage = FORMATMESSAGE(N'No rows were updated b/z Employee not fouund for id: %d', @EmployeeId);
			Throw 50001, @ErrorMessage, 1;
		end
	end try
	begin catch
		Print 'Error in Upadate Employee';
		Throw;
	end catch
end;

drop proc usp_UpdateEmployee;

exec usp_UpdateEmployee 3, 'Allen', 'allen123@gmail.com', 42600, 'Male', 'dfbs'
exec usp_UpdateEmployee 1, 'Allen', 'allen123@gmail.com', 42600, 'Male', 'manager'

update Employees set Role = 'sjh' where EmployeeId = 1;

select * from Employees;

-------- Delete
alter procedure usp_DeleteEmployee(
@EmployeeId int
)
as
begin
	begin try
		delete from Employees
		where EmployeeId = @EmployeeId

		--if (XACT_STATE() = 0) 
		IF (@@ROWCOUNT = 0)
		begin
				declare @ErrorMessage nvarchar(100);
				set @ErrorMessage = FORMATMESSAGE(N'No rows were deleted b/z Employee not found for id: %d',@EmployeeId);
				--print FORMATMESSAGE(N'No rows were deleted b/z Employee not found for id: %d',@EmployeeId);
				Throw 50001, @ErrorMessage, 1;
			end
	end try
	begin catch
		Print 'Error in Delete  Employee';
		Throw;
	end catch
end;

exec usp_DeleteEmployee 3
exec usp_DeleteEmployee 1

select * from Employees;







