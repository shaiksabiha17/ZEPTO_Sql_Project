
CREATE TABLE Zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(120),
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
---------------------

SELECT COUNT(*) FROM Zepto

select * from zepto
Limit 10
---- 
---Null values 

Select * From Zepto
WHERE name is NULL
or  Category is null
or name is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedSellingPrice is null
or weightInGms is null
or outOfStock is null
or quantity is null

---diffrent Product categories---

SELECT DISTINCT category
FROM Zepto
ORDER BY category

---Products in stock vs outof stock----

SELECT outOfStock FROM Zepto
where outOfStock = False

SELECT COUNT(*) AS total_products
FROM Zepto
WHERE outOfStock = FALSE

----count how many are outofstock and stock

SELECT outOfStock, COUNT(*) AS total_products
FROM Zepto
GROUP BY outOfStock;

--only outofstock

SELECT outOfStock, COUNT(*) AS total_products
FROM Zepto
WHERE outOfStock = FALSE
GROUP BY outOfStock;

---Product names present multiple times

SELECT name, COUNT(sku_id) as No_of_sku
From Zepto
Group by name
Having count(sku_id)>1
Order by count(sku_id) DESC

-----data cleaning----

---products with price =0

Select * from Zepto
Where mrp = 0 or  discountedSellingPrice =0;

Delete From Zepto
where mrp =0;
-----
----convert in Rupees

UPDATE zepto
Set mrp =mrp/100.0,
discountedSellingPrice =discountedSellingPrice/100.0

Select mrp, discountedSellingPrice
From zepto

--------------------BUSINESS QUESTIOONS-----

--1--Found top 10 best-value products based on discount percentage.

SELECT Distinct name, mrp, discountPercent  From Zepto
Order by discountPercent DESC
LIMIT 10

--2--Identified high-MRP products that are currently out of stock

SELECT name, mrp FROM Zepto
WHERE outOfStock = True and mrp > 300
ORDER BY mrp DESC

--3--Estimated potential revenue for each product category

 SELECT category,
 SUM (discountedSellingPrice * availableQuantity) AS total_revenue
 FROM Zepto
 GROUP BY Category
 ORDER BY total_revenue
 LIMIT 10

--4--Filtered expensive products (MRP > ₹500) with minimal discount

SELECT DISTINCT name, mrp, discountPercent FROM Zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC
LIMIT 10

--5--Ranked top 5 categories offering highest average discounts

 SELECT Category,AVG(discountPercent) AS TOP_5_AVG_CATEGORY 
 FROM Zepto
 GROUP BY Category
 ORDER BY TOP_5_AVG_CATEGORY DESC
 LIMIT 5
  
 --6--Calculated price per gram to identify value-for-money products
 
 SELECT DISTINCT name, weightInGms,discountedSellingPrice, 
 ROUND(discountedSellingPrice/weightInGms) AS Price_per_grm
 FROM Zepto
 WHERE weightInGms>=100
 ORDER BY Price_per_grm

 --7--Grouped products based on weight into Low, Medium, and Bulk categories

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
	WHEN weightInGms <5000 THEN 'MEDIUM'
	ELSE 'BLUK'
	END AS weight_CATEGORY
FROM Zepto

---Total Inventory weight per category---

SELECT category,
SUM(weightInGms * availableQuantity) AS TOTAL_WEIGHT
From Zepto
Group by category
ORDER BY TOTAL_WEIGHT



