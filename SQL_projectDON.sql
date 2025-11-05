-- Create Table
drop table if exists retail_sales;
create table retail_sales 
		(	
			transactions_id int primary key,
			sale_date date,
			sale_time time,
			customer_id int,
			gender	varchar(15),
			age int,
			category varchar(15),
			quantity int,
			price_per_unit float,	
			cogs float,
			total_sale float,
		);

-- Eliminating Null Values
select * from retail_sales
	where 
		transactions_id is null
		or
		sale_date is null
		or
		sale_time is null
		or
		customer_id is null
		or
		gender is null
		or
		age is null
		or
		category is null
		or 
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null;

-- Delete Null Values

delete from retail_sales
	where
		transactions_id is null
		or
		sale_date is null
		or
		sale_time is null
		or
		customer_id is null
		or
		gender is null
		or
		age is null
		or
		category is null
		or 
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null;

select count(*) from retail_sales;

-- DATA EXPLORATION

-- What is the total number of sales?

select count(total_sale) total_no_of_sales
from retail_sales

-- What is the total number of distinct customers?

select count (distinct customer_id) total_customers
from retail_sales

-- How many distinct category do we have?

select count (distinct category)
from retail_sales

--Data Analysis & Key Business Problems and Answers
-- Q1 Write a SQL Query to retrieve all colomns for sales made on '2022-11-05'

select *
from retail_sales
where sale_date = '2022-11-05';

--Q2 Write a SQL Query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where category = 'clothing' 
and
quantiy >= 4
and
  FORMAT(sale_date, 'yyyy-MM') = '2022-11';

--Q3 Write an SQL Query to calculate the total sale for each category

select category,
	sum(total_sale) total_sale,
	count(*) total_orders
from retail_sales
group by category;

--Q4 Write an SQL Query to calculate the average age of customers who purchased items from the 'Beauty'category

select avg(age) av_age
from retail_sales
where category = 'Beauty';

--Q5 Write an SQL Query to find all transactions where the total sale is greater than 1000

select *
from retail_sales
where total_sale > 1000

--Q6 Write an SQL Query to find the total number of transactions made by each gender in each category

select count(transactions_id) total_transactions, gender, category
from retail_sales
group by gender, category
order by category

--Q7 Write an SQL Query to calculate the average sale for each month. Find out the best selling month in each year

select 
		year,
		month,
		average_sale
from
(
	select
		DATEPART(YEAR, sale_date) year,
		DATEPART(MONTH, sale_date) month,
		avg(total_sale) average_sale,
		RANK() OVER (PARTITION BY DATEPART(YEAR, sale_date) ORDER BY avg(total_sale) DESC) rank
	from retail_sales
	group by YEAR(sale_date), MONTH(sale_date)
) as T1
where rank = 1

--Q8 Write an SQL Query to find the top 5 customers based on the highest total sales

select distinct top 5 customer_id, sum(total_sale) total_sale
from retail_sales
group by customer_id
order by total_sale desc

--Q9 Write an SQL Query to find the number of unique customers who purchased items from each category

select count(distinct customer_id) distinct_customer, 
category
from retail_sales
group by category

--Q10 Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with day_sales
as
(
select *,
	case
		when DATEPART(HOUR, sale_time) < 12 then 'morning'
		when DATEPART(HOUR, sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end shifts
from retail_sales
)
select
	shifts,
	count(*) total_orders
from day_sales
group by shifts

-- End of project