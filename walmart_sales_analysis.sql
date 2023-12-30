-- Database Initialization
USE walmart;

-- Create Sales Data Table
CREATE TABLE sales_data (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT(11, 9) NOT NULL,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
);

-- Feature Engineering

-- Add time_of_day Column
SELECT
    time,
    (CASE
        WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    ) AS time_of_day
FROM sales_data;

ALTER TABLE sales_data ADD COLUMN time_of_day VARCHAR(15);

UPDATE sales_data
SET `time_of_day` = (
    CASE
        WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name Column
ALTER TABLE sales_data ADD COLUMN day_name VARCHAR(10);

UPDATE sales_data
SET day_name = DAYNAME(date);

-- Add month_name Column
ALTER TABLE sales_data ADD COLUMN month_name VARCHAR(10);

UPDATE sales_data
SET month_name = MONTHNAME(date);

-- EDA

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales_data;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM sales_data;

-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) as nproduct_line
FROM sales_data;

-- What is the most common payment method?
SELECT payment_method, COUNT(payment_method) as pmcount
FROM sales_data
GROUP BY payment_method
ORDER BY pmcount DESC;

-- What is the most selling product line?
SELECT product_line, COUNT(product_line) as plcount
FROM sales_data
GROUP BY product_line
ORDER BY plcount DESC;

-- What is the total revenue by month?
SELECT month_name, SUM(total) as total_revenue
FROM sales_data
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT month_name, SUM(cogs) as total_revenue
FROM sales_data
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, SUM(total) as total_revenue
FROM sales_data
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line, SUM(VAT) as total_vat
FROM sales_data
GROUP BY product_line
ORDER BY total_vat DESC;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) as qty
FROM sales_data
GROUP BY branch
HAVING SUM(quantity) > 
(
    SELECT AVG(qty_total) AS average_total_sales
    FROM (
        SELECT branch, SUM(quantity) AS qty_total
        FROM sales_data
        GROUP BY branch
        ) AS branch_totals
);

-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(product_line) as cnt
FROM sales_data
GROUP BY gender, product_line
ORDER BY gender, cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, AVG(rating) as rnt
FROM sales_data
GROUP BY product_line
ORDER BY rnt DESC;

-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) as total_sales
FROM sales_data
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which customer type brings the most revenue?
SELECT customer_type, SUM(total) as total_sales
FROM sales_data
GROUP BY customer_type
ORDER BY total_sales DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(VAT) as VAT
FROM sales_data
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(VAT) as VAT
FROM sales_data
GROUP BY customer_type
ORDER BY VAT DESC;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) as cnt
FROM sales_data
GROUP BY customer_type
ORDER BY cnt DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as cnt
FROM sales_data
GROUP BY gender
ORDER BY cnt DESC;

-- What is the gender distribution per branch?
SELECT gender, branch, COUNT(*) AS cnt
FROM sales_data
GROUP BY gender, branch
ORDER BY gender, cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) as rnt
FROM sales_data
GROUP BY time_of_day
ORDER BY rnt DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, AVG(rating) as rnt
FROM sales_data
GROUP BY time_of_day, branch
ORDER BY time_of_day, branch, rnt DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS cnt
FROM sales_data
GROUP BY day_name
ORDER BY cnt DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name, branch, AVG(rating) AS cnt
FROM sales_data
GROUP BY day_name, branch
ORDER BY day_name, branch, cnt DESC;
