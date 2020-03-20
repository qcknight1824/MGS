/*sql statement 1*/
SELECT product_code, product_name, list_price, discount_percent 
FROM products
ORDER BY list_price;

/*SQL statement 2*/
SELECT CONCAT(last_name, ', ',first_name) AS full_name
FROM customers
WHERE LEFT(last_name, 1) BETWEEN 'M' AND 'Z'
ORDER BY last_name ASC;

/*SQL statement 3*/
SELECT product_name, list_price, date_added
FROM products
WHERE list_price BETWEEN 500 and 2000
ORDER BY date_added DESC;

/*SQL statement 4*/
SELECT product_name, list_price, discount_percent, ROUND((discount_percent * (list_price/100)),2) AS discount_amount
, ROUND((list_price - (discount_percent*(list_price/100))),2) AS discount_price
FROM products
ORDER BY (list_price - (discount_percent*list_price)) DESC
LIMIT 5;

/*SQL statement 5*/
SELECT item_id, item_price, discount_amount, quantity, (item_price * quantity) AS price_total, (discount_amount * quantity) AS discount_total,
((item_price * discount_amount)*quantity) AS item_total
FROM order_items
WHERE ((item_price * discount_amount)*quantity) > 500
ORDER BY ((item_price * discount_amount)*quantity) DESC;

/*SQL statement 6*/
SELECT order_id, order_date, ship_date
FROM orders
WHERE ship_date IS NULL;

/*SQL statement 7*/
SELECT NOW() AS today_unformatted, DATE_FORMAT(now(),'%d-%m-%Y') AS today_formatted;

/*SQL statement 8*/
SELECT FORMAT(100,'C') AS price, FORMAT(0.07,'P') AS tax_rate, (100*0.07) tax_amount, (100+(100*0.07)) AS total;