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

---2. Total income and Spends

SELECT 
    SUM(c.avg_income) AS Total_Income, 
    SUM(s.spend) AS Total_Spends 
FROM 
    Customers c
JOIN 
    Spends s 
ON 
    c.customer_id = s.customer_id;


	SELECT 
    SUM(CAST(c.avg_income AS DECIMAL(38, 2))) AS Total_Income, 
    SUM(CAST(s.spend AS DECIMAL(38, 2))) AS Total_Spends 
FROM 
    Customers c
JOIN 
    Spends s 
ON 
    c.customer_id = s.customer_id;


select SUM(cast (c.avg_income as bigint)) as Total_income, SUM(cast(s.spend as bigint)) as Total_spends

from Customers c
join
Spends s
on
c.customer_id=s.customer_id;



---3.Total Customers and avg_income by Gender

select gender,COUNT(distinct customer_id) as Total_customers,AVG(avg_income) as Avg_Income
from Customers
group by gender;

---4.Total Customers and avg_income by Marital Status

select marital_status,COUNT(distinct customer_id) as Total_customers,AVG(avg_income) as Avg_Income
from Customers
group by marital_status;

---5.Total Customers and avg_income by Age Group

select age_group,COUNT(distinct customer_id) as Total_customers,AVG(avg_income) as Avg_Income
from Customers 
group by age_group;


----6.Total Customers and Avg_income by city

select city,COUNT(distinct customer_id) as Total_customers,AVG(avg_income) as Avg_Income 
from Customers
group by city;


----7. Total Customers and avg_income by occupation

select occupation,COUNT(distinct customer_id) as Total_customers, AVG(avg_income) as Avg_Income
from Customers
group by occupation
order by Total_customers desc;

----8. Total Customers and avg_income by marital_status

select marital_status,COUNT(distinct customer_id) as Total_customers from Customers
group by marital_status
order by Total_customers
desc;


-----9. Total Average spends

select AVG(spend) as Average_Spend from Spends;

----10. Monthly Total spends and avg spends

select month,SUM(spend) as Total_spends,AVG(spend) as Avg_spends
from Spends
group by month
order by 
case 
when month='May' then 1
when month ='June' then 2
when month = 'July' then 3
when month ='August' then 4
when month ='September' then 5
	 else 6
	 end
	 asc;

------ 11. gender income and spends distribution by month,category,payment type

select c.gender,s.category,s.month,s.payment_type, SUM(c.avg_income) as Total_income ,SUM(s.spend) as Total_spends
from Spends s
join Customers c
on c.customer_id=s.customer_id

group by c.gender,s.category,s.month,s.payment_type
order by 
case
when s.month='May' then 1
when s.month ='June' then 2
when s.month = 'July' then 3
when s.month ='August' then 4
when s.month ='September' then 5
	 else 6
	 end
	 asc;


------12. avg income utilization ratio

select s.month, round(avg(cast(s.spend as decimal)) / avg(cast(c.avg_income as decimal)),2)  as avg_utilization from Spends s
join Customers c on
c.customer_id=s.customer_id
group by s.month
order by 
case
when s.month='May' then 1
when s.month ='June' then 2
when s.month = 'July' then 3
when s.month ='August' then 4
when s.month ='September' then 5
	 else 6
	 end
	 asc;


------13. Min and Max Spend analysis by Category,payment_type

select payment_type,category,min(spend) as Min_spend,max(spend) as Max_Spend from Spends
group by category,payment_type;


-----14. Month wise Min and Max Spends by gender,Occupation and category

select c.gender,c.occupation,s.category,s.month ,MIN(s.spend) as Min_Spends,MAX(s.spend) as Max_Spends from Spends s
join Customers c on c.customer_id=s.customer_id
group by 
c.gender,c.occupation,s.category,s.month
order by 
case
when s.month='May' then 1
when s.month ='June' then 2
when s.month = 'July' then 3
when s.month ='August' then 4
when s.month ='September' then 5
	 else 6
	 end
	 asc;

---- Scenario Based Questions

--•	What is the average income of salaried IT employees in Bengaluru?

select AVG(avg_income)  as Avg_income from Customers
where occupation='Salaried IT Employees' and city='Bengaluru';

--•	Compare the average income of male and female business owners.

