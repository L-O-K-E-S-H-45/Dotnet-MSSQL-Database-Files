
 ' DQL -> Data Query Operations (SELECT) '

create database DQL_Database

USE DQL_Database;

-- PARENT TABLE
CREATE TABLE DEPARTMENT (
	DEPT_NO INT PRIMARY KEY,
	DEPT_NAME VARCHAR(100) NOT NULL UNIQUE,
	DEPT_LOC NVARCHAR(150) NOT NULL UNIQUE
	);

INSERT INTO DEPARTMENT 
VALUES (10,'ACCOUNTING','NEW YORK'),
	(20,'RESEARCH','DALLAS'),
	(30,'SALES','CHICAGO'),
	(40,'OPEARTIONS','BOSTON')

SELECT * FROM DEPARTMENT;

-- CHILD TABLE
CREATE TABLE EMPLOYEES (
	EMP_ID INT PRIMARY KEY,
	EMP_NAME VARCHAR(100) NOT NULL,
	JOB VARCHAR(10) NOT NULL,
	MGR_ID INT,
	HIREDATE DATE NOT NULL,
	SAL DECIMAL(7,2) NOT NULL,
	COMMISSION INT,
	DEPT_NO INT,
	CONSTRAINT FRK_DEPT_NO FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT(DEPT_NO)
	);

INSERT INTO EMPLOYEES(EMP_ID,EMP_NAME,JOB,MGR_ID,HIREDATE,SAL,COMMISSION,DEPT_NO)
VALUES (7369,'SMITH','CLERK',7902,'1980-12-17',800,300,20),
	(7499,'ALLEN','SALESMAN',7698,'1981-FEB-20',1600,500,30),
	(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,NULL,30),
	(7566,'JONES','MANAGER',7839,'1981-02-2',2975,1400,20),
	(7654,'MARTIN','SALESMAN',7698,'1981-SEP-28',1250,NULL,30),
	(7698,'BLAKE','MANAGER',7839,'1981-MAY-01',2850,NULL,30),
	(7782,'CLARK','MANAGER',7839,'1981-JUN-9',2450,NULL,10),
	(7788,'SCOTT','ANALYST',7566,'1987-APR-19',3000,NULL,20),
	(7839,'KING','PRESIDENT',NULL,'1981-NOV-17',5000,NULL,10),
	(7844,'TURNER','SALESMAN',7698,'1981-SEP-08',1500,0,30),
	(7876,'ADAMS','CLERK',7788,'1987-MAY-23',1100,NULL,20),
	(7900,'JAMES','CLERK',7698,'1981-DEC-3',950,NULL,30),
	(7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,20),
	(7934,'MILLER','CLERK',7782,'1982-JAN-23',1300,NULL,10)

' ============ SECTION-1 - Querying data ======================================================= '
SELECT * FROM DEPARTMENT
SELECT * FROM EMPLOYEES

select * from dbo.EMPLOYEES

SELECT EMP_NAME, SAL FROM EMPLOYEES

SELECT EMP_NAME, SAL FROM dbo.EMPLOYEES

-- WHERE CLAUSE
SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'

-- ORDER BY CLAUSE
SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME
--OR
SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME ASC

SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME DESC

-- Sort a result set by multiple columns
SELECT * FROM EMPLOYEES
ORDER BY JOB,DEPT_NO

SELECT JOB,DEPT_NO FROM EMPLOYEES
ORDER BY JOB DESC,DEPT_NO ASC

SELECT JOB,DEPT_NO FROM EMPLOYEES
ORDER BY JOB,DEPT_NO DESC

SELECT EMP_NAME, JOB, SAL FROM EMPLOYEES
ORDER BY HIREDATE 

-- Sort a result set by an expression 
SELECT * FROM EMPLOYEES
ORDER BY LEN(EMP_NAME)

-- Sort by ordinal positions of columns
-- SQL Server allows you to sort the result set based on the ordinal positions of columns that appear in the select list.
SELECT JOB, DEPT_NO FROM EMPLOYEES
ORDER BY 1, 2

-- GROUP BY CLAUSE
SELECT JOB, COUNT(*) FROM  EMPLOYEES
GROUP BY JOB
ORDER BY JOB

