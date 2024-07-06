


use JOINS_Database

'------------------------ Joins Revision  -------------------------------'
--- 1st Problem
--E-commerce application: In an e-commerce application, you could use a join to retrieve the order details and 
--customer information for a specific order. For example, you could join the orders table with the 
--customers table on the customer ID to get the customer's name, address, and contact information for the order.

create table Customers (
    CustomerID int primary key identity,
    CustomerName varchar(100) not null,
    Address varchar(255) not null,
    ContactNumber varchar(15) not null,
    Email varchar(100)
);

create table Orders (
    OrderID int primary key identity,
    OrderDate date NOT NULL,
    CustomerID int foreign key references Customers(CustomerID),
    TotalAmount decimal(10, 2) NOT NULL,
    Status varchar(50) NOT NULL,
);

INSERT INTO Customers (CustomerName, Address, ContactNumber, Email) VALUES
('John Doe', '123 Maple Street, Springfield', '555-1234', 'johndoe@example.com'),
('Jane Smith', '456 Oak Avenue, Springfield', '555-5678', 'janesmith@example.com'),
('Alice Johnson', '789 Pine Road, Springfield', '555-8765', 'alicej@example.com'),
('Bob Brown', '321 Birch Lane, Springfield', '555-4321', 'bobbrown@example.com'),
('Charlie Davis', '654 Cedar Street, Springfield', '555-1357', 'charlied@example.com'),
('Diana Evans', '987 Willow Way, Springfield', '555-2468', 'dianaevans@example.com'),
('Evan Foster', '147 Elm Street, Springfield', '555-3699', 'evanfoster@example.com'),
('Fiona Green', '258 Hickory Boulevard, Springfield', '555-2580', 'fionagreen@example.com'),
('George Hill', '369 Palm Avenue, Springfield', '555-1470', 'georgehill@example.com'),
('Hannah Irwin', '741 Aspen Drive, Springfield', '555-7530', 'hannahirwin@example.com');


INSERT INTO Orders (OrderDate, CustomerID, TotalAmount, Status) VALUES
('2024-05-01', 1, 250.50, 'Shipped'),
('2024-05-6', 2, 150.75, 'Processing'),
('2024-05-13', 3, 300.20, 'Delivered'),
('2024-05-16', 4, 100.00, 'Cancelled'),
('2024-05-17', 6, 100.00, 'Cancelled'),
('2024-05-17', 8, 100.00, 'Cancelled'),
('2024-05-18', 9, 100.00, 'Cancelled'),
('2024-05-21', 5, 100.00, 'Cancelled'),
('2024-05-24', 10, 100.00, 'Cancelled'),
('2024-05-26', 7, 100.00, 'Cancelled'),
('2024-06-04', 1, 250.50, 'Shipped'),
('2024-06-08', 2, 150.75, 'Processing'),
('2024-06-15', 3, 300.20, 'Delivered'),
('2024-06-18', 4, 100.00, 'Cancelled'),
('2024-06-20', 5, 50.25, 'Returned'),
('2024-06-24', 6, 200.10, 'Shipped'),
('2024-07-01', 7, 175.30, 'Processing'),
('2024-07-02', 8, 400.00, 'Delivered'),
('2024-07-04', 9, 220.75, 'Shipped'),
('2024-07-5', 10, 125.40, 'Processing');

select * from Customers
select * from Orders

select o.OrderID, o.OrderDate, o.TotalAmount, o.Status, o.CustomerID,
c.CustomerName, c.ContactNumber, c.Address
from Orders o join Customers c
on o.CustomerID = c.CustomerID
order by c.CustomerID

---------------------------
--- 2nd Problem
--Healthcare application: In a healthcare application, you could use a join to retrieve the patient information and
--medical history for a specific appointment. For example, you could join the appointments table with the patients table 
--and the medical history table on the patient ID to get the patient's name, age, medical conditions, and previous treatments.

create table Patients (
    PatientID INT PRIMARY KEY identity,
    PatientName VARCHAR(100),
    PatientAge INT,
    PatientEmail VARCHAR(100),
    PatientPhone VARCHAR(15),
    PatientAddress VARCHAR(255)
);

