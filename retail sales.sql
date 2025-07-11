-- create database
create database retail_sales_db;

-- create teble
drop table if exists retail_sales;

create table retail_sales(
	transactions_id int primary key,
	sale_date date ,
	sale_time time,
	customer_id	int ,
    gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float );
    
select * from retail_sales;
select count(*) from retail_sales;
set sql_safe_update = 0;

-- data cleaning

select * from retail_sales
where transactions_id is null
	or sale_date is null
    or sale_time is null
    or customer_id is null
	or gender is null
 	or age is null   
 	or category is null    
	or quantiy is null  
 	or price_per_unit is null     
 	or cogs is null       
 	or total_sale is null;    
    
delete from retail_sales
where transactions_id is null
	or sale_date is null
    or sale_time is null
    or customer_id is null
	or gender is null
 	or age is null   
 	or category is null    
	or quantiy is null  
 	or price_per_unit is null     
 	or cogs is null       
 	or total_sale is null;   
    
-- data exploration

-- how many sales we have ?
select count(total_sale)  as total_sale from retail_sales; 

-- How many uniuque customers we have ?
select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select transactions_id from retail_sales 
where category = 'clothing'
and to_char(sale_date,'YYYY-mm') = '2022-11'
and quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select sum(total_sale) AS total_sales , category from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) from retail_sales
where category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(transactions_id),gender , category 
from retail_sales
group by gender , category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year_,month_,avg_sale from

(select
year(sale_date) as year_,
month(sale_date) as month_,
round(avg(total_sale),2) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rank_ 
from retail_sales
group by 1, 2) as t1
where rank_ = 1;
-- order by 1,3 desc;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of project









		
    