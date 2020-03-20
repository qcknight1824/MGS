/*ch 6 sql statement 1*/
SELECT COUNT(*), sum(tax_amount)
FROM Orders;

/*ch 6 sql statement 2*/
SELECT category_name, count(*) AS total_count,MAX(list_price) AS highest_list_price
FROM products
JOIN categories USING (category_id)
GROUP BY category_name
ORDER BY count(*) DESC;

/*ch 6 sql statement 3*/
SELECT a.email_address, SUM(c.item_price * quantity) AS item_price_total, SUM(c.discount_amount * c.quantity) AS Total_Discounts_Applied
FROM customers a
JOIN orders b
ON a.customer_id = b.customer_id
JOIN order_items c
ON b.order_id = c.order_id
GROUP BY a.email_address
ORDER BY item_price_total DESC;

/*ch 6 sql statement 4*/
SELECT a.email_address AS email, COUNT(b.order_id) AS count_orders, SUM((c.item_price - c.discount_amount) * c.quantity) AS total_item_amounts
FROM customers a
JOIN orders b 
ON a.customer_id = b.customer_id
JOIN order_items c 
ON b.order_id = c.order_id
GROUP BY a.email_address
HAVING count_orders > 1
ORDER BY total_item_amounts DESC;

/*ch 6 sql statement 5*/
SELECT a.email_address AS email, COUNT(b.order_id) AS count_orders, SUM((c.item_price - c.discount_amount) * c.quantity) AS total_item_amounts
FROM customers a
JOIN orders b 
ON a.customer_id = b.customer_id
JOIN order_items c 
ON b.order_id = c.order_id
WHERE c.item_price > 400
GROUP BY a.email_address
HAVING count_orders > 1
ORDER BY total_item_amounts DESC;

/*ch 6 sql statement 6*/
SELECT a.product_name, SUM((b.item_price - b.discount_amount) * b.quantity) AS total_amount
FROM products a
JOIN order_items b 
ON a.product_id = b.product_id
GROUP BY a.product_name WITH ROLLUP;

/*ch 6 sql statement 7*/
SELECT a.email_address, COUNT(DISTINCT c.product_id) as distinct_product_count
FROM customers a
JOIN orders b 
ON a.customer_id = b.customer_id
JOIN order_items c
ON b.order_id = c.order_id
GROUP BY a.email_address
ORDER BY a.email_address ASC;

/*ch 6 sql statement 8*/
SELECT IF(GROUPING(a.category_name) = 1,'Grand Totals', a.category_name) AS Category_Name
	,  IF(GROUPING(f.product_name) = 1, 'Category Totals', f.product_name) AS Product_Name
    , SUM(c.quantity) AS 'Total Quantity Purchased'
FROM categories a
INNER JOIN products f
ON a.category_id = f.category_id
JOIN order_items c
ON f.product_id = c.product_id
GROUP BY a.category_name, f.product_name with rollup;

/*ch 6 sql statement 9*/
SELECT order_id, 
		SUM((item_price-discount_amount)*quantity) OVER(PARTITION BY order_id, item_id) AS 'Total Amount',
        SUM((item_price-discount_amount)*quantity) OVER(PARTITION BY order_id) AS 'Total Order Amount'
FROM order_items
ORDER BY order_id;

/*ch 6 sql statement 10*/
SELECT order_id, 
		SUM((item_price-discount_amount)*quantity) OVER(PARTITION BY order_id, item_id) AS 'Total Amount',
        SUM((item_price-discount_amount)*quantity) OVER (order_window ORDER BY item_price) AS 'Total Order Amount',
        ROUND(AVG((item_price-discount_amount)*quantity) OVER order_window, 2) AS 'Avg Item Amount'
FROM order_items
WINDOW order_window AS (PARTITION BY order_id)
ORDER BY order_id;

/*ch 6 sql statement 11*/
SELECT a.customer_id, a.order_date,
	SUM((b.item_price-b.discount_amount)*b.quantity) OVER(PARTITION BY b.order_id, b.item_id) AS 'item_total',
    SUM((b.item_price-b.discount_amount)*b.quantity) OVER(PARTITION BY a.customer_id) AS 'customer_total',
    SUM((b.item_price-b.discount_amount)*b.quantity) OVER(PARTITION BY a.customer_id ORDER BY a.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'running_total'
FROM orders a
JOIN order_items b
ON a.order_id = b.order_id;

/*ch 7 sql statement 1*/
SELECT DISTINCT category_name 
FROM categories
WHERE category_id IN (SELECT DISTINCT category_id FROM products);

/*ch 7 sql statement 2*/
SELECT DISTINCT product_name, list_price
FROM products
WHERE list_price > (SELECT AVG(list_price) FROM products)
ORDER BY list_price DESC;

/*ch 7 sql statement 3*/
SELECT category_name
FROM categories
WHERE NOT EXISTS
(SELECT *
	FROM products
    WHERE category_id = categories.category_id);
    
/*ch 7 sql statement 4*/
SELECT email_address, MAX(order_total) AS Largest_Order
FROM 
	(SELECT a.email_address, b.order_id, SUM((c.item_price-c.discount_amount)*c.quantity) AS order_total
		FROM customers a
		JOIN orders b ON a.customer_id = b.customer_id
		JOIN order_items c ON b.order_id=c.order_id
        GROUP BY a.email_address, b.order_id) sq
 GROUP BY email_address
 ORDER BY MAX(order_total) DESC;
 
 /*ch 7 sql statement 5*/
SELECT a.product_name, CONCAT(ROUND((b.discount_amount/b.item_price)*100,0),'%') AS 'Discount_Percent'
FROM products a
JOIN order_items b ON a.product_id=b.product_id
WHERE Discount_Percent NOT IN 
	(SELECT ROUND((discount_amount/item_price)*100,0)
		FROM order_items
        GROUP BY ROUND((discount_amount/item_price)*100,0)
        HAVING count(*) > 1);

 /*ch 7 sql statement 6*/
 SELECT a.email_address, i.order_id, i.order_date
 FROM customers a JOIN orders i ON a.customer_id=i.customer_id
 WHERE order_date = 
	(SELECT MIN(order_date)
    FROM orders
    WHERE customer_id = i.customer_id)
ORDER BY i.order_date, i.order_id;