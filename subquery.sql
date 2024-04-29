
' SUBQUERY Operations '

' A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE, or DELETE. '
'  '
/* 
A subquery can be nested within another subquery. SQL Server supports up to 32 levels of nesting.

You can use a subquery in many places:
In place of an expression
With IN or NOT IN
With ANY or ALL
With EXISTS or NOT EXISTS
In UPDATE, DELETE, orINSERT statement
In the FROM clause

*/

create database SUBQUERY_Database
use SUBQUERY_Database

select * 
into employees
from DQL_Database.dbo.Employees

select * 
into department
from DQL_Database.dbo.DEPARTMENT

select * from department
select * from employees

' The following statement shows how to use a subquery in the WHERE clause of a SELECT statement '
select EMP_NAME, DEPT_NO, HIREDATE
from employees
where DEPT_NO in (select DEPT_NO from department
where DEPT_LOC = 'NEW YORK')
order by HIREDATE desc

select EMP_NAME, SAL
from employees
where SAL > (select AVG(SAL) from employees
	where DEPT_NO in (select DEPT_NO from department
		where DEPT_NAME ='RESEARCH' or DEPT_NAME = 'ACCOUNTING')
	)
order by SAL

' In the following example, a subquery is used as a column expression named max_list_price in a SELECT statement. '
select DEPT_NO, DEPT_NAME, (select MAX(SAL) from employees e
	where e.DEPT_NO = d.DEPT_NO) as max_salary_employee
from department d
order by DEPT_NAME

' SQL Server subquery is used with IN operator '
select EMP_NAME, DEPT_NO
from employees
where DEPT_NO IN (SELECT DEPT_NO FROM department
	WHERE DEPT_LOC in ('DALLAS', 'CHICAGO'))

' SQL Server subquery is used with ANY operator '
/* The subquery is introduced with the ANY operator has the following syntax:
	scalar_expression comparison_operator ANY (subquery)
*/

select EMP_NAME, SAL
from employees
where sal >= any (select AVG(SAL) from employees)

select DEPT_NO, AVG(SAL)avg_sal_dept from employees
group by DEPT_NO

select EMP_NAME, DEPT_NO, SAL
from employees
where SAL >=  any (select AVG(SAL) from employees
	group by DEPT_NO)

select EMP_NAME, DEPT_NO, SAL
from employees
where SAL >=  any (select max(SAL) from employees
	group by DEPT_NO)
order by SAL

' SQL Server subquery is used with ALL operator ' -- syntax same as ANY: scalar_expression comparison_operator ALL (subquery)
select EMP_NAME, DEPT_NO, SAL
from employees
where sal >= all (select AVG(SAL) from employees
	group by DEPT_NO)

select DEPT_NO, AVG(SAL)avg_sal_dept from employees
group by DEPT_NO

select EMP_NAME, DEPT_NO, SAL
from employees
where sal >= all (select AVG(SAL) from employees
	group by DEPT_NO)
order by SAL

' SQL Server subquery is used with EXISTS or NOT EXISTS ' -- syntax: WHERE [NOT] EXISTS (subquery)
select EMP_NAME, DEPT_NO, SAL
from employees e
where exists (select DEPT_NO from department d
	where DEPT_NO = 0) -- ' o/p: 0 rows '

select EMP_NAME, DEPT_NO, SAL
from employees e
where exists (select DEPT_NO from department d
	where DEPT_NO = 40)  -- ' o/p: 14 rows '

select EMP_NAME, DEPT_NO, SAL
from employees e
where exists (select DEPT_NO from department d
	where e.DEPT_NO = d.DEPT_NO)  -- ' o/p: 14 rows '

' ************* '
select EMP_NAME, DEPT_NO, SAL
from employees e
where exists (select DEPT_NO from department d
	where e.DEPT_NO = d.DEPT_NO and DEPT_LOC = 'NEW YORK')