-- HAVING CALUSE
SELECT JOB, COUNT(*) FROM EMPLOYEES
GROUP BY JOB
HAVING COUNT(*) > 2
ORDER BY JOB

 ' ---- SECTION-1: END --------  '

' ============ SECTION-2: Sorting data ================================================ '
-- ORDER BY CLAUSE
SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME
--OR
SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME ASC

SELECT * FROM dbo.EMPLOYEES
WHERE JOB = 'CLERK'
ORDER BY EMP_NAME DESC

-- Sort a result set by multiple columns
SELECT * FROM EMPLOYEES
ORDER BY JOB,DEPT_NO

SELECT JOB,DEPT_NO FROM EMPLOYEES
ORDER BY JOB DESC,DEPT_NO ASC

SELECT JOB,DEPT_NO FROM EMPLOYEES
ORDER BY JOB,DEPT_NO DESC

SELECT EMP_NAME, JOB, SAL FROM EMPLOYEES
ORDER BY HIREDATE 

-- Sort a result set by an expression 
SELECT * FROM EMPLOYEES
ORDER BY LEN(EMP_NAME)

-- Sort by ordinal positions of columns
-- SQL Server allows you to sort the result set based on the ordinal positions of columns that appear in the select list.
SELECT JOB, DEPT_NO FROM EMPLOYEES
ORDER BY 1, 2

' ---- SECTION-2: END --------  '

' ============ SECTION-3: Limiting rows ========================================= '
 ' -- 1. OFFSET FETCH '
/*
-- AFTER SELECT OR OTHER CLAUESE ---
ORDER BY column_list [ASC |DESC]
OFFSET offset_row_count {ROW | ROWS}
FETCH {FIRST | NEXT} fetch_row_count {ROW | ROWS} ONLY
*/

SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME
OFFSET 2 ROW
FETCH FIRST 4 ROW ONLY
-- ABOVE & BELOW -> BOTH OR SAME
SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME
OFFSET 2 ROWS
FETCH NEXT 4 ROWS ONLY

SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME DESC
OFFSET 0 ROWS
FETCH NEXT 2 ROWS ONLY
-- NEXT & FIRST BOTH WORKS SAME
SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME DESC
OFFSET 0 ROWS
FETCH FIRST 2 ROWS ONLY

-- Using the SQL Server OFFSET
SELECT JOB,  DEPT_NO FROM EMPLOYEES
ORDER BY JOB, DEPT_NO
OFFSET 4 ROWS

SELECT JOB,  DEPT_NO FROM EMPLOYEES
ORDER BY JOB, DEPT_NO
OFFSET 4 ROWS
FETCH NEXT 4 ROWS ONLY

-- Using the OFFSET FETCH clause to get the top N rows
SELECT JOB,  DEPT_NO FROM EMPLOYEES
ORDER BY JOB, DEPT_NO
OFFSET 0 ROWS
FETCH NEXT 4 ROWS ONLY

' -- 2. SELECT TOP '
/*
SELECT TOP (expression) [PERCENT]
    [WITH TIES]
FROM 
    table_name
ORDER BY 
    column_name;
In this syntax, the SELECT statement can have other clauses such as WHERE, JOIN, HAVING, and GROUP BY
For example, if you want to return the most expensive products, you can use the TOP 1. However, if two or more products have the same prices as the most expensive product, then you may miss the other most expensive products in the result set.

To avoid this, you can use TOP 1 WITH TIES. It will include not only the first expensive product but also the second one, and so forth.
*/
SELECT * FROM EMPLOYEES


SELECT TOP 6 * FROM EMPLOYEES
ORDER BY JOB

SELECT TOP 6 * FROM EMPLOYEES
ORDER BY JOB DESC

SELECT TOP 10 PERCENT * FROM EMPLOYEES
ORDER BY EMP_NAME

SELECT TOP 20 PERCENT * FROM EMPLOYEES

-- TOP WITH TIES
SELECT TOP 4 WITH TIES * FROM EMPLOYEES
ORDER BY SAL
 -- O/P : 5 ROWS

SELECT TOP 4 WITH TIES * FROM EMPLOYEES
ORDER BY SAL DESC

' ---- SECTION-3: END --------  '

