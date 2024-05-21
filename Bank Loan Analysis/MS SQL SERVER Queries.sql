create database Bankloan_DB;
use bankloan_db;
select * from financial_loan;

--KPI's Queries
---1.Total Applications 
select count(id) As Total_applications 
from financial_loan;

---Month-To-Date Total_Applications
select count(id) as MTD_Totalapplications from financial_loan
where month(issue_date)=12 and year(issue_date)=2021;
---PMTD-Total Applications
select count(id) as PMTD_Totalapplications from financial_loan
where month(issue_date)=11 and year(issue_date)=2021;

---2.Total Funded Amount
select sum(loan_amount) as Total_fundedAmount from financial_loan;

---MTD_Total Funded Amount 
select sum(loan_amount) as MTD_Total_fundedamount from financial_loan
where month(issue_date) =12 and year(issue_date) =2021;

---PMTD_Total Funded Amount
select sum(loan_amount) as PMTD_Total_fundedamount from financial_loan
where month(issue_date) =11 and year(issue_date) =2021;

---3.Total Amount Received
select sum(total_payment) as Total_amountreceived from financial_loan;

---MTD Total amount Received
select sum(total_payment) as MTD_Total_amountreceived from financial_loan
where month(issue_date) =12 and year(issue_date) =2021;

---PMTD Total amount Received
select sum(total_payment) as PMTD_Total_amountreceived from financial_loan
where month(issue_date) =11 and year(issue_date) =2021;


---4.Average Interest Rate
select round(avg(int_rate),4)*100 as Avg_interestrate from financial_loan;

---MTD_Avg Interest rate
select round(avg(int_rate),4)*100 as MTD_Avg_interestrate from financial_loan
where month(issue_date) =12 and year(issue_date) =2021;

---PMTD_Avg Interest rate

select round(avg(int_rate),4)*100 as PMTD_Avg_interestrate from financial_loan
where month(issue_date) =11 and year(issue_date) =2021;


---5.Average Debt-To-Income Ratio(DTI)
select round(avg(dti),5)*100 as Avg_DTI from financial_loan;

---MTD Average Debt-To-Income Ratio
select round(avg(dti),5)*100 as MTD_Avg_DTI from financial_loan
where month(issue_date) =12 and year(issue_date) =2021;

---PMTD Average Debt-To-Income Ratio
select round(avg(dti),5)*100 as PMTD_Avg_DTI from financial_loan
where month(issue_date) =11 and year(issue_date) =2021;


select loan_status from financial_loan;

--GOOD LOAN VS BAD LOAN KPI's

--GOOD LOAN KPI's
---1.Good Loan Application Percentage

select 
(count(case when loan_status ='Fully Paid' or loan_status ='Current' Then id end) *100)
/
count(id) as Good_loanpercentage from financial_loan;

---2.Good Loan Applications

select count(id) As Good_loanapplications from financial_loan where
loan_status in('Fully Paid','Current');

---3.Good Loan Founded Amount

select sum(loan_amount) as Good_loan_Foundedamount from financial_loan where
loan_status in('Fully Paid','Current');

---4.Good Loan Total Received amount

select sum(total_payment) as Good_loan_TotalReceivedamount from financial_loan where
loan_status in('Fully Paid','Current');

--BAD LOAN KPI's

---1.Bad Loan Application Percentage

select 
(count(case when loan_status ='Charged off' Then id end) *100)
/
count(id) as Bad_loanpercentage from financial_loan;

---2.Bad Loan Applications

select count(id) As Bad_loanapplications from financial_loan where
loan_status ='Charged off';

------3.Good Loan Founded Amount

select sum(loan_amount) as Bad_loan_Foundedamount from financial_loan where
loan_status ='Charged off';

---4.Good Loan Total Received amount

select sum(total_payment) as Bad_loan_TotalReceivedamount from financial_loan where
loan_status ='Charged off';


--Loan Status Grid View
select * from financial_loan;

select loan_status,
count(id) as Total_loan_applications,sum(total_payment) as Total_amountreceived,
sum(loan_amount) as Total_fundedamount,avg(int_rate) as Interest_rate,
avg(dti*100) as DTI from financial_loan
group by Loan_status;

---MTD Loan Status Grid View

select loan_status,sum(total_payment) as MTD_Total_Amountreceived,
sum(loan_amount) as MTD_Total_Fundedamount from financial_loan
where month(issue_date) =12
group by Loan_status;

---PMTD Loan status Grid View 

select loan_status,sum(total_payment) as PMTD_Total_Amountreceived,
sum(loan_amount) as PMTD_Total_Fundedamount from financial_loan
where month(issue_date) =11
group by Loan_status;


--Charts Queries

select * from financial_loan;

---1.Monthly Trends By Issue Date

select month(issue_date) as Month_number,datename(month ,issue_date)as Month_name,
count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,sum(loan_amount) as Total_fundedamount
from financial_loan group by datename(month,issue_date),month(issue_date)
order by month(issue_date);


---2. Regional Analysis by State 

select Address_state as State,
count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,sum(loan_amount) as Total_fundedamount
from financial_loan group by Address_state
order by sum(loan_amount) desc;


---3. Loan Term Analysis 

select term as Term,
count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,
sum(loan_amount) as Total_fundedamount
from financial_loan group by term
order by term;

---4. Employee Length Analysis 

select emp_length as Employee_Length ,count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,sum(loan_amount) as Total_fundedamount
from financial_loan group by emp_length
order by emp_length;


---5. Loan Purpose Breakdown 

select purpose ,count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,sum(loan_amount) as Total_fundedamount
from financial_loan group by purpose
order by count(id) desc;

---6.Home Ownership Analysis

select home_ownership ,count(id) as Total_loanApplications,
sum(total_payment) as Total_amountreceived,sum(loan_amount) as Total_fundedamount
from financial_loan group by home_ownership
order by count(id) desc;

---Grid View

select * from financial_loan;

