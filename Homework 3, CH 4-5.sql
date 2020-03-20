/*ch 4 sql statement 1*/
SELECT category_name, product_name, list_price
FROM products
NATURAL JOIN categories
ORDER BY category_name, product_name ASC;

/*ch 4 sql statement 2*/
SELECT DISTINCT first_name, last_name, line1, city, state, zip_code
FROM addresses 
JOIN customers  USING (customer_id)
WHERE email_address = 'allan.sherwood@yahoo.com';

/*ch 4 sql statement 3*/
SELECT DISTINCT first_name, last_name, line1, city, state, zip_code
FROM addresses 
JOIN customers  USING (customer_id)
WHERE address_id = shipping_address_id;

/*ch 4 sql statement 4*/
SELECT a.last_name, a.first_name, b.order_date, d.product_name, c.item_price, c.discount_amount, c.quantity
FROM customers a
JOIN orders b
ON a.customer_id = b.customer_id
JOIN order_items c
ON b.order_id = c.order_id
JOIN products d
ON c.product_id = d.product_id
ORDER BY a.last_name, b.order_date, d.product_name;

/*ch 4 sql statement 5*/
SELECT DISTINCT v1.product_name, v1.list_price
FROM products v1
JOIN products v2
ON v1.product_id <> v2.product_id
AND v1.list_price = v2.list_price
ORDER BY v1.product_name;

/*ch 4 sql statement 6*/
SELECT a.category_name, b.product_id
FROM categories a
LEFT JOIN products b
ON a.category_id = b.category_id
WHERE b.product_id IS NULL;

/*ch 4 sql statement 7*/
SELECT 'SHIPPED' AS ship_status, order_id, order_date
FROM orders
WHERE ship_date IS NOT NULL

UNION

SELECT 'NOT SHIPPED' AS ship_status, order_id, order_date
FROM orders
WHERE ship_date IS NULL
ORDER BY order_date;

/**** Chapter 5 HW begins here ****/

/*ch 5 sql statement 1*/
INSERT INTO categories
VALUES (DEFAULT, 'Brass');

/*ch 5 sql statement 2*/
UPDATE categories 
SET category_name = 'Woodwinds'
WHERE category_id = 5;

/*ch 5 sql statement 3*/
DELETE FROM categories 
WHERE category_id = 5;
    
/*ch 5 sql statement 4*/
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added)
VALUES (DEFAULT, 4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Piano','Long description to come', 799.99, 0, NOW());

/*ch 5 sql statement 5*/
UPDATE products 
SET discount_percent = 35
WHERE product_id = 11;
    
/*ch 5 sql statement 6*/
DELETE FROM products
WHERE category_id = 4;
DELETE FROM categories
WHERE category_name = 'Keyboards';

/*ch 5 sql statement 7*/
INSERT INTO customers (email_address, password, first_name, last_name)
VALUES ('rick@raven.com', '', 'Rick', 'Raven');

/*ch 5 sql statement 8*/
UPDATE customers 
SET password = 'secret'
WHERE email_address = 'rick@raven.com';

/*ch 5 sql statement 9*/
UPDATE customers
SET password  = 'reset'
LIMIT 100;





