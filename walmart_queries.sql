CREATE DATABASE IF NOT EXISTS walmartSales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;


-- ----------------- Feature Engineering ------------
-- time_of_the_day 

select time from sales;

select time,
(case 
    when time between "00:00:00" and "12:00:00" then "Morning"
    when time between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
end 
) as time_of_date
from sales;

alter table sales add column time_of_date varchar(20);

update sales
set time_of_date = (case 
    when time between "00:00:00" and "12:00:00" then "Morning"
    when time between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
end 
);

-- day_name

select date, dayname(date) as day_name 
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name =  dayname(date);

-- month_name

select date, monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name =  monthname(date);

-- -------------------------------------------------------------------------------


-- ----------------------------------- Generic ----------------------------------

-- How many unique cities does the data have?

select distinct(city) from sales;

-- In which city is each branch?

select distinct branch from sales;

select distinct city, branch 
from sales;

-- ---------------------------------------------------------------------

-- ------------------------ Product -------------------------------------
-- 1.How many unique product lines does the data have?

select count(distinct product_line) from sales;

-- What is the most common payment method?
select payment, count(payment) as cpm
from sales
group by payment
order by cpm desc ;

-- What is the most selling product line?

select product_line, count(product_line) as cpl
from sales
group by product_line
order by cpl desc ;

-- What is the total revenue by month?

select month_name as month, sum(total) as total_revenue
from sales
group by month
order by total_revenue desc;

-- What month had the largest COGS?

select month_name as month, sum(cogs) as total_cogs
from sales
group by month
order by total_cogs desc;

-- What product line had the largest revenue?

select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?

select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

-- What product line had the largest VAT?

select product_line, avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select product_line, avg(total)
from sales;

-- Which branch sold more products than average product sold?

select branch, sum(quantity)
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales)
;

-- What is the most common product line by gender?

select gender,product_line, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as rating
from sales
group by product_line
order by rating desc;

-- --------------------------- sales ---------------------------

-- Number of sales made in each time of the day per weekday

select * from sales;

select time_of_date, count(*) as total_sales
from sales
where day_name = "sunday"
group by time_of_date
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(tax_pct) as vat
from sales
group by city
order by vat desc;

-- Which customer type pays the most in VAT?

SELECT 
    customer_type, AVG(tax_pct) AS vat
FROM
    sales
GROUP BY customer_type
ORDER BY vat DESC;

-- -------------------------------------------------------------------------------

-- ------------------------------ customer ---------------------------------------

-- How many unique customer types does the data have?

select count(distinct customer_type)
from sales;

-- How many unique payment methods does the data have

select count(distinct payment)
from sales;

-- What is the most common customer type?

select customer_type, count(*) as ctm_count
from sales
group by customer_type
order by ctm_count desc;

-- Which customer type buys the most?

select customer_type, count(*) as ctm_count
from sales
group by customer_type
order by ctm_count desc;

-- What is the gender of most of the customers?

select gender, count(*) as customers
from sales
group by gender 
order by customers desc;

-- What is the gender distribution per branch?

select gender,count(*) as gender_dis
from sales
where branch = "B"
group by gender
order by gender_dis desc; 
-- in above query change branch as per the requirement

select branch,gender,count(*) as gender_dis
from sales
group by branch,gender
order by gender_dis desc; 

-- Which time of the day do customers give most ratings?

select time_of_date, avg(rating) as rating
from sales
group by time_of_date
order by rating desc;

-- Which time of the day do customers give most ratings per branch?

select branch,time_of_date, avg(rating) as rating
from sales
group by branch, time_of_date
order by rating desc;

select time_of_date, avg(rating) as rating
from sales
where branch = "A"
group by time_of_date
order by rating desc;

-- Which day of the week has the best avg ratings?

select day_name, avg(rating) as rating
from sales
group by day_name
order by rating desc;

-- Which day of the week has the best average ratings per branch?

select branch, day_name, avg(rating) as rating
from sales
group by branch,day_name
order by rating;

select day_name, avg(rating) as rating
from sales
where branch = "A"
group by day_name
order by rating desc;
