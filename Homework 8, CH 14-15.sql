/*ch 14 sql statement 1*/
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  DELETE FROM addresses
  WHERE customer_id = 8;

  DELETE FROM customers
  WHERE customer_id = 8;

  COMMIT;
  
  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;

CALL test();


/*ch 14 sql statement 2*/
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
	
  DECLARE order_id INT;  
    
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    
START TRANSACTION;

	INSERT INTO orders VALUES(DEFAULT, 3, NOW(), '10.00', '0.00', NULL, 4, 'American Express', '378282246310005', '04/2016', 4);
    SELECT LAST_INSERT_ID()INTO order_id;
    INSERT INTO order_items VALUES(DEFAULT, order_id, 6,'415.00', '161.85', 1);
    INSERT INTO order_items VALUES(DEFAULT, order_id, 1, '699.00', '209.70', 1);

 COMMIT;
  
  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;

CALL test();

/*ch 14 sql statement 3*/

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN

  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
    /*LOCK cust id 6 row*/
  SELECT * FROM customers WHERE customer_id = 6 FOR UPDATE;
  
  UPDATE orders
  SET customer_id = 3
  WHERE customer_id = 6;
  
  UPDATE addresses
  SET customer_id = 3
  where customer_id = 6;

  DELETE FROM customers WHERE customer_id = 6;
  
  COMMIT;
  
  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;

CALL test();


/*ch 15 sql statement 1*/
DROP PROCEDURE IF EXISTS insert_category;

DELIMITER //

CREATE PROCEDURE insert_category
(
    category_name_param VARCHAR(255)
)
BEGIN
	INSERT INTO categories 
	  (category_id, category_name)
	VALUES 
      (DEFAULT, category_name_param);
END//

DELIMITER ;

-- Test fail: (Error Code: 1062. Duplicate entry 'Guitars' for key 'category_name')
CALL insert_category('Guitars');

-- Test pass:
CALL insert_category('Woodwinds');

-- Clean up:
DELETE FROM categories WHERE category_id = LAST_INSERT_ID();


/*ch 15 sql statement 2*/


DROP FUNCTION IF EXISTS discount_price;

DELIMITER //

CREATE FUNCTION discount_price
(item_id_param	INT(11))
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE discount_price_var DECIMAL(10,2);
    
  SELECT item_price - discount_amount
  INTO   discount_price_var
  FROM   order_items
  WHERE  item_id = item_id_param;
    
  RETURN discount_price_var;
END//

DELIMITER ;

-- Check:
SELECT item_id, item_price, discount_amount, 
       discount_price(item_id) as discount_price
FROM order_items;


/*ch 15 sql statement 3*/

DROP FUNCTION IF EXISTS item_total;

DELIMITER //

CREATE FUNCTION item_total
(
  item_id_param INT(11)
)
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE total_amount_var DECIMAL(10,2);
    
  SELECT quantity * DISCOUNT_PRICE(item_id_param)
  INTO   total_amount_var
  FROM   order_items
  WHERE  item_id = item_id_param;
    
  RETURN total_amount_var;
END//

DELIMITER ;

-- Check:
SELECT item_id, discount_price(item_id), quantity,
       item_total(item_id)
FROM order_items;

/*ch 15 sql statement 4*/

DROP PROCEDURE IF EXISTS insert_products;

DELIMITER //

CREATE PROCEDURE insert_products
(
  category_id_param      INT(11),
  product_code_param     VARCHAR(10),
  product_name_param     VARCHAR(255),
  list_price_param       DECIMAL(10,2),
  discount_percent_param DECIMAL(10,2)
)
BEGIN
  IF (list_price_param < 0) THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 'The list_price must be a positive number',
        MYSQL_ERRNO = 1264;
  END IF;
    
  IF (discount_percent_param < 0) THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 'The discount_percent must be a positive number',
        MYSQL_ERRNO = 1264;
  END IF;
    
  INSERT INTO products 
    (product_id, category_id, product_code,
     product_name, description, list_price, discount_percent, date_added)
  VALUES 
    (DEFAULT, category_id_param, product_code_param,
     product_name_param, '',list_price_param, discount_percent_param, NOW());
END//

DELIMITER ;

-- Tests fail:
CALL insert_products(1,'prodCod1','prodName1',-1,1);
CALL insert_products(1,'prodCod2','prodName2',1,-1);

-- Test pass:
CALL insert_products(1,'prodCod3','prodName3',1,1);

-- Cleanup:
DELETE FROM products WHERE product_id = 12;

-- Check:
SELECT product_id, category_id, product_code,
       product_name, list_price, discount_percent
FROM   products;

/*ch 15 sql statement 5*/

DROP PROCEDURE IF EXISTS update_product_discount;

DELIMITER //

CREATE PROCEDURE update_product_discount
(
  product_id_param         INT,
  discount_percent_param   DECIMAL(10,2)
)
BEGIN
  -- validate parameters
  IF discount_percent_param < 0 THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 'The discount percent must be a positive number.',
        MYSQL_ERRNO = 1264;  
  END IF;

  UPDATE products
  SET discount_percent = discount_percent_param
  WHERE product_id = product_id_param;
END//

DELIMITER ;

-- Test fail: 
CALL update_product_discount(1, -0.02);

-- Test pass: 
CALL update_product_discount(1, 30.5);

-- Check:
SELECT product_id, product_name, discount_percent 
FROM   products 
WHERE  product_id = 1;

-- Clean up: 
UPDATE products 
SET    discount_percent = 30.00
WHERE  product_id = 1;



































































































































































































