
' Functions -> Inbuilt & Userdefined function'

create database Fuctions_Database

use Fuctions_Database

'  ============================================== '

' ------- 1. Aggregate Functions --------- '
/*
An aggregate function operates on a set of values and returns a single value. 
In practice, you often use aggregate functions with the GROUP BY clause and HAVING clause to aggregate values within groups.

The following table shows the most commonly used SQL Server aggregate functions:
Aggregate function	& Description: 
AVG:	Calculate the average of non-NULL values in a set of values.
CHECKSUM_AGG:	Calculate a checksum value based on a group of rows.
COUNT:	Return the number of rows in a group that satisfy a condition.
COUNT(*):	Return the number of rows from a table, which meets a certain condition.
COUNT(DISTINCT):	Return the number of unique values in a column that meets a certain condition.
COUNT IF:	Show you how to use the COUNT function with the IIF function to form a COUNT IF function that returns the total number of values based on a condition.
COUNT_BIG:	The COUNT_BIG() function returns the number of rows (with BIGINT data type) in a group, including rows with NULL values.
MAX:	Return the highest value (maximum) in a set of non-NULL values.
MIN:	Return the lowest value (minimum) in a set of non-NULL values.
STDEV:	Calculate the sample standard deviation of a set of values.
STDEVP:	Return the population standard deviation of a set of values.
SUM:	Return the summation of all non-NULL values in a set.
SUM IF:	Use the SUM function with the IIF function to form a SUM IF function that returns the total of values based on a condition.
STRING_AGG: 	Concatenate strings by a specified separator
VAR:	Return the sample variance of a set of values.
VARP:	Return the population variance of a set of values.


*/

' Here’s is the general syntax of an aggregate function: aggregate_function_name( [DISTINCT | ALL] expression) '
/* 
In this syntax:
First, specify the name of an aggregate function that you want to use such as AVG, SUM, and MAX.
Second, use DISTINCT to apply aggregate distinct values in a set; or
	use the ALL option to apply the aggregate function to all values including duplicates.
Third, specify the expression which can be a column of a table or an expression that consists of multiple columns 
	with arithmetic operators.
*/

select * 
into department
from DQL_Database.dbo.DEPARTMENT

select * 
into employees
from DQL_Database.dbo.EMPLOYEES

' ------ AVG() ' 
select AVG(SAL) avg_sal from employees  -- o/p: 2073.214285

select CAST(ROUND(AVG(SAL), 2) as dec(10,2)) as avg_sal from employees   -- o/p: 2073.21

select ROUND(AVG(SAL), 2) as avg_sal from employees  -- o/p: 2073.210000

select JOB, CAST(ROUND(AVG(SAL), 2) as decimal(10,2)) as avg_sal_by_job 
from employees
group by JOB

select e.DEPT_NO, CAST(ROUND(AVG(SAL), 2) as decimal(10,2)) as avg_sal
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
group by e.DEPT_NO
order by DEPT_NO desc

select JOB, CAST(ROUND(AVG(SAL), 2) as decimal(10,2)) as avg_sal
from employees
group by JOB
having AVG(SAL) > 2500
order by JOB
' execution order: group by => avg() => having ' 

' ------ COUNT ' -- syntax: COUNT([ALL | DISTINCT  ] expression)s
/*
Use the COUNT(*) to retrieve the number of rows in a table.
Use the COUNT(ALL expression) to count the number of non-null values.
Use the COUNT(DISTINCT expression) to obtain the number of unique, non-null values.
*/

select COUNT(*) from employees

select COUNT(*) from employees
WHERE SAL > 2000

select * from employees

select COUNT(COMMISSION) from employees

select COUNT(distinct COMMISSION) from employees

select COUNT(distinct SAL) from employees

select JOB, COUNT(*) job_count
from employees e
inner join department d 
on e.DEPT_NO = d.DEPT_NO
group by JOB
order by job_count

select JOB, COUNT(*) job_count
from employees e
inner join department d 
on e.DEPT_NO = d.DEPT_NO
group by JOB
having COUNT(*) > 2
order by job_count

' ------ MAX  '
select MAX(SAL) from employees