select gender,AVG(avg_income) as Avg_income from Customers
group by gender;

--•	What is the total spend on Electronics using UPI payment type?

select SUM(spend) as Total_spends from Spends
where category='Electronics' and payment_type='UPI';

--•	Which category had the highest spend in the month of August?

select top 1 category,MAX(spend) as Max_spends from Spends
where month='August'
group by category
order by Max_spends
desc;

--•	How many single females aged 21-24 are there in the dataset?

select COUNT(distinct customer_id) as Total_customers from Customers
where gender='Female' and marital_status='Single' and age_group='21-24';

--•	Identify the city with the highest number of salaried IT employees.

select top 1 city from Customers
where occupation='Salaried IT Employees'
group by city
order by COUNT(distinct customer_id)
desc;

--•	Is there a correlation between average income and the category of spending? For instance, do higher income groups spend more on health and wellness?

select s.category ,AVG(cast (c.avg_income as bigint)) as avg_income,SUM(cast (s.spend as bigint)) as Total_spends from 
Spends s join Customers c
on c.customer_id=s.customer_id
group by s.category
order by Total_spends
desc;

--•	What is the total spend by customers from Chennai in the month of September?

select SUM(s.spend) as Total_spends from Spends s
join Customers c
on c.customer_id=s.customer_id
where c.city='Chennai' and s.month='September';

--•	How does the spending on travel differ between customers from Mumbai and Hyderabad?

select c.city,SUM(s.spend) as total_spends from Spends s
right join Customers c on c.customer_id=s.customer_id
where c.city in('Mumbai','Hyderabad')
group by c.city;


--•	Which payment type is most commonly used for grocery purchases?

select top 1 payment_type,category ,SUM(spend) as total_spends from  Spends
where category='Groceries'
group by payment_type,category
order by total_spends
desc;

--•	What is the average spend on health and wellness using credit cards?

select AVG(spend) as avg_spends from Spends
where category='Health & Wellness' and payment_type='Credit card';

--•	Which age group spends the most on entertainment?

select top 1 c.age_group,SUM(s.spend) as Total_spends from Spends s
join Customers c on c.customer_id= s.customer_id 
where s.category ='Entertainment'
group by c.age_group
order by Total_spends
desc;

--•	Compare the spending habits on apparel between customers aged 25-34 and those aged 35-45.

select c.age_group,SUM(s.spend) as Total_spends from Spends s join Customers c
on c.customer_id=s.customer_id
where c.age_group in ('25-34','35-45')
group by
c.age_group;

--•	How much do freelancers from Bengaluru spend on health and wellness?

select SUM(s.spend) as Total_Spend from Spends s join Customers c
on c.customer_id=s.customer_id
where c.occupation='Freelancers' and c.city='Bengaluru' and s.category='Health & Wellness';


--•	What is the total spend on groceries by government employees?

select SUM(s.spend) as Total_Spend from Spends s join Customers c
on c.customer_id=s.customer_id
where c.occupation='Government Employees' and s.category='Groceries';


--Identify the month with the highest total spend across all categories.

select top 1 month,category,SUM(spend) as total_spends from Spends
group by month,category
order by total_spends
desc;

--•	Compare the total spends on food for the months of May and July.

select month,category,SUM(spend) as Total_spends from Spends
where month in('May','July') and category='Food'
group by month,category;


--•	What is the average income of married salaried IT employees in Delhi NCR?

select AVG(avg_income) as avg_income from Customers
where city='Delhi NCR' and marital_status='Married' and occupation='Salaried IT Employees';

--Analyze the spending patterns on bills by single customers.

select customer_id, SUM(spend) as Total_spends from Spends
where category='Bills'
group by customer_id
order by Total_spends
desc;

--•	Provide a detailed breakdown of spending by category for customers with an average income above 60,000.

select s.category,SUM(s.spend) as Total_spends  from Spends s join
Customers c on c.customer_id=s.customer_id
where c.avg_income >60000
group by s.category
order by Total_spends
desc;

--What is the total spend on apparel using debit cards?

select SUM(spend) as Total_spend from Spends
where payment_type='Debit card';

--•	Identify the segment of customers (based on age group, occupation, and city) with the highest average income.

select age_group,occupation,city,MAX(avg_income) as Highest_avg_income
from Customers
group by age_group,occupation,city;