' ============ SECTION-4: Filtering data ======================================================= '
' -- 1. DISTINCT '
SELECT JOB, DEPT_NO FROM EMPLOYEES

-- Using the SELECT DISTINCT with one column
SELECT DISTINCT JOB FROM EMPLOYEES

-- Using SELECT DISTINCT with multiple columns
SELECT DISTINCT JOB, DEPT_NO FROM EMPLOYEES

SELECT DISTINCT JOB, DEPT_NO FROM EMPLOYEES
ORDER BY JOB DESC

-- Using SELECT DISTINCT with NULL
SELECT COMMISSION FROM EMPLOYEES

SELECT DISTINCT COMMISSION FROM EMPLOYEES

-- DISTINCT vs. GROUP BY
SELECT JOB FROM EMPLOYEES
GROUP BY JOB

SELECT JOB, DEPT_NO FROM EMPLOYEES
GROUP BY JOB, DEPT_NO
-- BOTH ARE SAME
SELECT DISTINCT JOB, DEPT_NO FROM EMPLOYEES

-- Both DISTINCT and GROUP BY clause reduces the number of returned rows in the result set by removing the duplicates.
-- However, you should use the GROUP BY clause when you want to apply an aggregate function to one or more columns.

SELECT JOB, DEPT_NO, HIREDATE FROM EMPLOYEES
GROUP BY JOB,DEPT_NO,HIREDATE
ORDER BY JOB,DEPT_NO,HIREDATE

' -- 2. WHERE Clause '
/*
Note that SQL Server uses three-valued predicate logic where a logical expression can evaluate to TRUE, FALSE, or UNKNOWN. 
The WHERE clause will not return any row that causes the predicate to evaluate to FALSE or UNKNOWN.
*/

SELECT * FROM EMPLOYEES
WHERE EMP_ID = 7654

SELECT DEPT_NO, EMP_NAME FROM EMPLOYEES
WHERE DEPT_NO = 30
ORDER BY EMP_NAME

-- AND
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES
WHERE DEPT_NO = 30 AND SAL > 1400
ORDER BY EMP_NAME

-- OR
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES  
WHERE DEPT_NO = 10 OR EMP_NAME LIKE '%R%' -- TO ESCAPE CHARACTER => ' EX:  '' , '$ , '@

-- BETWEEN
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES  
WHERE SAL BETWEEN 1500 AND 5000 -- INCLUDES END VALUES

-- IN
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES 
WHERE SAL IN (1250, 3000, 2975)

-- LIKE
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES 
WHERE EMP_NAME LIKE '%LA%'

-- 3. AND Operator => SQL Server evaluates the AND operator first.
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES 
WHERE DEPT_NO = 10

SELECT DEPT_NO, JOB, SAL FROM EMPLOYEES 
WHERE DEPT_NO = 20 AND JOB = 'CLERK' AND SAL > 1000

SELECT DEPT_NO, JOB, SAL FROM EMPLOYEES 
WHERE JOB = 'SALESMAN' OR JOB = 'CLERK' AND SAL > 1000 --O/P: 8 ROWS
/* In this example, we used both OR and AND operators in the condition. As always, SQL Server evaluates the AND operator first. 
Therefore, the query retrieves the EMPLOYEES with the JOB = 'CLERK' and SAL > 1000 or JOB = 'SALESMAN'
*/

SELECT DEPT_NO, JOB, SAL FROM EMPLOYEES 
WHERE (JOB = 'SALESMAN' OR JOB = 'CLERK') AND SAL > 1000 --O/P: 6 ROWS

' -- 4. OR Operator ' 
-- => By default, SQL Server evaluates the OR operators after the AND operators within the same expression. 
-- But you can use parentheses () to change the order of evaluation.
SELECT EMP_NAME, SAL FROM EMPLOYEES 
WHERE SAL < 1500 OR SAL > 2500

SELECT EMP_NAME, JOB FROM EMPLOYEES 
WHERE JOB = 'PRESIDENT' OR JOB = 'MANAGER' OR JOB = 'CLERK'
ORDER BY JOB
-- OR
SELECT EMP_NAME, JOB FROM EMPLOYEES 
WHERE JOB IN ('PRESIDENT', 'MANAGER', 'CLERK')
ORDER BY JOB