select * from employees
where SAL = (select MAX(SAL) from employees)

select job, MAX(sal) max_sal
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
group by job
order by max_sal

select job, MAX(sal) max_sal
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
group by job
having MAX(SAL) < 2500
order by max_sal

select MAX(HIREDATE) from employees

select Min(HIREDATE) from employees

' ----- SUM() '
select SUM(sal) from employees

select job, SUM(sal) from employees
group by JOB
order by JOB



' ------- 2. Window Functions --------- '
/*
SQL Server Window Functions calculate an aggregate value based on a group of rows and return multiple rows for each group.
Type a function name to search...

Name	Description
CUME_DIST :	Calculate the cumulative distribution of a value (within a group of) in a set of values
DENSE_RANK :	Assign a rank value to each row within a partition of a result, with no gaps in rank values.
FIRST_VALUE :	Get the value of the first row in an ordered partition of a result set.
LAG :	Provide access to a row at a given physical offset that comes before the current row.
LAST_VALUE :	Get the value of the last row in an ordered partition of a result set.
LEAD :	Provide access to a row at a given physical offset that follows the current row.
NTILE :	Distribute rows of an ordered partition into a number of groups or buckets
PERCENT_RANK :	Calculate the percent rank of a value in a set of values.
RANK :	Assign a rank value to each row within a partition of a result set
ROW_NUMBER :	Assign a unique sequential integer to rows within a partition of a result set, the first row starts from 1.

*/

'---- CUME_DIST() '
/*
The CUME_DIST() function calculates the cumulative distribution of a value within a group of values. 
Simply put, it calculates the relative position of a value in a group of values.

The following shows the syntax of the CUME_DIST() function:
 CUME_DIST() OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
 )

Return value: 0 < CUME_DIST() <= 1

*/

select CONCAT_WS(' ',EMP_ID, ' ', EMP_NAME) full_name,HIREDATE, SAL, CUME_DIST() over (order by sal desc) cume_dist
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO

select CONCAT_WS(' ',EMP_ID, ' ', EMP_NAME) full_name, HIREDATE, SAL, CUME_DIST() over (order by sal desc) cume_dist
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
where HIREDATE >= '1981-01-01' and HIREDATE <= '1985-12-31'
order by SAL 

select CONCAT_WS(' ',EMP_ID, ' ', EMP_NAME) full_name, HIREDATE, SAL, 
	CUME_DIST()over ( partition by hiredate order by sal desc) cume_dist
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
where HIREDATE >= '1981-01-01' and HIREDATE <= '1985-12-31'

select CONCAT_WS(' ',EMP_ID, ' ', EMP_NAME) full_name, YEAR(HIREDATE), SAL, 
	CUME_DIST()over ( partition by YEAR(HIREDATE) order by sal desc) cume_dist
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
where HIREDATE >= '1981-01-01' and HIREDATE <= '1985-12-31'

select CONCAT_WS(' ',EMP_ID, ' ', EMP_NAME) full_name, YEAR(HIREDATE), SAL, 
	CUME_DIST()over ( partition by YEAR(HIREDATE) order by sal desc) cume_dist
from employees e
inner join department d
on e.DEPT_NO = d.DEPT_NO
where HIREDATE >= '1981-01-01' and HIREDATE <= '1987-12-31'

' error '
with cte_employees as (
	select CONCAT_WS(EMP_ID, ' ', EMP_NAME) ful_name, YEAR(HIREDATE),
	SAL, CUME_DIST() over(partition by YEAR(HIREDATE) order by sal desc) as cume_dist from employees
	)
select * from cte_employees
where cume_dist < 0.3

' --- DENSE_RANK '
/*
syntax: DENSE_RANK() OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
)
*/

select EMP_NAME, SAL,
	dense_rank() over (order by sal) my_dense_rank,
	rank() over (order by sal) my_rank
from employees

select EMP_NAME, SAL,
	dense_rank() over (order by sal desc) my_dense_rank,
	rank() over (order by sal desc) my_rank
from employees

select * 
from (select EMP_NAME, SAL, 
	 DENSE_RANK() over (order by sal desc) my_dense_rank,
	 RANK() over (order by sal desc) my_rank from employees) as numbered_employees
