/*ch 12 sql statement 1*/

CREATE OR REPLACE VIEW customer_addresses AS
SELECT DISTINCT
		a.customer_id, a.email_address, a.last_name, a.first_name
		, bt.line1 AS bill_line1, bt.line2 AS bill_line2, bt.city AS bill_city, bt.state AS bill_state, bt.zip_code AS bill_zip
        , st.line1 AS ship_line1, st.line2 AS ship_line2, st.city AS ship_city, st.state AS ship_state, st.zip_code AS ship_zip
FROM customers a
JOIN addresses b ON a.customer_id=b.customer_id
JOIN addresses bt ON a.customer_id=bt.customer_id AND a.billing_address_id=bt.address_id
JOIN addresses st ON a.customer_id=st.customer_id AND a.shipping_address_id=st.address_id
;

/*ch 12 sql statement 2*/

SELECT customer_id, last_name, first_name, bill_line1
FROM customer_addresses
ORDER BY last_name, first_name;

/*ch 12 sql statement 3*/

UPDATE customer_addresses
SET ship_line1 = '1990 Westwood Blvd.'
WHERE customer_id = 8;

/*ch 12 sql statement 4*/

CREATE OR REPLACE VIEW order_item_products AS
SELECT
	o.order_id, o.order_date, o.tax_amount, o.ship_date, p.product_name, oi.item_price, oi.discount_amount, (oi.item_price - oi.discount_amount) AS final_price
	, oi.quantity, (oi.quantity * (oi.item_price - oi.discount_amount)) as item_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id;

/*ch 12 sql statement 5*/

CREATE OR REPLACE VIEW product_summary AS
SELECT product_name, SUM(quantity) AS order_count, SUM(item_total) AS order_total
FROM order_item_products
GROUP BY product_name;

/*ch 12 sql statement 6*/

SELECT product_name, order_total
FROM product_summary
ORDER BY order_total DESC
LIMIT 5;

/*ch 13 sql statement 1*/

DROP PROCEDURE IF EXISTS Test;
    DELIMITER //
CREATE PROCEDURE Test ()
	BEGIN
		DECLARE product_row_count decimal (10,0);
        
        SELECT count(*) INTO product_row_count FROM products;
        
        SELECT CASE
				WHEN product_row_count >= 7 THEN 'The number of products is greater than or equal to 7'
                ELSE 'The number of products is less than 7'
                END AS Message;
        
        END//
        
        CALL test();

/*ch 13 sql statement 2*/

DROP PROCEDURE IF EXISTS Test;
	DELIMITER //
CREATE PROCEDURE Test ()
	BEGIN
		DECLARE product_row_count decimal (10,0);
        DECLARE avg_list_price decimal (18,2);
        
        SELECT count(*) INTO product_row_count FROM products;
		SELECT avg(list_price) INTO avg_list_price FROM products;
        
        IF product_row_count >= 7 THEN SELECT product_row_count, avg_list_price;
                ELSE SELECT 'The number of products is less than 7' AS message;
		END IF;
	END//
    
    CALL Test ();

/*ch 13 sql statement 3*/

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test ()
BEGIN
  DECLARE i              INT DEFAULT 1;
  DECLARE number_1_var   INT DEFAULT 10;
  DECLARE number_2_var   INT DEFAULT 20;
  DECLARE message_var    VARCHAR(400);
  
  SET message_var = CONCAT('Common factors of ', number_1_var, ' and ',number_2_var,':');
  WHILE ((i <= number_1_var) AND (i < number_2_var))  DO
    
    IF ((number_1_var % i = 0) AND (number_2_var % i = 0)) THEN
      SET message_var = CONCAT(message_var," ", i);
      END IF;
    
    SET i = i + 1;
  END WHILE;
  
  SELECT message_var AS message;

END//

DELIMITER ;

CALL test ();

/*ch 13 sql statement 4*/

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
DECLARE product_name_var	VARCHAR(50);
DECLARE list_price_var			DECIMAL(9,2);
DECLARE row_not_found				TINYINT DEFAULT FALSE;
DECLARE s_var								VARCHAR(400) DEFAULT '';

DECLARE product_cursor CURSOR for
	SELECT 
	       product_name,
		list_price
		FROM
			products
			WHERE
				list_price > 700
				ORDER BY list_price DESC;
    
DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET row_not_found = TRUE;

OPEN product_cursor;

FETCH product_cursor INTO product_name_var, list_price_var;
WHILE row_not_found = FALSE DO
    SET s_var = CONCAT(s_var,'"',product_name_var,'","',list_price_var,'"|');
    FETCH product_cursor INTO product_name_var,list_price_var;
END WHILE;

SELECT s_var AS message;
END//

DELIMITER ;

CALL test();

/*ch 13 sql statement 5*/

DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN

DECLARE insert_duplicate varchar(50) DEFAULT FALSE;

DECLARE CONTINUE HANDLER FOR 1062
	SET insert_duplicate = TRUE;
 
INSERT INTO categories
(category_id, category_name)
VALUES
(default, 'Guitars');

IF insert_duplicate = TRUE THEN
   SELECT 'Row was not inserted - duplicate entry.' AS message;
ELSE
	SELECT '1 row was inserted.' AS message;
END IF;

END//

DELIMITER ;

CALL test();








