
' CURSOR IN SQL SERVER '

/*
Use the SQL Server cursor to process a result set, one row at a time.

SQL works based on set e.g., SELECT statement returns a set of rows which is called a result set. However, sometimes, 
	you may want to process a data set on a row by row basis. This is where cursors come into play.

*/

create database CURSOR_Database;
use CURSOR_Database;

drop database CURSOR_Database

create table Students
    (  
      Id INT ,  
      RollNo INT ,  
      EnrollmentNo NVARCHAR(15) ,  
      Name NVARCHAR(50) ,  
      Branch NVARCHAR(50) ,  
      University NVARCHAR(50)  
    )  

INSERT  INTO Students ( Id, RollNo, EnrollmentNo, Name, Branch, University )  
VALUES  ( 1, 1, N'', N'Nikunj Satasiya', N'CE', N'RK University' ),  
        ( 2, 2, N'', N'Hiren Dobariya', N'CE', N'RK University' ),  
        ( 3, 3, N'', N'Sapna Patel', N'IT', N'RK University' ),  
        ( 4, 4, N'', N'Vivek Ghadiya', N'CE', N'RK University' ),  
        ( 5, 5, N'', N'Pritesh Dudhat', N'CE', N'RK University' ),  
        ( 5, 5, N'', N'Hardik Goriya', N'EC', N'RK University' ),  
        ( 6, 6, N'', N'Sneh Patel', N'ME', N'RK University' )  

select * from Students

declare @Id int,
		@RollNo int,
		@Branch NVARCHAR(50),
		@Year As int;

set @Year = RIGHT(YEAR(getdate()), 2);

declare My_1st_Cursor cursor
for select Id, RollNo, Branch, @Year
	from Students;

open My_1st_Cursor;
fetch next from My_1st_Cursor into @Id, @RollNo, @Branch, @Year;
while @@FETCH_STATUS = 0
begin
	set nocount on
	declare @EnrollmentNo NVARCHAR(15);
	set @EnrollmentNo = 'SOE' + CAST(@Year as nvarchar(2)) + CAST(@Branch as nvarchar(50)) + '000' + CAST(@RollNo AS nvarchar(10));

	update Students set EnrollmentNo = @EnrollmentNo where Id = @Id;

	print cast(@Id as nvarchar(10)) +' ' + cast(@RollNo as nvarchar(10)) +' ' + cast(@Branch as nvarchar(50)) ;

	fetch next from My_1st_Cursor into @Id, @RollNo, @Branch, @Year;
	
end
close My_1st_Cursor
deallocate My_1st_Cursor

--------------------------------

create table Student_details (
	RollNo int not null,
	Student_name varchar(100) not null,
	Class varchar(10),
	Science int not null,
	Math int not null,
	English int not null
	);

select * from Student_details

create proc uspInsertStudentDetails (
	@RollNo int ,
	@Student_name varchar(100),
	@Class varchar(10),
	@Science int,
	@Math int,
	@English int
	)
as 
begin
	insert into Student_details(RollNo,Student_name,Class,Science,Math,English)
		values (@RollNo,@Student_name,@Class,@Science,@Math,@English);
end

drop proc uspInsertStudentDetails

exec uspInsertStudentDetails 1,Anil,'5th', 34, 78, 54

insert into Student_details(RollNo,Student_name,Class,Science,Math,English)
values (2,'Sunil','7th',78,43,87), (3,'Ajay','5th',45,32,78), (4,'Vijay','4th',36,78,72),  (5,'Manoj','5th',12,22,67),
		(6,'Geeta','8th',21,65,43), (7,'Sita','4th',34,78,54), (8,'Reeta','9th',89,78,54), (9,'Arvind','12th',76,78,54), 
		(10,'Kumar','11th',22,56,54)


truncate table Student_details

select * from Student_details

declare @RollNo int,
		@Student_name varchar(50),
		@Science int,
		@Math int,
		@English int;

declare @Total_Marks int,
		@Percentage decimal(5,2);

declare student_details_cursor cursor
for select RollNo,Student_name,Science,Math,English
	from Student_details;

open student_details_cursor;
fetch next from student_details_cursor into @RollNo, @Student_name, @Science, @Math, @English;

while @@FETCH_STATUS = 0
begin
	print concat('RollNo: ',@RollNo);
	print concat('Student_nme: ',@Student_name);
	print concat('Scince: ', @Science);
	print concat('Math: ', @Math);
	print concat('English: ', @English);

	set @Total_Marks = @Science + @Math + @English;
	set @Percentage = @Total_Marks / 3;

	print concat('Total_Marks: ', @Total_Marks);
	print concat('Percentge: ', @Percentage,'%');

	if @Percentage >= 80
		begin
			print 'Grade: A';
		end
	else if @Percentage >= 60 and @Percentage < 80
		begin
			print 'Grade: B';
		end
	else
		begin
			print 'Grade: C';
		end
	Print '====================='

	fetch next from student_details_cursor into @RollNo, @Student_name, @Science, @Math, @English;

end
close student_details_cursor
deallocate student_details_cursor







