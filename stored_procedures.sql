
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


---



