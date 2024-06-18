create database Financial;
use Financial;

create table Customers(customer_id varchar(50),age_group int,city varchar(20),occupation varchar(50),gender varchar(10),
marital_status varchar(20),avg_income int);

alter table Customers alter column age_group varchar(10);
bulk insert Customers 
from 'D:\Data Analysis\Profile Projects\Financial Analysis\Credit Card Analysis\Data set\dim_customers.csv'
with (
format='csv',
fieldterminator = ',',
rowterminator = 'oxoa',
firstrow = 2
);

BULK INSERT Customers
FROM 'D:\Data Analysis\Profile Projects\Financial Analysis\Credit Card Analysis\Data set\dim_customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

select * from Customers;

create table Spends(customer_id varchar(50),month varchar(20),category varchar(50),payment_type varchar(20),
spend int);

bulk insert Spends
from 'D:\Data Analysis\Profile Projects\Financial Analysis\Credit Card Analysis\Data set\fact_spends.csv'

with (
format='csv',
fieldterminator=',',
rowterminator='\n',
firstrow=2
);

select * from Spends;

---1.Total Customers 

select COUNT(distinct customer_id) as Total_Customers 
from Customers;

---2. Total Spends

select SUM(spend) as Total_Spends from Spends;

---3.