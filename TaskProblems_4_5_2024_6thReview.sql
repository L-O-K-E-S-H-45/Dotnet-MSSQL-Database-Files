
' TaskProblems 4_5_2024 6th Review '

create database TaskProblems_Database_4_5_2024_6thReview;

-- Problem-1
/* 
1) create a procedure , check id of user. if exist update the data else insert the data
*/
create table students ( 
	s_id int primary key identity,
	s_name varchar(100) not null,
	s_email varchar(50),
	);

insert into students(s_name, s_email) 
values('Tom', 'tom123@gmail.com'), ('Scott', 'scot123@gmail.com');

select * from students;

select COUNT(*) from students where s_id = 1;

--declare @c int;
--select @c= COUNT(*) from students where s_id = 1
----select @c as cc
--begin
--if(COUNT(@c) = 1)
--print 'Stident exists'
--else
--print 'hjc'
--end

create procedure ModifyStudents (
	@s_id int,
	@s_name varchar(50),
	@s_email varchar(50)
	)
as
begin
	set nocount on;
	 if exists (select 1 from students where s_id = @s_id)
	--if ((select COUNT(*) from students where s_id = @s_id) = 1)
		begin
			update students set s_name = @s_name, s_email = @s_email where s_id = @s_id;
			print 'Student updated';
		end
	else
		begin
		insert into students(s_name, s_email) values (@s_name, @s_email);
		print 'Student inserted';
		end
end

drop proc ModifyStudents

exec ModifyStudents 5,'Smith', 'smith123@gmail.com'

select * from students

exec ModifyStudents 7,'Allen', 'allen123@gmail.com'

-- Problem-2
/*
2) perform any one type of trigger on table of your choice
*/

create table AuditTable_Students(
	s_id int ,
	s_name varchar(100),
	s_email varchar(100),
	operation varchar(10),
	updated_at datetime,
	);
	

create trigger trgAfter_Students
on students
after insert, delete
as
begin
	set nocount on;

	--declare @id int,
	--		@name varchar(100),
	--		@email varchar(100);
	
	insert into AuditTable_Students(s_id, s_name, s_email, operation, updated_at)
	select i.s_id, i.s_name, i.s_email , 'inserted', GETDATE()
	from inserted i
	union all
	select d.s_id, d.s_name, d.s_email , 'deleted', GETDATE()
	from deleted d;
end

--Create Trigger trg_AuditUserUpdate
--On Users
--After Update
--As
--Begin
--    Insert Into UsersAuditTable (UserId, OldData, NewData)
--    select deleted.UserId, deleted.UserData, inserted.UserData
--    from inserted
--    inner join deleted on inserted.UserId = deleted.UserId;
--end

select * from AuditTable_Students;
select * from students;

insert into students(s_name, s_email) 
values('Miller', 'miller123@gmail.com')

delete from students where s_id = 4

-- Problem-3
/*
3) Consider three tables, Employees with columns EmployeeID, FirstName, LastName, Projects with columns ProjectID and ProjectName, 
	and Assignments with columns AssignmentID, EmployeeID, and ProjectID. Write SQL queries to:
Retrieve a list of all employees with their corresponding assigned projects.
Select employees along with the project information for a specific project.
*/

create table Employees (
	EmployeeID int primary key identity, 
	FirstName varchar(100) not null, 
	LastName varchar(100) not null
	);

create table Projects (
	ProjectID int primary key identity, 
	ProjectName varchar(100) not null, 
	);

create table Assignments (
	AssignmentID int primary key identity, 
	EmployeeID int Foreign key(EmployeeID) references Employees(EmployeeID),
	ProjectID int Foreign key(ProjectID) references Projects(ProjectID)
	);

insert into Employees(FirstName,LastName)
values ('Tom', 'S'),('Allen', 'C'),('Smith', 'R'),('Clark', 'E');

select * from Employees;

insert into Projects(ProjectName)
values ('Project-1'),('Project-2'),('Project-3'),('Project-4'),('Project-5'),('Project-6');

select * from Projects;

insert into Assignments (EmployeeID, ProjectID)
values (1,2),(2,3),(1,4),(3,1),(2,5);

select * from Assignments;

select e.EmployeeID, e.FirstName, e.LastName, p.ProjectName
from Employees e
inner join Assignments a on a.EmployeeID = e.EmployeeID
inner join Projects p on p.ProjectID = a.ProjectID
order by e.EmployeeID 

select e.EmployeeID, e.FirstName, e.LastName,p.ProjectID, p.ProjectName
from Employees e
inner join Assignments a on a.EmployeeID = e.EmployeeID
inner join Projects p on p.ProjectID = a.ProjectID
where p.ProjectID = 2

-- Problem-4
/*
4)Consider a table named Students with columns StudentID, FirstName, LastName, Address, PhoneNumber, and DateOfBirth.
normalize it
*/

create table AddressType(
	address_type_id int primary key identity,
	address_type varchar,
	constraint chk_address_type check(address_type in ('local', 'permanent'))
	)

create table Address (
	address_id int primary key identity,
	address varchar(max) not null,
	PhoneNumber bigint not null check(PhoneNumber >= 6000000000 and PhoneNumber >= 9999999999),
	StudentID int Foreign key(StudentID) references student(StudentID),
	address_type_id int Foreign key(address_type_id) references student(address_type_id)
	)

create table student (
	StudentID int primary key identity,
	FirstName varchar(100) not null,
	LastName varchar(100),
	DateOfBirth date,
	address_id int Foreign key(address_id) references Address(address_id)
	)