create table Appointments (
    AppointmentID int primary key identity,
    AppointmentDate date,
    PatientID int,
    DoctorName varchar(100),
    Department varchar(50),
    foreign key(PatientID) references Patients(PatientID)
);

create table MedicalHistory (
    HistoryID INT identity PRIMARY KEY,
    PatientID int,
    Condition varchar(255),
    Treatment varchar(255),
    TreatmentDate date,
    foreign key(PatientID) references Patients(PatientID)
);

INSERT INTO Patients (PatientName, PatientAge, PatientEmail, PatientPhone, PatientAddress)
VALUES
('John Doe', 45, 'john.doe@example.com', '123-456-7890', '123 Elm St, Springfield, IL, 62701'),
('Jane Smith', 38, 'jane.smith@example.com', '987-654-3210', '456 Oak St, Metropolis, NY, 10001'),
('Michael Brown', 29, 'michael.brown@example.com', '555-555-5555', '789 Pine St, Gotham, NJ, 07001'),
('Emily Davis', 50, 'emily.davis@example.com', '111-222-3333', '101 Maple St, Smallville, KS, 66002'),
('David Wilson', 55, 'david.wilson@example.com', '444-444-4444', '202 Birch St, Star City, CA, 90001'),
('Sarah Johnson', 42, 'sarah.johnson@example.com', '666-777-8888', '303 Cedar St, Central City, OH, 43001'),
('Chris Lee', 36, 'chris.lee@example.com', '777-888-9999', '404 Walnut St, Coast City, FL, 33001'),
('Anna Martinez', 47, 'anna.martinez@example.com', '888-999-0000', '505 Spruce St, Bludhaven, PA, 19001'),
('James Taylor', 62, 'james.taylor@example.com', '999-000-1111', '606 Chestnut St, Keystone City, TX, 75001'),
('Laura Anderson', 33, 'laura.anderson@example.com', '000-111-2222', '707 Ash St, Fawcett City, MA, 02001');

INSERT INTO Appointments (AppointmentDate, PatientID, DoctorName, Department)
VALUES
('2023-06-01', 6, 'Dr. Smith', 'Cardiology'),
('2023-06-02', 9, 'Dr. Johnson', 'Neurology'),
('2023-06-03', 1, 'Dr. Lee', 'Orthopedics'),
('2023-06-03', 8, 'Dr. Johnson', 'Neurology'),
('2023-06-04', 4, 'Dr. Brown', 'Dermatology'),
('2023-06-05', 2, 'Dr. Davis', 'Pediatrics'),
('2023-06-06', 7, 'Dr. Wilson', 'Oncology'),
('2023-06-07', 5, 'Dr. Martinez', 'Gastroenterology'),
('2023-06-08', 10, 'Dr. Taylor', 'Cardiology'),
('2023-06-08', 2, 'Dr. Davis', 'Pediatrics'),
('2023-06-09', 9, 'Dr. Anderson', 'Endocrinology'),
('2023-06-10', 8, 'Dr. Johnson', 'Neurology');

INSERT INTO MedicalHistory (PatientID, Condition, Treatment, TreatmentDate)
VALUES
(1, 'Hypertension', 'Medication', '2020-05-01'),
(2, 'Migraine', 'Pain Relief', '2019-08-15'),
(3, 'Fracture', 'Surgery', '2021-02-10'),
(4, 'Eczema', 'Topical Cream', '2022-03-25'),
(5, 'Asthma', 'Inhaler', '2018-11-05'),
(6, 'Breast Cancer', 'Chemotherapy', '2017-06-12'),
(7, 'Ulcerative Colitis', 'Medication', '2021-09-30'),
(8, 'Arrhythmia', 'Pacemaker', '2020-12-22'),
(9, 'Diabetes', 'Insulin', '2016-04-14'),
(10, 'Multiple Sclerosis', 'Physical Therapy', '2019-07-19');

select * from Patients
select * from Appointments
select * from MedicalHistory

select a.AppointmentDate, a.AppointmentDate, 
p.PatientID, p.PatientName, p.PatientAge, p.PatientPhone, p.PatientEmail, p.PatientAddress,
mh.Condition, mh.Treatment, mh.TreatmentDate, a.DoctorName, a.Department
from Appointments a
join Patients p on a.PatientID = p.PatientID
join MedicalHistory mh on mh.PatientID = a.PatientID
order by PatientID

