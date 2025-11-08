drop table if exists zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightingms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);

--Data Exploration

--Count of rows

SELECT Count(*) FROM zepto

--Sample DATA

SELECT * FROM zepto
limit 10;

--Null values
SELECT * FROM zepto 
where name IS NULL
or
category IS NULL
or
mrp IS NULL
or
discountpercent IS NULL
or
availableQuantity IS NULL
or
discountedsellingprice IS NULL
or
weightingms IS NULL
or
outofStock IS NULL
or
Quantity IS NULL

--Different Product Categories
SELECT DISTINCT category
FROM zepto
ORDER BY category

--Products in stock vs out of stock
SELECT outofStock, COUNT (sku_id)
FROM zepto
GROUP BY outofStock

--Product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC

--Data cleaning
--Products with price=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedsellingprice=0;

DELETE FROM ZEPTO 
WHERE mrp=0;

--convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto

--TOP 10 BEST-VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--PRODUCTS WITH HIGH MRP BUT OUT OF STOCK
SELECT DISTINCT name,mrp 
FROM zepto
WHERE outofStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--ESTIMATED REVENUE FOR EACH CATEGORY
SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--PRODUCTS WHERE MRP > 500RS AND DISCOUNT IS LESS THAN 10%
SELECT DISTINCT name,mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent <10
ORDER BY mrp DESC, discountPercent DESC;

--TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--PRICE PER GRAM FOR PRODUCTS ABOVE 100G AND SORT BEST VALUE
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_per_gms
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gms;

--GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, MEDIUM, BULK
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
 WHEN weightingms < 5000 THEN 'Medium'
  ELSE 'Bulk'
  END AS weight_category
FROM zepto;

--TOTAL INVENTORY WEIGHT PER CATEGORY
SELECT category,
SUM(weightingms * availableQuantity) AS total_weight
FROM ZEPTO
GROUP BY category
ORDER BY total_weight;
