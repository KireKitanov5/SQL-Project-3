USE [Portfolio Project3]
--1. EXPLORE THE ITEMS TABLE
-- 1. View the menu_items table
SELECT * 
FROM dbo.menu_items

-- 2. Find the number of items in the menu
SELECT COUNT (*)
FROM menu_items

-- 3. What are the least and the most expensive items in the menu?
SELECT * 
FROM menu_items
ORDER BY price

SELECT * 
FROM menu_items
ORDER BY price DESC

-- 4. How many Italian dishes are on the menu?
SELECT COUNT(category) 
FROM menu_items
WHERE category='Italian'
GROUP BY category

-- 5. What are the least and the most expensive dishes on the menu?
SELECT *
FROM menu_items
Where category='Italian'
ORDER BY price

SELECT *
FROM menu_items
Where category='Italian'
ORDER BY price DESC

-- 6. How many dishes are in each category?
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category

-- 7. What is the average dish price in each category?
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category

--2.EXPLORE THE ORDERS TABLE
-- 8. View the order_details table
SELECT *
FROM order_details

SELECT  cast(order_time as datetime)
FROM order_details

-- 9. What is the date range of the table?
SELECT *
FROM order_details
ORDER BY order_date
-- OR
SELECT MIN(order_date), MAX(order_date)
FROM order_details

-- 10. How many orders were made within this date range?
SELECT COUNT(DiSTINCT order_id)
FROM order_details

-- 11. How many items were ordered within this date range?
SELECT COUNT(*) 
FROM order_details

-- 12. Wich orders had the most number of items?

SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC

-- 13. How many orders had more than 12 items?

SELECT COUNT(*) FROM

(SELECT order_id, COUNT(item_id) as num_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12) as num_orders

-- 3 ANALYZE CUSTOMER BEHAVIOUR
-- 14.Combine the menu_items and order_details tables into a single table

SELECT * 
FROM menu_items

SELECT *
FROM order_details

SELECT *
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id

-- 15.What are the least and the most ordered items, and in what category are they?
SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name 
ORDER BY num_purchases 

SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name 
ORDER BY num_purchases DESC   

SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name, category 
ORDER BY num_purchases DESC

SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name, category 
ORDER BY num_purchases 

-- 16.What were the top 5 orders that spent the most money?
SELECT TOP 5 order_id, SUM(price) AS total_spent
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
GROUP BY order_id    
ORDER BY total_spent DESC

-- 17.View the details of the highest spent order. 
SELECT * 
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
WHERE order_id = 440    

SELECT category, COUNT(item_id) AS num_items
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
WHERE order_id = 440    
GROUP BY category 

-- 18.View the details of the top 5 highest spent order. 
SELECT category, COUNT(item_id) AS num_items
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)    
GROUP BY category 

440	192.14999999999998
2075	191.04999999999995
1957	190.09999999999997
330	189.7
2675	185.09999999999997

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od 
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)    
GROUP BY order_id, category 

-- 19.What is the MAX price for each category
SELECT category, MAX(price) AS max_price
FROM menu_items
GROUP BY category

-- 20. How many MAX prices are less than $15 (subquery)
SELECT *
FROM 
(SELECT category, MAX (price) AS max_price
FROM menu_items
GROUP BY category) AS mp 
WHERE max_price < 15

SELECT COUNT(*)
FROM 
(SELECT category, MAX (price) AS max_price
FROM menu_items
GROUP BY category) AS mp 
WHERE max_price < 15

-- 20. CTE
WITH mp AS (SELECT category, MAX (price) AS max_price
FROM menu_items
GROUP BY category)

WITH mp AS (SELECT category, MAX (price) AS max_price
FROM menu_items
GROUP BY category)
SELECT COUNT(*)
FROM mp 
WHERE max_price < 15

-- 21.Multiple references
WITH mp AS (SELECT category, MAX (price) AS max_price
FROM menu_items
GROUP BY category)
SELECT COUNT(*)
FROM mp 
WHERE max_price < (SELECT AVG(max_price) 
FROM mp)

--22. Multiple tables
WITH mp AS (SELECT category, MAX(price) AS max_price
        FROM menu_items
        GROUP BY category),
     ci AS (SELECT *
           FROM menu_items
           WHERE item_name LIKE '%chicken%')

SELECT *
FROM ci LEFT JOIN mp ON ci.category = mp.category