where my_dense_rank in (2, 3)

select * 
from (select EMP_NAME, job, SAL, 
	 DENSE_RANK() over (partition by job order by sal desc) my_dense_rank from employees) as numbered_employees
where my_dense_rank in (2, 3)


' ------- FIRST_VALUE() '
/*
syntax: FIRST_VALUE ( scalar_expression )  
OVER ( 
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
)
    
The scalar_expression can be a column, subquery, or expression that evaluates to a single value. 
It cannot be a window function.

*/

select JOB, YEAR(HIREDATE), DEPT_NO,
	first_value(job) over (partition by year(hiredate) order by dept_no) lowest_emp_value
from employees
where YEAR(HIREDATE) between 1981 and 1987

' smly ---- LAST_Value() '

' ----- PERCENT_RANK '
/*
The PERCENT_RANK() function is similar to the CUME_DIST() function. The PERCENT_RANK() function evaluates the 
	relative standing of a value within a partition of a result set.
*/

select CONCAT_WS(EMP_ID, ' ', EMP_NAME) full_name, YEAR(HIREDATE) year_hiredate, SAL,
	PERCENT_RANK() over (order by sal desc) percent_rank
from employees e
inner join department d on e.DEPT_NO = d.DEPT_NO
where YEAR(HIREDATE) in (1981)

select CONCAT_WS(' ',EMP_ID, EMP_NAME) full_name, YEAR(HIREDATE) year_hiredate, SAL,
	FORMAT(
		PERCENT_RANK() over (partition by year(HIREDATE) order by sal desc), 'p'
	) percent_rank
from employees e
inner join department d on e.DEPT_NO = d.DEPT_NO -- optional
where YEAR(HIREDATE) in (1981, 1987)
/* In this example:

The PARTITION BYclause distributed the rows by year into two partitions, one for 1981 and the other for 1987.
The ORDER BY clause sorted rows in each partition by net sal from high to low.
The PERCENT_RANK() function is applied to each partition separately and recomputed the rank when crossing the 
	partition’s boundary.
*/

' ---- RANK() '
' ---- ROW_NUMBER() '
select *, ROW_NUMBER()  over (order by (select null)) slno from employees

select *, ROW_NUMBER()  over (order by sal) slno from employees


' ------- 3. Date Functions --------- '
/*
1).Returning the current date and time
Function :	Description
CURRENT_TIMESTAMP :	Returns the current system date and time without the time zone part.
GETUTCDATE :	Returns a date part of a date as an integer number.
GETDATE :	Returns the current system date and time of the operating system on which the SQL Server is running.
SYSDATETIME :	Returns the current system date and time with more fractional seconds precision than the GETDATE() function.
SYSUTCDATETIME :	Returns the current system date and time in UTC time
SYSDATETIMEOFFSET :	Returns the current system date and time with the time zone.

2).Returning the date and time Parts
Function :	Description
DATENAME :	Returns a date part of a date as a character string
DATEPART :	Returns a date part of a date as an integer number
DAY :	Returns the day of a specified date as an integer
MONTH :	Returns the month of a specified date as an integer
YEAR :	Returns the year of the date as an integer.

3).Returning a difference between two dates
Function :	Return value
DATEDIFF :	Returns a difference in date part between two dates.

4).Modifying dates
Function :	Description
DATEADD :	Adds a value to a date part of a date and return the new date value.
EOMONTH :	Returns the last day of the month containing the specified date, with an optional offset.
SWITCHOFFSET :	Changes the time zone offset of a DATETIMEOFFSET value and preserves the UTC value.
TODATETIMEOFFSET :	Transforms a DATETIME2 value into a DATETIMEOFFSET value.

5).Constructing date and time from their parts
Function :	Description
DATEFROMPARTS :	Return a DATE value from the year, month, and day.
DATETIME2FROMPARTS :	Returns a DATETIME2 value from the date and time arguments
DATETIMEOFFSETFROMPARTS :	Returns a DATETIMEOFFSET value from the date and time arguments
TIMEFROMPARTS :	Returns a TIME value from the time parts with the precisions

6).Validating date and time values
Function :	Description
ISDATE :	Check if a value is a valid date, time, or datetime value

*/


