
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
/*  -- use the SQL Server GROUPING SETS to generate multiple grouping sets.
 A grouping set is a group of columns by which you group. Typically, a single query with an 
 aggregate defines a single grouping set.
	
EX: SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

SELECT * FROM  sales.sales_summary
ORDER BY brand, category, model_year;

EX-2: The following query defines a grouping set that includes brand and category
which is denoted as (brand, category). The query returns the sales amount grouped by brand and category:
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    category
ORDER BY
    brand,
    category;

EX-3: The following query returns the sales amount by brand. It defines a grouping set (brand):
SELECT brand, SUM (sales) sales FROM sales.sales_summary
GROUP BY brand ORDER BY brand;

EX-4: The following query defines an empty grouping set (). It returns the sales amount for all brands and categories.
SELECT SUM (sales) sales FROM sales.sales_summary;

The four queries above return four result sets with four grouping sets:

(brand, category)
(brand)
(category)
()


Home » SQL Server GROUPING SETS

SQL Server GROUPING SETS
Summary: in this tutorial, you will learn how to use the SQL Server GROUPING SETS to generate multiple grouping sets.

Setup a sales summary table
Let’s create a new table named sales.sales_summary for the demonstration.

SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;
Code language: SQL (Structured Query Language) (sql)
In this query, we retrieve the sales amount data by brand and category and populate it into the sales.sales_summary table.

The following query returns data from the sales.sales_summary table:

SELECT
	*
FROM
	sales.sales_summary
ORDER BY
	brand,
	category,
	model_year;
Code language: SQL (Structured Query Language) (sql)
SQL Server GROUPING SETS - UNION ALL
Getting started with SQL Server GROUPING SETS
By definition, a grouping set is a group of columns by which you group. Typically, a single query with an aggregate defines a single grouping set.

For example, the following query defines a grouping set that includes brand and category which is denoted as (brand, category). The query returns the sales amount grouped by brand and category:

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    category
ORDER BY
    brand,
    category;
Code language: SQL (Structured Query Language) (sql)

The following query returns the sales amount by brand. It defines a grouping set (brand):

SELECT
    brand,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand
ORDER BY
    brand;
Code language: SQL (Structured Query Language) (sql)
SQL Server GROUPING SETS by brand
The following query returns the sales amount by category. It defines a grouping set (category):

SELECT
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    category
ORDER BY
    category;
Code language: SQL (Structured Query Language) (sql)
SQL Server GROUPING SETS by brand
The following query defines an empty grouping set (). It returns the sales amount for all brands and categories.

SELECT
    SUM (sales) sales
FROM
    sales.sales_summary;
Code language: SQL (Structured Query Language) (sql)

The four queries above return four result sets with four grouping sets:

(brand, category)
(brand)
(category)
()

To get a unified result set with the aggregated data for all grouping sets, you can use the UNION ALL operator.

Because UNION ALL operator requires all result sets to have the same number of columns, 
you need to add NULL to the select list of the queries like this:

SELECT brand, category, SUM (sales) sales FROM sales.sales_summary
GROUP BY brand, category
UNION ALL
SELECT brand, NULL, SUM (sales) sales FROM sales.sales_summary
GROUP BY brand
UNION ALL
SELECT NULL,  category, SUM (sales) sales FROM sales.sales_summary
GROUP BY category
UNION ALL
SELECT NULL, NULL, SUM (sales) FROM sales.sales_summary
ORDER BY brand, category;

The query generated a single result with the aggregates for all grouping sets as we expected.

However, it has two major problems:

The query is quite lengthy.
The query is slow because the SQL Server needs to execute four subqueries and combine the result sets into a single one.
To fix these problems, SQL Server provides a subclause of the GROUP BY clause called GROUPING SETS.

The GROUPING SETS defines multiple grouping sets in the same query. The following shows the general syntax of the GROUPING SETS:

SELECT
    column1,
    column2,
    aggregate_function (column3)
FROM
    table_name
GROUP BY
    GROUPING SETS (
        (column1, column2),
        (column1),
        (column2),
        ()
);
Code language: SQL (Structured Query Language) (sql)
This query creates four grouping sets:

(column1,column2)
(column1)
(column2)
()

EX-5:
*/

 ' -- 4. CUBE '
 /* Use the SQL Server CUBE to generate multiple grouping sets.

 Grouping sets specify groupings of data in a single query. For example, the following query defines 
 a single grouping set represented as (brand):
SELECT 
    brand, 
    SUM(sales)
FROM 
    sales.sales_summary
GROUP BY 
    brand;

The CUBE is a subclause of the GROUP BY clause that allows you to generate multiple grouping sets. 

The following illustrates the general syntax of the CUBE:
SELECT
    d1,
    d2,
    d3,
    aggregate_function (c4)
FROM
    table_name
GROUP BY
    CUBE (d1, d2, d3);

In this syntax, the CUBE generates all possible grouping sets based on the dimension columns d1, d2, and d3 that you specify in the CUBE clause.

The above query returns the same result set as the following query, which uses the  GROUPING SETS:

SELECT
    d1,
    d2,
    d3,
    aggregate_function (c4)
FROM
    table_name
GROUP BY
    GROUPING SETS (
        (d1,d2,d3), 
        (d1,d2),
        (d1,d3),
        (d2,d3),
        (d1),
        (d2),
        (d3), 
        ()
     );
Code language: SQL (Structured Query Language) (sql)
If you have N dimension columns specified in the CUBE, you will have 2N grouping sets.

It is possible to reduce the number of grouping sets by using the CUBE partially as shown in the following query:

SELECT
    d1,
    d2,
    d3,
    aggregate_function (c4)
FROM
    table_name
GROUP BY
    d1,
    CUBE (d2, d3);
Code language: SQL (Structured Query Language) (sql)
In this case, the query generates four grouping sets because there are only two dimension columns specified in the CUBE.

SQL Server CUBE examples
The following statement uses the CUBE to generate four grouping sets:

(brand, category)
(brand)
(category)
()
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    CUBE(brand, category);

In this example, we have two dimension columns specified in the CUBE clause, therefore, we have a total of four grouping sets.

The following example illustrates how to perform a partial CUBE to reduce the number of grouping sets generated by the query:

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    CUBE(category);

 */
	
 ' -- 5. ROLLUP '
 /* Use the SQL Server ROLLUP to generate multiple grouping sets.
 The SQL Server ROLLUP is a subclause of the GROUP BY clause which provides a shorthand for defining multiple grouping sets.

Unlike the CUBE subclause, ROLLUP does not create all possible grouping sets based on the dimension columns; the CUBE makes a subset of those.

When generating the grouping sets, ROLLUP assumes a hierarchy among the dimension columns and only generates grouping sets based on this hierarchy.

The ROLLUP is often used to generate subtotals and totals for reporting purposes.

Let’s consider an example. The following CUBE (d1,d2,d3) defines eight possible grouping sets:

(d1, d2, d3)
(d1, d2)
(d2, d3)
(d1, d3)
(d1)
(d2)
(d3)
()

And the ROLLUP(d1,d2,d3) creates only four grouping sets, assuming the hierarchy d1 > d2 > d3, as follows:

(d1, d2, d3)
(d1, d2)
(d1)
()

The ROLLUP is commonly used to calculate the aggregates of hierarchical data such as sales by year > quarter > month.

SQL Server ROLLUP syntax
The general syntax of the SQL Server ROLLUP is as follows:

SELECT
    d1,
    d2,
    d3,
    aggregate_function(c4)
FROM
    table_name
GROUP BY
    ROLLUP (d1, d2, d3);

In this syntax, d1, d2, and d3 are dimension columns. The statement will calculate the aggregation of values 
in the column c4 based on the hierarchy d1 > d2 > d3.

You can also do a partial roll-up to reduce the subtotals generated by using the following syntax:

SELECT
    d1,
    d2,
    d3,
    aggregate_function(c4)
FROM
    table_name
GROUP BY
    d1, 
    ROLLUP (d2, d3);

SQL Server ROLLUP examples
We will reuse the sales.sales_summary table created in the GROUPING SETS tutorial for the demonstration. 
If you have not created the sales.sales_summary table, you can use the following statement to create it.

SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

The following query uses the ROLLUP to calculate the sales amount by brand (subtotal) and both brand and category (total).

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP(brand, category);

SQL Server ROLLUP example
In this example, the query assumes that there is a hierarchy between brand and category, which is the brand > category.

Note that if you change the order of brand and category, the result will be different as shown in the following query:

SELECT
    category,
    brand,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP (category, brand);
Code language: SQL (Structured Query Language) (sql)
In this example, the hierarchy is the brand > segment:

SQL Server ROLLUP example 2
The following statement shows how to perform a partial roll-up:

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    ROLLUP (category);

 */


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

SELECT DEPT_NO  FROM EMPLOYEES
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