--How does the spending on electronics differ between salaried IT employees and business owners?

select c.occupation, SUM(s.spend) as Total_Spend from Spends s join Customers c
on c.customer_id=s.customer_id
where c.occupation in ('Salaried IT employees','Business Owners') and s.category='Electronics'
group by c.occupation;


--Identify any customers whose spending patterns significantly deviate from their average income, possibly indicating fraudulent activity.

select c.customer_id,c.avg_income,SUM(s.spend) as Total_spends from Spends s
join Customers c on c.customer_id=s.customer_id
group by c.customer_id,c.avg_income;

--Are there any instances where customers made unusually high spends in a single month compared to their usual spending habits?

select month,category,MIN(spend) as min_spend,MAX(spend) as Max_spend from Spends
group by month,category
order by 
(case 
when month='May' then 1
when month='June' then 2
when month='July' then 3
when month='August' then 4
when month='September' then 5
else 6
end);


--•	Which customers have high spends on credit cards but low average income, potentially indicating a credit risk?

select c.customer_id,s.payment_type,c.avg_income,sum(s.spend) as spend from Spends s
join Customers c on c.customer_id=s.customer_id
where s.payment_type='Credit card'
group by c.customer_id,s.payment_type,c.avg_income
having 
    SUM(s.spend) > (SELECT AVG(s.spend) FROM Spends s) 
    AND c.avg_income < (SELECT AVG(c.avg_income) FROM customers c)
order by spend
desc;

--•	Are there any customers with consistently high monthly spending on essential categories like groceries and bills, but low average income, indicating potential financial stress?

select c.customer_id,s.category,c.avg_income,sum(s.spend) as spend from Spends s
join Customers c on c.customer_id=s.customer_id
where s.category in ('Bills','Groceries')
group by c.customer_id,s.category,c.avg_income
having 
    SUM(s.spend) > (SELECT AVG(s.spend) FROM Spends s) 
    AND c.avg_income < (SELECT AVG(c.avg_income) FROM customers c where c.avg_income<35000)
order by spend
desc;

--•	Identify high-income customers with low spending on luxury categories like travel and electronics, indicating potential targets for luxury product marketing.

select c.customer_id,s.category ,MAX(c.avg_income) as High_income,SUM(s.spend) as Low_spend from Spends s
join Customers c on c.customer_id=s.customer_id
where s.category in ('Travel','Electronics')
group by c.customer_id,s.category
order by Low_spend
asc;


--•	Which demographic groups (based on age, occupation, and city) have low engagement in certain spending categories that could be targeted for promotional campaigns?

select c.age_group,c.city,c.occupation,s.category ,min(s.spend) as Low_spend from Spends s
join Customers c on c.customer_id=s.customer_id
group by c.age_group,c.city,c.occupation,s.category
order by Low_spend
asc;

--•	Which customers have high spends on non-essential categories (entertainment, apparel) but low average income, indicating a need for financial planning services?

with High_spends_nonessential as (
select customer_id,category,SUM(spend) as High_spend from Spends
 where category in ('Entertainment','Apparel')
 group by customer_id,category )
,low_income_cus as (
select customer_id, avg_income from Customers
where avg_income <(select AVG(avg_income) from Customers)
group by customer_id,avg_income)

select c.customer_id,H.category,c.avg_income,H.High_spend from High_spends_nonessential H 
join Customers c on c.customer_id=H.customer_id
where H.High_spend > (select AVG(High_spend) from High_spends_nonessential)
group by c.customer_id,H.category,c.avg_income,H.High_spend
order by High_spend
desc;

--•	Are there any patterns indicating overspending in certain demographics, suggesting the need for targeted financial literacy programs?

with Demograph_spends as (
select c.age_group,c.Gender,c.city,SUM(s.spend) as Spends from Customers c
join Spends s on c.customer_id=s.customer_id
group by c.age_group,c.Gender,c.city)
, Avg_spending as (
select AVG(spends) as Avg_Spends from Demograph_spends D)
,Over_demographing_spends as (
D.age_group,D.Gender,D.city,D.Spends,A.Avg_Spends from Demograph_spends D join 
 Avg_spending A on D.customer_id=
)


select * from Spends;
select * from Customers;