' ------- 4. String Functions --------- '
/*
The following SQL Server string functions process on an input string and return a string or numeric value:

Function :	Description
ASCII :	Return the ASCII code value of a character
CHAR :	Convert an ASCII value to a character
CHARINDEX :	Search for a substring inside a string starting from a specified location and return the position of the substring.
CONCAT :	Join two or more strings into one string
CONCAT_WS :	Concatenate multiple strings with a separator into a single string
DIFFERENCE :	Compare the SOUNDEX() values of two strings
FORMAT :	Return a value formatted with the specified format and optional culture
LEFT :	Extract a given a number of characters from a character string starting from the left
LEN :	Return a number of characters of a character string
LOWER :	Convert a string to lowercase
LTRIM :	Return a new string from a specified string after removing all leading blanks
NCHAR :	Return the Unicode character with the specified integer code, as defined by the Unicode standard
PATINEX :	Returns the starting position of the first occurrence of a pattern in a string.
QUOTENAME :	Returns a Unicode string with the delimiters added to make the input string a valid delimited identifier
REPLACE :	Replace all occurrences of a substring, within a string, with another substring
REPLICATE :	Return a string repeated a specified number of times
REVERSE :	Return the reverse order of a character string
RIGHT :	Extract a given a number of characters from a character string starting from the right
RTRIM :	Return a new string from a specified string after removing all trailing blanks
SOUNDEX :	Return a four-character (SOUNDEX) code of a string based on how it is spoken
SPACE :	Returns a string of repeated spaces.
STR :	Returns character data converted from numeric data.
STRING_AGG :	Concatenate rows of strings with a specified separator into a new string
STRING_ESCAPE :	Escapes special characters in a string and returns a new string with escaped characters
STRING_SPLIT :	A table-valued function that splits a string into rows of substrings based on a specified separator.
STUFF :	Delete a part of a string and then insert another substring into the string starting at a specified position.
SUBSTRING :	Extract a substring within a string starting from a specified location with a specified length
TRANSLATE :	Replace several single-characters, one-to-one translation in one operation.
TRIM :	Return a new string from a specified string after removing all leading and trailing blanks
UNICODE :	Returns the integer value, as defined by the Unicode standard, of a character.
UPPER :	Convert a string to uppercase

*/

' 
SQL Server DIFFERENCE() Function :
The DIFFERENCE() function compares two strings and determines their phonetic similarity.

Here’s the syntax of the DIFFERENCE() function:
DIFFERENCE (string1, string2)

The DIFFERENCE() function returns an integer value ranging from 0 to 4:

4: indicates that the two strings are very similar phonetically.
3 indicates that the two strings are similar.
2 indicates that the two strings are somewhat similar.
1 indicates that the two strings are not very similar.
0 indicates that the two strings are completely dissimilar.

The DIFFERENCE() function is useful when you want to perform fuzzy string matching or search based on sound similarity rather than exact matches.

The DIFFERENCE() function returns NULL if either of the input strings is NULL.
'

SELECT DIFFERENCE('hello', 'hallo') AS SimilarityScore;

select EMP_NAME from  employees
where DIFFERENCE(EMP_NAME,'SMI') = 4

SELECT DIFFERENCE(ISNULL('Hi', ''), ISNULL(NULL, '')) AS SimilarityScore;

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

select *, DATEPART(QUARTER,sold_date), DATEPART(QUARTER,GETDATE()), DATEPART(YEAR, sold_date), DATEPART(YEAR, GETDATE()) from sales;
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

'
SQL Server System Functions
This page provides you with the commonly used system functions in SQL Server that return objects, values, and settings in SQL Server:

CAST – Cast a value of one type to another.
CONVERT – Convert a value of one type to another.
CHOOSE – Return one of the two values based on the result of the first argument.
ISNULL – Replace NULL with a specified value.
ISNUMERIC – Check if an expression is a valid numeric type.
IIF – Add if-else logic to a query.
TRY_CAST – Cast a value of one type to another and return NULL if the cast fails.
TRY_CONVERT – Convert a value of one type to another and return the value to be translated into the specified type. It returns NULL if the cast fails.
TRY_PARSE – Convert a string to a date/time or a number and return NULL if the conversion fails.
Convert datetime to string – Show you how to convert a datetime value to a string in a specified format.
Convert string to datetime – Describe how to convert a string to a datetime value.
Convert datetime to date – Convert a datetime to a date.
GENERATE_SERIES() – Generate a series of numbers within a specific range.
'


