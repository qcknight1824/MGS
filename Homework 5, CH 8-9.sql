/*ch 8 sql statement 1*/

SELECT CAST(list_price AS decimal(9,1)) AS list_price, CONVERT(list_price, signed) AS convert_lp, CAST(list_price AS signed) AS cast_lp
FROM products;

/*ch 8 sql statement 2*/

SELECT CAST(date_added AS date) AS CAST_da, LEFT(CAST(date_added AS date), 7) AS CAST_da_YYYYMM, CAST(date_added AS time) AS CAST_da_time
FROM products;

/*ch 9 sql statement 1*/

SELECT list_price, discount_percent, ROUND(list_price*(discount_percent/100),2) AS discount_amount
FROM products;

/*ch 9 sql statement 2*/

SELECT order_date, DATE_FORMAT(order_date, '%Y') AS 'YYYY', DATE_FORMAT(order_date, '%b-%d-%Y') AS 'MON-DD-YYYY', DATE_FORMAT(order_date, '%h:%i %p') AS 'AM/PM', 
DATE_FORMAT(order_date, '%m/%d/%y %H:%i') AS 'MM/DD/YY HH:SS'
FROM orders;    

/*ch 9 sql statement 3*/

SELECT card_number, LENGTH(card_number), RIGHT(card_number,4) AS last_four, IF(length(card_number)='16',
CONCAT('XXXX-XXXX-XXXX-', RIGHT(card_number,4)), CONCAT('XXXX-XXXXXX-X',right(card_number,4))) AS XXXX_lastfour
FROM orders;

/*ch 9 sql statement 4*/

SELECT order_id, order_date, DATE_ADD(order_date, INTERVAL 2 DAY) AS approx_ship_date
, IFNULL(ship_date, 'missing ship_date') AS ship_date_no_nulls
, DATEDIFF(order_date,IF(ship_date IS NULL,DATE_ADD(order_date, INTERVAL 2 DAY),ship_date)) days_to_ship
FROM orders
WHERE MONTH(order_date) = 3
AND YEAR(order_date) = 2018;

/*ch 9 sql statement 5*/

SELECT email_address, LEFT(email_address, REGEXP_INSTR(email_address,'@')-1) AS username, RIGHT(email_address, LENGTH(email_address) - REGEXP_INSTR(email_address,'@')) AS domain
FROM administrators;

/*ch 9 sql statement 6*/

SELECT product_name, SUM(quantity) AS total_quantity, RANK() OVER(ORDER BY SUM(quantity)) AS 'rank', DENSE_RANK() OVER(ORDER BY SUM(quantity)) 'dense_rank'
FROM products
NATURAL JOIN order_items
group by product_name;

/*ch 9 sql statement 7*/

SELECT c.category_name, p.product_name, SUM((oi.item_price-oi.discount_amount)*oi.quantity) AS total_sales_per_product,
FIRST_VALUE(p.product_name) OVER(PARTITION BY c.category_name ORDER BY SUM((oi.item_price-oi.discount_amount)*oi.quantity) DESC) AS highest_selling_prod,
LAST_VALUE(p.product_name) OVER(PARTITION BY c.category_name ORDER BY SUM((oi.item_price-oi.discount_amount)*oi.quantity) DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_selling_prod
FROM categories c
JOIN products p ON c.category_id=p.category_id
JOIN order_items oi  ON p.product_id=oi.product_id
GROUP BY c.category_name, p.product_name;








