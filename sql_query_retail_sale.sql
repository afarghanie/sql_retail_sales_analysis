--- Creating Table and Column
CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--- Data Cleaning ---

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
	total_sale is null

select count (*) from retail_sales

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
	total_sale is null

--- Data Exploration ---

--- How Many Sales Occured ---
select count(*) as total_sale from retail_sales

--- How Many Unique Customers We Have? ----
select count(distinct customer_id) from retail_sales

--- How Many Unique Category We Have ---
select distinct category from retail_sales

--- Data Analysis & Business Key Problems & Answer

--- Q1 Write a SQL Query to retrive all columns for sales made on '2022-11-05 AND total_sale is higher than 300'
select * from retail_sales
where sale_date = '2022-11-05' and total_sale > 300 

--- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is higher or equal to 4 in the month of Nov-2022 ---
select 
	*
from retail_sales
where category = 'Clothing' 
AND quantiy >= 4
AND to_char(sale_date, 'YYYY-MM') = '2022-11'

--- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	AVG(age) AS age_average
FROM retail_sales
WHERE category = 'Beauty'

--- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale >= 1000

--- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	COUNT(*) AS total_trans, 
	gender,
	category
FROM retail_sales
GROUP BY 
	gender,
	category

--- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    year,
    month,
    avg_total_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_total_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;

--- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5

--- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	COUNT(DISTINCT customer_id) as unique_customer, 
	category
FROM retail_sales
GROUP BY category

--- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT count(*) AS total_orders,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
GROUP BY shift