'
SQL Server JSON Functions
This page provides you with a comprehensive guide to the most commonly used SQL Server JSON functions, providing insights into validating JSON text, creating JSON data, querying JSON objects, and modifying JSON data.

Section 1. JSON Path Expressions
This section focuses on navigation JSON structures using JSON paths and shows you how to check if a JSON path exists in a JSON string.

JSON Path Expressions in SQL Server – Show how to use JSON path expression to locate elements within a JSON document.
JSON_PATH_EXISTS() – Determine if a specified JSON path exists in a JSON document.
Section 2. Validating JSON
This section demonstrates the function of validating JSON documents to ensure their integrity and correctness.

ISJSON() – Determine if a JSON string is valid, which can be useful in data validation processes.
Section 3. Constructing JSON objects and arrays
This section introduces JSON functions for constructing JSON structures, including objects and arrays.

JSON_OBJECT() – construct JSON object text from zero or more key/value pairs.
JSON_ARRAY() – construct JSON array text from zero or more values.
Section 4. Querying JSON elements
This section explores techniques for extracting data from JSON strings, enabling efficient retrieval of scalar values, arrays, and objects.

JSON_VALUE() – Extract a scalar value from a JSON string.
JSON_QUERY() – Extract a JSON object or array from a JSON document.
OPENJSON() – Convert a JSON document to rows and columns.
Section 5. Modifying JSON
This section covers the function that allows you to delete, update, and insert a property into a JSON string.

JSON_MODIFY() – Modify the value in a JSON string and return the updated JSON data.
FOR JSON – Show you how to convert JSON documents to relational views.

'


'
SQL Server Math Functions
This SQL Server math functions page offers a comprehensive collection of mathematical functions. These math functions empower your SQL queries with advanced computational capabilities.

If you’re manipulating numerical data, performing complex calculations, or analyzing trends, SQL Server offers an array of functions to meet your mathematical needs.

Function	Description
ABS	Return the absolute value of a number.
ACOS	Return an angle (in radians) of a specified cosine.
ASIN	Return an angle (in radians) of a specified sine.
ATAN	Return the arctangent (in radians) of a specified tangent.
CEILING	Round a number to the nearest integer greater than or equal to the input number.
COS	Return the cosine of the specified angle, measured in radians.
COT	Return the cotangent of the specified angle, which is the reciprocal of the tangent.
DEGREES	Convert an angle value in radians to degrees.
EXP	Return the exponential value of a number.
FLOOR	Round a number to the nearest integer less than or equal to the input value.
LOG	Return the natural logarithm of a float with a specific base (default to e).
PI	Return the constant value of PI, accurate to 15 digits.
POWER	Return the result of raising a number to a specific power.
RAND	Return a random float between 0 and 1.
RADIANS	Convert an angle value in degrees to radians.
ROUND	Return a number rounded to a specified precision.
SIGN	Return the sign of a number, 1 for positive, -1 for negative, and 0 for zero.
SIN	Return the sine of an angle in radians.
SQRT	Return the square root of a float.
SQUARE	Return the square of a number.
TAN	Return the tangent of the specified angle, measured in radians.
'


' ============= USER DEFINED FUNCTIONS ================= '

select CURRENT_USER;

select APP_NAME();

select GETDATE();

DECLARE @FName varchar(50);
select coalesce(@FName, 'Tom');

DECLARE @FName varchar(50);
SET @FName = 'Jerry';
select coalesce(@FName, 'Tom');

' ------- SCALAR FUNCTION '
/* syntax: 
	CREATE FUNCTION function_name(Parameters OPTIONAL)
	RETURNS return_type
	AS
	BEGIN
	Statement 1
	Statement 2
	Statement n
	RETURN return-value
	END
*/