order by EMP_NAME   -- ' o/p: 3 rows '

select * 
from employees e
where exists (select DEPT_NO from department d 
	where e.DEPT_NO = d.DEPT_NO  and JOB = 'CLERK')
order by EMP_NAME     -- ' o/p: 4 rows '

select * 
from employees e
where not exists (select DEPT_NO from department d 
	where e.DEPT_NO = d.DEPT_NO  and JOB = 'CLERK')
order by EMP_NAME     -- ' o/p: 10 rows '

select EMP_NAME, DEPT_NO, SAL
from employees e
where exists (select DEPT_NO from department d
	where e.DEPT_NO = d.DEPT_NO and DEPT_LOC = 'BOSTON')
order by EMP_NAME   -- ' o/p: 0 rows '

'common records only from left table '
select DEPT_NO, DEPT_NAME, DEPT_LOC
from department d
where exists (select DEPT_NO from employees e
	where e.DEPT_NO = d.DEPT_NO)    -- ' o/p: 3 rows '
--- or ---
select * 
from department d
where exists (select DEPT_NO from employees e
	where d.DEPT_NO	 = e.DEPT_NO)    -- ' o/p: 3 rows '
--- or ---
select * 
from department
--where DEPT_NO in (select DEPT_NO from employees)
where DEPT_NO in (select distinct DEPT_NO from employees)    -- ' o/p: 3 rows '

' records present only in left table '
select DEPT_NO from department
except
select DEPT_NO from employees
--- or --- 
'***********'
select * 
from department d
where not exists (select DEPT_NO from employees e
	where d.DEPT_NO = e.DEPT_NO)   -- ' o/p: 1 rows '
--- or ---
select * 
from department
where DEPT_NO not in (select distinct DEPT_NO from employees)    -- ' o/p: 1 rows '

'********************'
select * 
from department d
inner join employees e 
on d.DEPT_NO = e.DEPT_NO

' SQL Server subquery in the FROM clause '
'******************'
select AVG(dept_count)  avg_dept_count
from (select DEPT_NO, COUNT(*) dept_count from employees 
	group by DEPT_NO) as t;    -- ' o/p: 4 '

select AVG(job_count) avg_job_count
from (select job, COUNT(job) job_count from employees
	group by JOB) as t;   -- ' o/p: 2 '


select * from employees

-- ================================

' ----------- Correlated Subquery --------------- '
/* A correlated subquery is a subquery that uses the values of the outer query. 
In other words, the correlated subquery depends on the outer query for its values.

Because of this dependency, a correlated subquery cannot be executed independently as a simple subquery.

Moreover, a correlated subquery is executed repeatedly, once for each row evaluated by the outer query. 
The correlated subquery is also known as a repeating subquery.
*/

select EMP_NAME, DEPT_NO, SAL
from employees e1
where SAL in (select MAX(SAL) from employees e2
	where e1.DEPT_NO = e2.DEPT_NO)
order by 1,2,3

' ******* '
'details of employee who is having sal = to max(sal) from each department '
select EMP_NAME, DEPT_NO, SAL
from employees e1
where SAL in (select MAX(SAL) from employees e2
	where e1.DEPT_NO = e2.DEPT_NO
	group by DEPT_NO)
order by 1,2,3

select EMP_NAME, JOB, SAL
from employees e1
where SAL in (select MAX(SAL) from employees e2
	where e1.DEPT_NO = e2.DEPT_NO
	group by JOB)
order by 3,2,1

select EMP_NAME, JOB, SAL
from employees e1
where SAL in (select MAX(SAL) from employees e2
	group by JOB)
order by 3,2,1

/*
In this example, for each employee evaluated by the outer query, the subquery finds the highest sal of all employees in its category.

If the price of the current employee is equal to the highest price of all employee in its category, 
the employee is included in the result set. This process continues for the next employee and so on.

As you can see, the correlated subquery is executed once for each employee evaluated by the outer query.

*/