' -- 5. IN Operator '
-- The syntax of the SQL Server IN operator: column | expression IN ( v1, v2, v3, ...)
-- To negate the IN operator, you use the NOT IN operator as follows: column | expression NOT IN ( v1, v2, v3, ...)
-- In addition to a list of values, you can use a subquery that returns a list of values with the IN operator as shown below:
-- column | expression IN (subquery), In this syntax, the subquery is a SELECT statement that returns a list of values of a single column.

SELECT EMP_NAME, JOB FROM EMPLOYEES 
WHERE JOB IN ('PRESIDENT', 'MANAGER', 'CLERK')
ORDER BY JOB

SELECT EMP_NAME, JOB FROM EMPLOYEES 
WHERE JOB NOT IN ('PRESIDENT', 'MANAGER', 'CLERK')
ORDER BY JOB

-- Using SQL Server IN operator with a subquery
SELECT * FROM EMPLOYEES
WHERE EMP_ID IN (SELECT MGR_ID FROM EMPLOYEES
				WHERE JOB = 'SALESMAN' OR JOB = 'CLERK')
-- O/P: 7902,7698,7788,7782 => BLAKE,CLARK,SCOTT,FORD


SELECT * FROM EMPLOYEES
WHERE DEPT_NO IN (SELECT DEPT_NO FROM DEPARTMENT
				WHERE DEPT_NAME = 'RESEARCH' OR DEPT_LOC= 'NEW YORK')

' -- 6. BETWEEN OPERATOR '
SELECT DEPT_NO, EMP_NAME, SAL FROM EMPLOYEES  
WHERE SAL BETWEEN 1500 AND 5000 -- INCLUDES END VALUES

' -- 7. LIKE Operator '
/*A pattern may include regular characters and wildcard characters. The LIKE operator is used in the WHERE clause of the 
SELECT, UPDATE, and DELETE statements to filter rows based on pattern matching.
The syntax of the LIKE operator: column | expression LIKE pattern [ESCAPE escape_character]
The wildcard characters make the LIKE operator more flexible than the equal (=) and not equal (!=) string comparison operators.
To negate the result of the LIKE operator, you use the NOT operator as follows: 
column | expression NOT LIKE pattern [ESCAPE escape_character]
*/

SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE 'A%'
ORDER BY EMP_NAME DESC -- OPTIONAL

SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE 'J%S'
ORDER BY EMP_NAME 

-- Using the LIKE operator with the _ (underscore) wildcard
SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE '_A%'

--  Using the LIKE operator with the [list of characters] wildcard
SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE '[SA]%'

-- Using the LIKE operator with the [character-character] wildcard
SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE '[D-R]%'

-- Using the LIKE operator with the [^Character List or Range] wildcard 
SELECT * FROM EMPLOYEES
WHERE EMP_NAME LIKE '[^D-R]%'

-- Using the NOT LIKE operator
SELECT * FROM EMPLOYEES
WHERE EMP_NAME NOT LIKE 'A%'

SELECT * FROM EMPLOYEES
WHERE EMP_NAME NOT LIKE '[^A]%'

-- Using the LIKE operator with ESCAPE
CREATE TABLE feedbacks (
  feedback_id INT IDENTITY(1, 1) PRIMARY KEY, 
  comment VARCHAR(255) NOT NULL
);

INSERT INTO feedbacks(comment)
VALUES('Can you give me 30% discount?'),
      ('May I get me 30USD off?'),
      ('Is this having 20% discount today?');
SELECT * FROM feedbacks

SELECT feedback_id, comment FROM feedbacks
WHERE comment LIKE '%30%';

-- USING ! 
SELECT feedback_id, comment FROM feedbacks
WHERE comment LIKE '%30!%%' ESCAPE '!';
-- USING ' => WORKS ONLY FOR ''

SELECT feedback_id, comment FROM feedbacks
WHERE comment LIKE '%30''%'

' -- 8. Column & table aliases '
-- => SYNTAX: column_name | expression  AS column_alias
--column aliases to change the heading of the query output and 
-- table alias to improve the readability of a query
' Column alias '
SELECT EMP_NAME + ' ' + SAL FROM EMPLOYEES  'Error converting data type varchar to numeric.'

