
-- Restaurant Order Analysis

USE restaurant_db;

SELECT * FROM menu_items;

-- Exploratory Data Analysis

-- Que1. View the menu_items table and write a query to find the number of items on the menu
SELECT DISTINCT COUNT(menu_item_id) AS Number_of_items FROM menu_items;

-- Que2. What are the least and most expensive items on the menu?
-- Most Expensive
SELECT item_name, price 
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- Least Expensive
SELECT item_name, price 
FROM menu_items
ORDER BY price
LIMIT 1;

-- Que3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT 
    category, 
    COUNT(item_name) AS no_of_italian_dishes, -- Total count of Italian dishes
    (SELECT item_name 
     FROM menu_items 
     WHERE category = 'Italian' 
     ORDER BY price ASC 
     LIMIT 1) AS least_expensive_dish, -- Least expensive dish name
    (SELECT price 
     FROM menu_items 
     WHERE category = 'Italian' 
     ORDER BY price ASC 
     LIMIT 1) AS least_expensive_price, -- Least expensive dish price
    (SELECT item_name 
     FROM menu_items 
     WHERE category = 'Italian' 
     ORDER BY price DESC 
     LIMIT 1) AS most_expensive_dish, -- Most expensive dish name
    (SELECT price 
     FROM menu_items 
     WHERE category = 'Italian' 
     ORDER BY price DESC 
     LIMIT 1) AS most_expensive_price -- Most expensive dish price
FROM 
    menu_items
WHERE 
    category = 'Italian';


-- Que4. How many dishes are in each category? What is the average dish price within each category?

SELECT 
    category, 
    COUNT(item_name) AS total_dishes, 
    AVG(price) AS average_price
FROM 
    menu_items
GROUP BY 
    category;

-- Que5. View the order_details table. What is the date range of the table?
SELECT 
    MIN(order_date) AS starting_date, 
    MAX(order_date) AS ending_date
FROM 
    order_details;
    
-- Que6. How many orders were made within this date range? How many items were ordered within this date range?
SELECT COUNT(DISTINCT order_id) AS total_orders, COUNT(*) AS total_items
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-03-31';

-- Que7. Which orders had the most number of items?
SELECT DISTINCT order_id, count(*) AS total_items
FROM order_details
GROUP BY order_id
ORDER BY total_items DESC;

-- Que8. How many orders had more than 12 items?
SELECT COUNT(order_id) AS total_orders
FROM (
    SELECT order_id, COUNT(*) AS total_items
    FROM order_details
    GROUP BY order_id
    HAVING total_items > 12
) AS subquery;

-- Que9. Combine the menu_items and order_details tables into a single table
SELECT *
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id;

-- Que10:What were the least and most ordered items? What categories were they in?
SELECT item_name, category, COUNT(order_details_id) AS num_purchases -- Most ordered items
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases DESC; 

SELECT item_name, category, COUNT(order_details_id) AS num_purchases -- Least ordered items
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases; 

-- Que11. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- Que12. View the details of the highest spend order. Which specific items were purchased?
SELECT *
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id = 440;

-- Que14. View the details of the top 5 highest spend orders. Which specific items were purchased?
SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;

-- Que15. How much was the most expensive order in the dataset?
SELECT order_id, SUM(price) AS expensive_order_price
FROM order_details od LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY expensive_order_price DESC
LIMIT 1;