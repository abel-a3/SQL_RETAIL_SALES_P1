-- sql retail sales analysis - p1

-- Create Table
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales 
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,	
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);


	SELECT *
	FROM Retail_Sales1;

	select COUNT (*)
	FROM Retail_Sales1;

	SELECT *
	FROM Retail_Sales1
	WHERE transactions_id IS NULL;
	
	SELECT *
	FROM Retail_Sales1
	WHERE sale_date IS NULL;

	SELECT *
	FROM Retail_Sales1
	WHERE sale_time IS NULL;

	SELECT *
	FROM Retail_Sales1
	WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR price_per_unit IS NULL
	OR total_sale IS NULL
	OR customer_id IS NULL;

--
DELETE FROM Retail_Sales1
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR price_per_unit IS NULL
	OR total_sale IS NULL
	OR customer_id IS NULL;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale
from Retail_Sales1

-- How many unique customers we have?
select COUNT(DISTINCT customer_id) as total_customers
from Retail_Sales1

-- How many categories we have?
select COUNT(DISTINCT category) as total_customers
from Retail_Sales1

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS/ANSWERS

-- My Analysis and Findings

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
from Retail_Sales1
where sale_date = '2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM Retail_Sales1
WHERE category = 'clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantity >= 4;

--3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM Retail_Sales1
GROUP BY category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select AVG(age) avg_age
from Retail_Sales1
where category = 'Beauty';
--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from Retail_Sales1
where total_sale > 1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender,
	COUNT(*) as total_transactions
from Retail_Sales1
	GROUP BY category, gender;


--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year, month, avg_sale
from
(
select YEAR(sale_date) as year,
	   MONTH(sale_date) as month,
	   AVG(total_sale) as avg_sale,
	   RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
from Retail_Sales1
group by YEAR(sale_date),  MONTH(sale_date)
) AS t1
WHERE rank = 1

--8. Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5 customer_id, 
       SUM(total_sale) AS total_sales
FROM Retail_Sales1
GROUP BY customer_id
ORDER BY total_sales DESC;

--9. Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category,
		COUNT(DISTINCT customer_id) as unique_customers
FROM Retail_Sales1
group by category

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *, 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM Retail_Sales1
)
SELECT shift, 
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift 

-- END OF PROJECT		