SELECT EMP_NAME + ' ' + JOB FROM EMPLOYEES
ORDER BY EMP_NAME

SELECT EMP_NAME + ' - ' + JOB FROM EMPLOYEES
ORDER BY EMP_NAME

SELECT EMP_NAME + ' - ' + JOB AS DETAILS FROM EMPLOYEES
ORDER BY EMP_NAME

SELECT EMP_NAME + ' - ' + JOB AS "EMP DETAILS" FROM EMPLOYEES
ORDER BY EMP_NAME
-- BOTH SINGLE QUATAION OR DOUBLE QUATAION FOR ALIAS NAME
SELECT EMP_NAME + ' -> ' + JOB AS "EMP DETAILS" FROM EMPLOYEES
ORDER BY EMP_NAME

'When you assign a column an alias, you can use either the column name or the column alias in the ORDER BY clause'
SELECT EMP_NAME 'EMPLOYEE NAME' FROM EMPLOYEES
ORDER BY EMP_NAME DESC

SELECT EMP_NAME 'EMPLOYEE NAME' FROM EMPLOYEES
ORDER BY 'EMPLOYEE NAME' DESC

' table alias ' -- SYNTAX:  table_name AS table_alias OR table_name table_alias
SELECT EMP_NAME, EMPLOYEES.DEPT_NO  '*******'
FROM EMPLOYEES INNER JOIN DEPARTMENT
ON EMPLOYEES.DEPT_NO = DEPARTMENT.DEPT_NO

SELECT DEPARTMENT.DEPT_NO, DEPT_NAME 
FROM DEPARTMENT INNER JOIN EMPLOYEES
ON DEPARTMENT.DEPT_NO  = EMPLOYEES.DEPT_NO

SELECT D.DEPT_NO, DEPT_LOC
FROM DEPARTMENT D INNER JOIN EMPLOYEES E
ON D.DEPT_NO = E.DEPT_NO

' ------- SECTION-5: END ----------------- '

' ============ SECTION-6: Grouping data ======================================================= '
'--- 1. GROUP BY ' -- SYNTAX: SELECT select_list FROM table_name GROUP BY column_name1, column_name2 ,...;
SELECT JOB FROM EMPLOYEES
GROUP BY JOB
ORDER BY JOB

SELECT JOB, DEPT_NO FROM EMPLOYEES
GROUP BY JOB, DEPT_NO
ORDER BY JOB DESC

SELECT DEPT_NO, JOB, YEAR(HIREDATE) hire_date FROM EMPLOYEES
WHERE DEPT_NO IN (10, 20)
ORDER BY DEPT_NO  -- ORDER BY hire_date

-- USING GROUP BY
SELECT DEPT_NO, YEAR(HIREDATE) hire_date FROM EMPLOYEES
WHERE DEPT_NO IN (10, 20)
GROUP BY DEPT_NO, YEAR(HIREDATE)
ORDER BY DEPT_NO
-- OR => USING DISTINCT
SELECT DISTINCT DEPT_NO, YEAR(HIREDATE) FROM EMPLOYEES
WHERE DEPT_NO IN (10, 20) 
ORDER BY DEPT_NO

' The GROUP BY clause arranges rows into groups and an aggregate function returns the summary 
 (count, min, max, average, sum, etc.,) for each group. '
 SELECT DEPT_NO, YEAR(HIREDATE), COUNT(*) FROM EMPLOYEES
 WHERE DEPT_NO IN (10, 20)
 GROUP BY DEPT_NO, YEAR(HIREDATE)
 ORDER BY DEPT_NO

SELECT DEPT_NO, COUNT(*) DEPTS FROM EMPLOYEES
GROUP BY DEPT_NO
ORDER BY DEPT_NO

SELECT DEPT_NO, JOB, COUNT(*) DEPTS FROM EMPLOYEES
GROUP BY DEPT_NO, JOB
ORDER BY DEPT_NO

SELECT JOB, COUNT(*), MAX(SAL) max_sal, MIN(SAL) min_sal, SUM(SAL) total_sal  FROM EMPLOYEES
GROUP BY JOB
ORDER BY JOB

