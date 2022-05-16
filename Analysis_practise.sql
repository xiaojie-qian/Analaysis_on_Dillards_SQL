DATABASE ua_dillards;
HELP TABLE deptinfo;
SHOW TABLE deptinfo;
SELECT TOP 10 *
FROM deptinfo;
-- Get to know the schema, same to the other tables 

SELECT TOP 5 cost, retail, orgprice, sprice, amt 
FROM skstinfo sks JOIN trnsact t
ON sks.sku = t.sku; 
-- insepct the differences among all the prices 
-- sprice = amt , retail can be smaller than cost

-- Q1: What is the sku number of the item in the Dillard’s database that had the highest original sales price?
SELECT TOP 5 sku, orgprice
FROM trnsact
ORDER BY orgprice desc;
-- 6200173
 
-- Q2: How many states within the United States are Dillard’s stores located? 
SELECT DISTINCT state 
FROM strinfo; 
-- 31

-- Q3: What was the date of the earliest sale in the database where the sale price of the item did not equal the original price of the item, and what was the largest margin (original price minus sale price) of an item sold on that earliest date?
SELECT TOP 100 orgprice, sprice, orgprice-sprice AS margin, saledate
FROM trnsact
WHERE orgprice<>sprice
ORDER BY saledate ASC, margin DESC
--04/08/01, $510.00

-- Q4: On which day was Dillard’s income based on total sum of purchases the greatest
SELECT TOP 10 saledate, sum(amt) AS total_Sale
FROM TRNSACT 
WHERE stype = 'P'
GROUP BY saledate
ORDER BY total_Sale DESC;
-- 04/12/18

-- Q5: What is the deptdesc of the departments that have the top 3 greatest numbers of skus from the skuinfo table associated with them? 
SELECT TOP 3 s.dept, d.deptdesc, COUNT(DISTINCT s.sku) AS sku_num
FROM skuinfo s JOIN deptinfo d
ON s.dept=d.dept
GROUP BY s.dept, d.deptdesc
ORDER BY sku_num DESC;
-- INVEST, POLOMEN, BRIOSO

-- Q6: What is the average amount of profit Dillard’s made per day?  
SELECT SUM(amt-(cost*quantity))/ COUNT(DISTINCT saledate) AS avg_sales
FROM trnsact t JOIN skstinfo s
ON t.sku=s.sku AND t.store=s.store
WHERE stype='P';
--$1,527,903

-- Q7: What department (with department description), brand, style, and color brought in the greatest total amount of sales?    
SELECT TOP 10 d.deptdesc, s.dept, s.brand, s.style, s.color, SUM(t.AMT) AS total_Sale
FROM trnsact t, skuinfo s, deptinfo d
WHERE t.sku=s.sku 
AND s.dept=d.dept 
AND t.stype='P'
GROUP BY d.deptdesc, s.dept, s.brand, s.style, s.color
ORDER BY total_sale DESC;
-- Department 800 described as Clinique, brand Clinique, style 6142, color DDML

-- Q8: In what city and state is the store that had the greatest total sum of sales?
SELECT TOP 10 t.store, s.city, s.state, SUM(amt) AS total_sale
FROM trnsact t JOIN strinfo s
ON t.store=s.store
WHERE stype='P'
GROUP BY t.store, s.state, s.city
ORDER BY total_sale DESC;
-- Metairie, LA

-- Q9: How many states have more than 10 Dillards stores in them?    
SELECT COUNT(*) AS store_num
FROM strinfo
GROUP BY state
HAVING store_num>10
-- 15

-- Q10: 