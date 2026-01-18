drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5, 2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data Exploration--
--count of rows--
SELECT COUNT (*) FROM Zepto;

--sample data--
SELECT * FROM zepto
LIMIT 10;

--null value--
SELECT * FROM zepto
WHERE name IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;


--different product categories--
SELECT DISTINCT category
FROM zepto 
ORDER BY category;


--products in stock vs out of stock--
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;


--product name present multiple times--
SELECT name, COUNT(sku_id) as "no of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;



---data cleaning---
---product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountSellingPrice = 0;

DELETE FROM zepto WHERE mrp =0;


---convert paise to rupees---
UPDATE zepto
SET mrp = mrp/100.0,
discountSellingPrice = discountSellingPrice/ 100.0;

SELECT mrp, discountSellingPrice FROM zepto


---Q1. Find the top 10 best-value products based on the discount percentage---
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


---Q2. What are the Products with High MRP but Out of Stock?---
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;


---Q3. Calculate Estimated Revenue for each Category---
SELECT category, 
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


---Q4. Find all products where MRP is greater than $500 and discount is less than 10%---
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
where mrp > 500 and discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


---Q5. Identify the top 5 categories offering the highest avarage discount percenatge---
SELECT DISTINCT category, 
ROUND(AVG(discountPercent),2) AS avg_discount FROM zepto 
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


---Q6. Find the price per gram for products above 100g and sort by best value---
SELECT DISTINCT name, weightInGms, discountSellingPrice,
ROUND(discountSellingPrice/weightInGms, 2) AS pricepergram
FROM zepto
WHERE weightInGms >= 100
ORDER BY pricepergram;


---Q7. Group the products into categories like low, medium, bulk.---
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms > 1000 THEN 'Medium'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;


---Q8. What is the total inventory weight per category?---
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;