SELECT JOB, COUNT(*), MAX(SAL) max_sal, MIN(SAL) min_sal, SUM(SAL + COMMISSION) total_sal  FROM EMPLOYEES
GROUP BY JOB
ORDER BY JOB

' -- 2. HAVING ' -- => SYNTAX: SELECT select_list FROM table_name GROUP BY group_list HAVING conditions;
/*
SELECT
    column_name1,
    column_name2,
    aggregate_function (column_name3) alias
FROM
    table_name
GROUP BY
    column_name1,
    column_name2
HAVING
    aggregate_function (column_name3) > value;
*/
 
 SELECT DEPT_NO, JOB, COUNT(*) FROM EMPLOYEES
 GROUP BY DEPT_NO, JOB
 HAVING COUNT(*) > 1
 ORDER BY DEPT_NO

 SELECT DEPT_NO, YEAR(HIREDATE), COUNT(*) FROM EMPLOYEES
 GROUP BY DEPT_NO, YEAR(HIREDATE)
 HAVING COUNT (*) > 1
 ORDER BY DEPT_NO

 SELECT DEPT_NO, COUNT(*) FROM EMPLOYEES
 GROUP BY DEPT_NO
 ORDER BY DEPT_NO

 SELECT DEPT_NO, COUNT(*) FROM EMPLOYEES
 GROUP BY DEPT_NO
 HAVING COUNT(*) > 3
 ORDER BY DEPT_NO

 SELECT SUM(SAL) FROM EMPLOYEES

 SELECT SUM(SAL + COMMISSION) FROM EMPLOYEES

 SELECT JOB, COUNT(*), SUM(SAL) FROM EMPLOYEES
 GROUP BY JOB
 HAVING SUM(SAL) > 5000
 ORDER BY JOB

 SELECT JOB, COUNT(*), MAX(SAL) max_sal,  MIN(SAL) min_sal FROM EMPLOYEES
 GROUP BY JOB
 HAVING MAX(SAL) < 4000 AND MIN(SAL) > 1400
 ORDER BY JOB

 SELECT JOB, COUNT(*), MAX(SAL) max_sal,  MIN(SAL) min_sal FROM EMPLOYEES
 GROUP BY JOB
 HAVING MAX(SAL) < 4000 OR MIN(SAL) > 1400
 ORDER BY JOB

 SELECT JOB, COUNT(*), AVG(SAL) avg_sal FROM EMPLOYEES
 GROUP BY JOB
 HAVING AVG(SAL) BETWEEN 1500 AND 3000
 ORDER BY JOB

 ' -- 3. GROUPING SETS '

 ' -- 4. CUBE '
	
 ' -- 5. ROLLUP '


' ------- SECTION-6: END ----------------- '

' ============ SECTION-8: Set Operators ======================================================= '
'-- 1. UNION '
/* Use the SQL Server UNION to combine the results of two or more queries into a single result set.
 SYNTAX: query_1 UNION query_2
 By default, the UNION operator removes all duplicate rows from the result sets. However, if you want to retain the duplicate rows, 
 you need to specify the ALL keyword is explicitly as shown : query_1 UNION ALL query_2

 The following are requirements for the queries in the syntax above:
 The number and the order of the columns must be the same in both queries.
 The data types of the corresponding columns must be the same or compatible.
*/

SELECT DEPT_NO FROM EMPLOYEES
UNION
SELECT DEPT_NO FROM DEPARTMENT

SELECT DEPT_NO FROM EMPLOYEES
UNION
SELECT DEPT_NO FROM DEPARTMENT

SELECT DEPT_NO FROM EMPLOYEES
UNION ALL
SELECT DEPT_NO FROM DEPARTMENT

SELECT * FROM EMPLOYEES

SELECT EMP_NAME, DEPT_NO FROM EMPLOYEES
UNION
SELECT DEPT_NAME , DEPT_NO FROM DEPARTMENT

' UNION WITH WHERE & ORDER BY CLAUSE '
SELECT EMP_NAME, DEPT_NO FROM EMPLOYEES
WHERE EMP_NAME LIKE '%A%'
UNION
SELECT DEPT_NAME , DEPT_NO FROM DEPARTMENT
WHERE DEPT_NAME LIKE '%R%'