------------------------------------------------
--------- 3rd Problem
--Banking application: In a banking application, you could use a join to retrieve the account details and transaction history 
--for a specific customer. For example, you could join the customers table with the accounts table and the transactions table
--on the account ID to get the account balance, transaction dates, and amounts for the customer's account.

-- I am using alreadt created Customers table

create table Accounts (
    Account_id int primary key identity,
    CustomerId int not null,
	BankName varchar(100) not null,
	AccountNo bigint not null,
	IFSC varchar(100) not null,
	Branch varchar(100) not null,
    Balance decimal(10, 2) not null,
	constraint chk_balance check(Balance >= 0),
    foreign key (CustomerID) references Customers(CustomerID)
);

create table Transactions(
    Transaction_id int primary key identity,
    Account_id int not null,
    Transaction_date datetime default getdate(),
	Old_balance decimal(10,2) not null,
	constraint chk_old_balance check(Old_balance >= 0),
    Transaction_amount decimal(10, 2) not null,
	constraint chk_transaction_amount check(Transaction_amount > 0),
    Transaction_type varchar(50) not null,
	constraint chk_transaction_type check(Transaction_type in ('Credit', 'Debit')),
	Final_balance decimal(10,2) not null,
	constraint chk_final_balance check(Final_balance >= 0),
    foreign key (account_id) references accounts(account_id)
)

---- We can make this table as Audit Table & use triggers
--create table TransactionsHistory (
--    Transaction_id int not null,
--    Account_id int not null,
--    Transaction_date datetime not null,
--	Old_balance decimal(10,2) not null,
--	constraint chk_old_balance check(Old_balance >= 0),
--    Transaction_amount decimal(10, 2) not null,
--	Final_balance decimal(10,2) not null,
--	constraint chk_final_balance check(Final_balance >= 0),
--    Transaction_type varchar(50) not null
--);

create or alter proc usp_InsertTransaction(
@Account_id int,
@Transaction_amount decimal(10, 2),
@Transaction_type varchar(50)
)
as
begin
	set nocount on;

	declare @ErrorMessage nvarchar(max);
	declare @ErrorStatus int;
	declare @ErrorSeverity int;
	set @ErrorSeverity = 16;
	set @ErrorStatus = 1;
	begin try

	if (@Account_id is null or @Account_id = 0 or not exists(select 1 from Accounts where Account_id = @Account_id))
	begin
		SET @ErrorMessage = FORMATMESSAGE('Invalid Account id: %d', @Account_id);
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorStatus);
        RETURN;
	end
	if (@Transaction_amount is null or @Transaction_amount <= 0)
	begin
		SET @ErrorMessage = FORMATMESSAGE('Transaction_amount should be > 0');
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorStatus);
        RETURN;
	end 
	if (@Transaction_type not in ('Credit', 'Debit'))
	begin
		SET @ErrorMessage = FORMATMESSAGE('Invalid Transaction_type : '+ @Transaction_type);
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorStatus);
        RETURN;
	end

		declare @CurrentBalance decimal(10,2);
		declare @FinalBalance decimal(10,2);

		select @CurrentBalance = Balance from Accounts where Account_id = @Account_id;
				
		if (@Transaction_type = 'Debit')
		begin
			if (@Transaction_amount > @CurrentBalance)
	 		begin
				SET @ErrorMessage = FORMATMESSAGE('Transaction failed due to insufficient balance');
				RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorStatus);
				RETURN;
			end
			else
			begin
				set @FinalBalance = @CurrentBalance - @Transaction_amount
				update Accounts set Balance = @FinalBalance where Account_id = @Account_id;
			end
		end
		else if (@Transaction_type = 'Credit')
		begin
		set @FinalBalance = @CurrentBalance + @Transaction_amount;
			update Accounts set Balance = @FinalBalance where Account_id = @Account_id;
		end

		insert into Transactions(Account_id, Old_balance, Transaction_amount, Transaction_type, Final_balance)
				values (@Account_id, @CurrentBalance, @Transaction_amount, @Transaction_type, @FinalBalance);
		
	end try
	begin catch
		throw;
	end catch
end




