create function AddDigits(@num1 int, @num2 int)
returns int
as
begin
declare @result int;
set @result = @num1 + @num2;
return @result;
end

select dbo.AddDigits(2,5)

create table Students (
	RollNo int primary key identity,
	StudentName varchar(50) not null, 
	);

drop table Students

create table Students_Marks (
	RollNo int,
	constraint frk_rollno foreign key(RollNo) references Students(RollNo),
	Science int not null, 
	Math int not null, 
	English int not null
	);

drop table Students_Marks

insert into Students(StudentName) 
values ('Tom'),('Smith'),('Allen'),('Scott'),('Jerry'),('Smith'),('Tom'),('Miller'),('Clark')

select * from Students

insert into Students_Marks(RollNo,Science,Math,English) 
values (1,34,78,54),(2,78,43,87),(3,45,32,78),(4,36,78,32),(5,12,22,67),(6,21,65,43),(7,34,78,65),(8,45,35,76),(9,80,57,65)

select * from Students_Marks

create function GetTotalMarks(@RollNo int)
returns int 
as 
begin
declare @result int;
select @result = (Science+Math+English) from Students_Marks where RollNo = @RollNo;
return @result;
end

drop function GetTotalMarks

select *, dbo.GetTotalMarks(RollNo) Total_Marks from Students_Marks;


create function GetMarksAverage(@RollNo int)
returns int
as 
begin
declare @result int;
select @result = (Science+Math+English)/3 from Students_Marks where RollNo = @RollNo;
return @result;
end

drop function dbo.GetMarksAverage

select *, dbo.GetTotalMarks(RollNo) Total_Marks, dbo.GetMarksAverage(RollNo) Marks_Average from Students_Marks;


' ------- TABLE VALUED FUNCTION '

' 1. INLINE TABLE VALUED FUNCTION '

create function Inline_GetStudents_GreaterThanScore(@TotalMarks int)
returns Table
as
return select *, (Science+Math+English) Total_Marks from Students_Marks where (Science+Math+English) >= @TotalMarks;

drop function Inline_GetStudents_GreaterThanScore;

select * from dbo.Inline_GetStudents_GreaterThanScore(150);


' 1. MULTI-STATEMENT TABLE VALUED FUNCTION '

create function MultiStatement_GetStudents(@RollNo int)
returns @Marks_Sheet Table (stName varchar(50), RollNo int, sci int, math int, eng int, 
	total_marks int,avg_marks decimal(4,2))
as
begin
declare @stName varchar(50);
declare @total_marks int;
declare @avg_marks decimal(4,2);

select @stName = StudentName from Students where RollNo = @RollNo;
select @total_marks = (Science+Math+English) from Students_Marks where RollNo = @RollNo;
select @avg_marks = (Science+Math+English)/3 from Students_Marks where RollNo = @RollNo;

insert into @Marks_Sheet(stName,RollNo,sci, math, eng, total_marks,avg_marks) 
select @stName, @RollNo, Science, Math, English, @total_marks, @avg_marks 
	from Students_Marks where RollNo = @RollNo;

return
end

drop function MultiStatement_GetStudents;

select * from dbo.MultiStatement_GetStudents(2);

--------------------------------

select * from employees

create function GetAvgSalary(@deptno int)
returns int
as
begin
	declare @Result int;
	select @Result = AVG(sal) from employees where DEPT_NO = @deptno;
	return @Result;
end;

select dbo.GetAvgSalary(10);
select dbo.GetAvgSalary(20);
select dbo.GetAvgSalary(30);

alter function GetSalarySum(@deptno  int)
returns int
as
begin
	declare  @Result int;
	select @Result = SUM(sal) from employees where DEPT_NO = @deptno;
	return @REsult;
end

select dbo.GetSalarySum(10);
select dbo.GetSalarySum(20);
select dbo.GetSalarySum(30);

select SUM(sal)  from employees where DEPT_NO = 10;
select SUM(sal)  from employees where DEPT_NO = 20;
select SUM(sal)  from employees where DEPT_NO = 30;

select DEPT_NO, dbo.GetSalarySum(DEPT_NO) as sum_salary, dbo.GetAvgSalary(DEPT_NO) as avg_salary from employees
group by DEPT_NO;