SELECT EMP_NAME, DEPT_NO FROM EMPLOYEES
WHERE EMP_NAME LIKE '%A%'
UNION
SELECT DEPT_NAME , DEPT_NO FROM DEPARTMENT
WHERE DEPT_NAME LIKE '%R%'
ORDER BY DEPT_NO

SELECT EMP_NAME, DEPT_NO FROM EMPLOYEES
WHERE DEPT_NO = 20
UNION
SELECT DEPT_NAME , DEPT_NO FROM DEPARTMENT
WHERE DEPT_NO = 20

SELECT EMP_NAME, DEPT_NO FROM EMPLOYEES
UNION ALL
SELECT DEPT_NAME , DEPT_NO FROM DEPARTMENT

' UNION vs. JOIN '
/* The join such as INNER JOIN or LEFT JOIN combines columns from two tables 
while the UNION combines rows from two queries.
EX: C1ID: 1,2,3 & C2ID: 1,2,3,4 => UNION: ID: 1,2,3,4 & INNER JOIN: C1ID: 2, 3  C2ID: 2, 3
*/

-- UNION and ORDER BY
/*SELECT select_list FROM table_1
UNION
SELECT select_list FROM table_2
ORDER BY order_list;

*/

' -- 2. INTERSECT '
/* The SQL Server INTERSECT combines result sets of two or more queries and returns distinct rows 
 that are output by both queries.
 SYNTAX: query_1 INTERSECT query_2

 Similar to the UNION operator, the queries in the syntax above must conform to the following rules:
 Both queries must have the same number and order of columns.
 The data type of the corresponding columns must be the same or compatible.
 EX: T1: 1,2,3 & T2: 2,3,4 => T1INTERSECTT2: 2,3
*/

SELECT DEPT_NO FROM EMPLOYEES
INTERSECT
SELECT DEPT_NO FROM DEPARTMENT

SELECT DEPT_NO FROM EMPLOYEES
INTERSECT
SELECT DEPT_NO FROM DEPARTMENT
ORDER BY DEPT_NO DESC

' -- 3. EXCEPT '
/* The SQL Server EXCEPT compares the result sets of two queries and returns the distinct rows from the first query 
 that are not output by the second query. In other words, the EXCEPT subtracts the result set of a query from another.
 SYNTAX: query_1 EXCEPT query_2

 The following are the rules for combining the result sets of two queries in the above syntax:
 The number and order of columns must be the same in both queries.
 The data types of the corresponding columns must be the same or compatible.
 EX: T1: 1,2,3 & T2: 2,3,4 => T1EXCEPTT2: 1
*/

SELECT DEPT_NO  FROM DEPARTMENT
EXCEPT
SELECT DEPT_NO FROM EMPLOYEES

SELECT DEPT_NO  FROM DEPARTMENT
EXCEPT
SELECT DEPT_NO FROM EMPLOYEES
ORDER BY DEPT_NO

' ------- SECTION-8: END ----------------- '


------------------

SELECT MAX(SAL) FROM EMPLOYEES

SELECT MIN(SAL) FROM EMPLOYEES
WHERE DEPT_NO = 30

SELECT AVG(SAL) FROM EMPLOYEES

SELECT COUNT(SAL) FROM EMPLOYEES

SELECT COUNT(DISTINCT SAL) FROM EMPLOYEES

SELECT COUNT(COMMISSION) FROM EMPLOYEES

SELECT COUNT(DISTINCT COMMISSION) FROM EMPLOYEES

SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME

SELECT * FROM EMPLOYEES
ORDER BY EMP_NAME DESC


SELECT * FROM EMPLOYEES


SELECT * FROM DEPARTMENT
where DEPT_NO = 10

SELECT * FROM DEPARTMENT
where DEPT_NO IN (20,40)

SELECT * FROM DEPARTMENT
where DEPT_NAME like '%AL%' or DEPT_NAME like '%art%'

SELECT * FROM DEPARTMENT
where DEPT_NAME like '[a-o][0-9a-d]%'

SELECT * FROM DEPARTMENT
SELECT * FROM EMPLOYEES

TRUNCATE TABLE DEPARTMENT

TRUNCATE TABLE EMPLOYEES

DROP TABLE IF EXISTS DEPARTMENT
DROP TABLE IF EXISTS EMPLOYEES


-- ---------------------------













