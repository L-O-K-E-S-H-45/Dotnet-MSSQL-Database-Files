
-- Data Manipulation Operations  --> CRUD Operations

-- CREATE
create database DML_Database

USE DML_Database;

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

-- RETRIEVAL
SELECT * FROM DEPARTMENT;

SELECT * FROM DEPARTMENT
where DEPT_NO = 10

SELECT * FROM DEPARTMENT
where DEPT_NO IN (20,40)

SELECT * FROM DEPARTMENT
where DEPT_NAME like '%AL%' or DEPT_NAME like '%art%'

SELECT * FROM DEPARTMENT
where DEPT_NAME like '[a-o][0-9a-d]%'

-- UPDATE
'
UPDATE table_name
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
'

update DEPARTMENT
set DEPT_LOC = 'CANADA'
WHERE DEPT_NO = 20

update DEPARTMENT
set DEPT_LOC = 'UK', DEPT_NAME = 'TRAINER'
WHERE DEPT_NAME = 'OPEARTIONS'

SELECT * FROM DEPARTMENT

INSERT INTO DEPARTMENT 
VALUES (50,'ACCOUNTING_2','NEW YORK_2'),
	(60,'RESEARCH_2','DALLAS_2'),
	(70,'SALES_2','CHICAGO_2')

-- DELETE
' 
DELETE [ TOP ( expression ) [ PERCENT ] ]  
FROM table_name
[WHERE search_condition];
'

DELETE FROM DEPARTMENT
WHERE DEPT_NO > 60

DELETE FROM DEPARTMENT
WHERE DEPT_NAME = 'ACCOUNTING_2'

DELETE FROM DEPARTMENT
WHERE DEPT_NO = 60 AND DEPT_LOC = 'DALLAS_2'

DELETE FROM DEPARTMENT

SELECT * FROM DEPARTMENT

TRUNCATE TABLE DEPARTMENT

DROP TABLE IF EXISTS DEPARTMENT