--  ===============================================================================================

select top 4 * 
from employees
--- or --- both are same
select top 4 * 
from employees
order by (select null) -- to indicate no specific ordering(select as it is in table)

select top 4 * 
from employees
order by EMP_NAME  

'for above - execution order: from => select => order by => top n '

select * 
from employees
order by EMP_NAME

---------------------
' print employees details along with row number '
SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS slno
FROM employees

' print 3rd record from table) '
select * 
from (select *, ROW_NUMBER() over (order by (select null)) as slno from employees) as row_numbers
where slno = 3

' print last 2 records as it is in table) '
select * 
from (select *, ROW_NUMBER() over (order by(select null)) as slno from employees) as row_numers 
where slno > (select COUNT(*)-2 from employees)

' print 2nd half records as it is in table) '
select * 
from (select *, ROW_NUMBER() over (order by(select null)) as slno from employees) as numbered_employees
where slno > (select COUNT(*)/2 from employees)

-------------------------------
DECLARE @TotalRows INT
DECLARE @HalfRows INT

-- Get the total number of rows in the employees table
SELECT @TotalRows = COUNT(*) FROM employees

-- Calculate the number of rows in the second half
SET @HalfRows = @TotalRows / 2

-- Select the second half of the rows
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS slno
    FROM employees
) AS numbered_employees
WHERE slno > @HalfRows

-------------------------------

' print 1st half records as it is in table) '
SELECT *
FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS slno FROM employees) AS numbered_employees
WHERE slno <= (select COUNT(*)/2 from employees)
--- or ---- both are same
' print 1st half records as it is in table) '
select top (select count(*)/2 from employees) *
from employees

' print 1st half records based on emp_name from table) '
select top (select count(*)/2 from employees) *
from employees
order by EMP_NAME

' print records between 4 to 8 as it in table '
select * 
from employees
order by (select null)
offset 3 rows
fetch next 5 rows only
--- or ---- both are same
select * 
from (select *, ROW_NUMBER() over (order by (select null)) as slno from employees) as numbered_employees
where slno >= 4 and slno <= 8

-----------------------------
' print all even row records '
select *
from (select *, ROW_NUMBER() over (order by(select null)) as slno from employees) as numbered_employees
where slno%2 = 0;

select *
from (select *, ROW_NUMBER() over (order by(select null)) as slno from employees) as numbered_employees
where slno >= 2 and slno <= 6

select *
from (select *, ROW_NUMBER() over (order by(select null)) as slno from employees) as numbered_employees
where slno = 4

select SAL from employees order by SAL desc
select distinct SAL from employees order by SAL desc


' print 3rd max sal '
select * 
from employees
where SAL = (select MAX(SAL) from employees
	where SAL < (select MAX(SAL) from employees
	where SAL < (select MAX(SAL) from employees)
	))  -- o/p: 2975.00
--- or --- 
' *** dense_rank() -> This function handles ties by assigning the same rank to equal values and 
then leaving gaps in the sequence for subsequent values. '
select * from (select *, DENSE_RANK() over(order by sal desc) as slno
from employees) as numbered_employees
where slno = 3  -- o/p: 2975.00

' this will not give 3rd max sal emp details, so insted of ROW_NUMBER() use DENSE_RANK() function '
select * 
from (select *, ROW_NUMBER() over(order by  sal desc) as slno 
from employees) as numbered_employees
where slno = 3  -- o/p: 3000.00

select * from (select *, dense_rank() over(order by sal desc) as slno
from employees) as numbered_employees
where slno = 3


' deails of employees(multiple) getting max sal '
select * from employees 
where SAL = (select MAX(SAL) from employees) 

' details of employee(single) getting max sal'
select * from employees
order by SAL desc
offset 0 rows
fetch first 1 row only
--- or ---
select top 1 * from employees
order by SAL desc

select distinct sal from employees






