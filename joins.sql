
' ----- JOINS Operations ------- '

create database JOINS_Database

use JOINS_Database

SELECT * FROM DQL_Database.dbo.EMPLOYEES
SELECT * FROM DQL_Database.dbo.DEPARTMENT

select * 
into JOINS_Database.dbo.EMPLOYEES
FROM DQL_Database.dbo.EMPLOYEES

SELECT *
into JOINS_Database.dbo.DEPARTMENT
FROM DQL_Database.dbo.DEPARTMENT

SELECT * FROM JOINS_Database.dbo.EMPLOYEES
SELECT * FROM JOINS_Database.dbo.DEPARTMENT

-- ===============================================
' SQL Server joins allow us to combine data from two tables. '

CREATE SCHEMA hr;
GO

create table hr.candidates (
	id int primary key identity,
	fullname varchar(100) not null
	);

create table hr.employees (
	id int primary key identity,
	fullname varchar(100) not null
	);

INSERT INTO 
    hr.candidates(fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');


INSERT INTO 
    hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

select * from hr.candidates;
select * from hr.employees;

-- ===================================================
' ============== 1. INNER JOIN =============== '
/* Inner join produces a data set that includes rows from the left table, and matching rows from the right table.
 SYNTAX: SELECT select_list FROM T1 [INNER] JOIN T2 ON join_predicate;

EX: SELECT product_name, category_name, brand_name,  list_price
 FROM production.products p
 INNER JOIN production.categories c ON c.category_id = p.category_id
 INNER JOIN production.brands b ON b.brand_id = p.brand_id
 ORDER BY product_name DESC;

*/

select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
inner join hr.employees e
on c.fullname = e.fullname

select * from DEPARTMENT
select * from EMPLOYEES

SELECT E.DEPT_NO, EMP_NAME, DEPT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO

SELECT EMP_NAME, E.DEPT_NO, DEPT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
WHERE D.DEPT_NO IN (10, 20)
ORDER BY EMP_NAME



' ============= 2. Left Join =========================== '
/* The left join returns all rows from the left table and the matching rows from the right table. 
If a row in the left table does not have a matching row in the right table, the columns of the right table will have nulls.

The left join is also known as the left outer join. The outer keyword is optional.

SYNTAX: SELECT select_list FROM T1 LEFT JOIN T2 ON join_predicate;

EX: SELECT
    p.product_name,
    o.order_id,
    i.item_id,
    o.order_date
FROM
    production.products p
	LEFT JOIN sales.order_items i
		ON i.product_id = p.product_id
	LEFT JOIN sales.orders o
		ON o.order_id = i.order_id
	ORDER BY order_id;
	
*/

select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
left join hr.employees e
on c.fullname = e.fullname

' to select non matching rows from left table (fetch records which are present ony in left table) '
select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
left join hr.employees e
on c.fullname = e.fullname
where e.id is null

SELECT E.DEPT_NO, EMP_NAME, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES E
LEFT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO

SELECT E.DEPT_NO, EMP_NAME, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES E
LEFT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
ORDER BY DEPT_NO

SELECT E.DEPT_NO, EMP_NAME, COMMISSION, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES E
LEFT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
WHERE COMMISSION IS NULL

SELECT D.DEPT_NO, DEPT_NAME, DEPT_LOC, EMP_NAME
FROM DEPARTMENT D 
LEFT JOIN EMPLOYEES E
ON D.DEPT_NO = E.DEPT_NO

'  LEFT JOIN: conditions in ON vs. WHERE clause '
SELECT E.DEPT_NO, EMP_NAME, SAL, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES E
LEFT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
WHERE SAL = 1250 
--WHERE SAL > 1500

SELECT E.DEPT_NO, EMP_NAME, SAL, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES E
LEFT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
AND E.SAL = 1250
--AND E.SAL > 1500



' =============== 3. Right Join ====================== '
/* The right join or right outer join selects data starting from the right table. It is a reversed version of the left join.

The right join returns a result set that contains all rows from the right table and the matching rows in the left table. 
If a row in the right table does not have a matching row in the left table, all columns in the left table will contain nulls.

SYNTAX: SELECT select_list FROM T1 RIGHT JOIN T2 ON join_predicate;

*/

select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
right join hr.employees e
on c.fullname = e.fullname

' to select non matching rows from right table (fetch records which are present ony in right table) '
select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
right join hr.employees e
on c.fullname = e.fullname
where c.id is null

SELECT E.DEPT_NO, EMP_NAME, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES  E
RIGHT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO

SELECT D.DEPT_NO, EMP_NAME, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES  E
RIGHT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
ORDER BY DEPT_NAME

' ROWS PRESENT ONLY IN RIGHT '
SELECT D.DEPT_NO, EMP_NAME, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES  E
RIGHT JOIN DEPARTMENT D
ON E.DEPT_NO = D.DEPT_NO
WHERE EMP_NAME IS NULL


' ================= 4. Full Join or Full outer join ========================= '
/* The full outer join or full join returns a result set that contains all rows from both left and right tables, 
with the matching rows from both sides where available. In case there is no match, the missing side will have NULL values.

SYNTAX: SELECT select_list FROM T1 FULL [OUTER] JOIN T2 ON join_predicate;

*/

select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
full join hr.employees e
on c.fullname = e.fullname

' To select rows that exist in either the left or right table, you exclude rows that are common to both tables by 
adding a WHERE clause as shown in the following query: '
select c.id candidate_id, c.fullname candidate_name, e.id employee_id, e.fullname employee_name
from hr.candidates c
full join hr.employees e
on c.fullname = e.fullname
where c.id is null or e.id is null

CREATE SCHEMA pm;
GO

CREATE TABLE pm.projects(
    id INT PRIMARY KEY IDENTITY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE pm.members(
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(120) NOT NULL,
    project_id INT,
    FOREIGN KEY (project_id) 
        REFERENCES pm.projects(id)
);

INSERT INTO 
    pm.projects(title)
VALUES
    ('New CRM for Project Sales'),
    ('ERP Implementation'),
    ('Develop Mobile Sales Platform');


INSERT INTO
    pm.members(name, project_id)
VALUES
    ('John Doe', 1),
    ('Lily Bush', 1),
    ('Jane Doe', 2),
    ('Jack Daniel', null);

SELECT * FROM pm.projects;
SELECT * FROM pm.members;

SELECT m.name member, p.title project
FROM pm.members m
FULL OUTER JOIN pm.projects p 
ON p.id = m.project_id;

' To find the members who do not participate in any project and projects which do not have any members, 
you add a WHERE clause to the above query: '
SELECT M.name MEMBER, P.title PROJECT
FROM pm.members M
FULL OUTER JOIN pm.projects P
ON M.project_id = P.id
WHERE M.name IS NULL OR P.title IS NULL


' ================= 5. CROSS Join or CARTESIN join (M * N)========================= '
/* A cross join allows you to combine rows from the first table with every row of the second table. 
In other words, it returns the Cartesian product of two tables.

SYNTAX: SELECT select_list FROM T1 CROSS JOIN T2;

Unlike other join types such as INNER JOIN or LEFT JOIN, the cross join does not require a join condition.

*/

SELECT EMP_NAME, JOB, DEPT_NAME, DEPT_LOC
FROM EMPLOYEES 
CROSS JOIN DEPARTMENT 
ORDER BY JOB, DEPT_NAME


' ================= 6. SELF Join ========================= '
/* A self join allows you to join a table to itself. It helps query hierarchical data or compare rows within the same table.

A self join uses the inner join or left join clause. Because the query that uses the self join references the same table, 
the table alias is used to assign different names to the same table within the query.

Note that referencing the same table more than once in a query without using table aliases will result in an error.

The following shows the syntax of joining the table T to itself:

SELECT
    select_list
FROM
    T t1
[INNER | LEFT]  JOIN T t2 ON
    join_predicate; 

*/

SELECT E1.EMP_ID, E1.EMP_NAME EMP, E1.MGR_ID, E2.EMP_NAME MNGR, E2.EMP_ID
FROM EMPLOYEES E1
INNER JOIN EMPLOYEES E2
ON E1.MGR_ID = E2.EMP_ID
ORDER BY E1.EMP_NAME;

SELECT * FROM EMPLOYEES
ORDER BY JOB

' The following statement uses the self join to find the EMPLOYEES WORKING in the same JOB. '
SELECT E1.JOB, E1.EMP_ID, E1.EMP_NAME EMP1, E1.MGR_ID, E2.EMP_NAME EMP2, E2.EMP_ID
FROM EMPLOYEES E1
INNER JOIN EMPLOYEES E2
ON E1.EMP_ID > E2.EMP_ID
AND E1.JOB = E2.JOB
ORDER BY JOB, EMP1, EMP2;
/*
This following condition makes sure that the statement doesn’t compare the same EMPLOYEE: E1.EMP_ID > E2.EMP_ID
This following condition matches the JOB of the two customers: E1.JOB = E2.JOB

Note that if you change the greater than ( > ) operator by the not equal to (<>) operator, you will get more rows:

*/

SELECT E1.JOB, E1.EMP_ID, E1.EMP_NAME EMP1, E1.MGR_ID, E2.EMP_NAME EMP2, E2.EMP_ID
FROM EMPLOYEES E1
INNER JOIN EMPLOYEES E2
ON E1.EMP_ID <> E2.EMP_ID
AND E1.JOB = E2.JOB
ORDER BY JOB, EMP1, EMP2;

-- BREAK DOWN QUERY
' Let’s see the difference between > and <> in the ON clause by limiting to one city to make it easier for comparison. '
SELECT EMP_ID, EMP_NAME, JOB
FROM EMPLOYEES 
WHERE JOB = 'SALESMAN'
ORDER BY EMP_NAME

SELECT E1.JOB, E1.EMP_ID, E1.EMP_NAME EMP1, E1.MGR_ID, E2.EMP_NAME EMP2, E2.EMP_ID
FROM EMPLOYEES E1
INNER JOIN EMPLOYEES E2 
ON E1.EMP_ID > E2.EMP_ID
AND E1.JOB = E2.JOB
WHERE E1.JOB = 'SALESMAN'
ORDER BY JOB, EMP1, EMP2

SELECT E1.JOB, E1.EMP_ID, E1.EMP_NAME EMP1, E1.MGR_ID, E2.EMP_NAME EMP2, E2.EMP_ID
FROM EMPLOYEES E1
INNER JOIN EMPLOYEES E2 
ON E1.EMP_ID <> E2.EMP_ID
AND E1.JOB = E2.JOB
WHERE E1.JOB = 'SALESMAN'
ORDER BY JOB, EMP1, EMP2





-- =====================================







