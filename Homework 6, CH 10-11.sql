/*ch 11 sql statement 1*/

CREATE INDEX orders_order_date_ix
on ORDERS (order_date);

/*ch 11 sql statement 2*/

DROP DATABASE IF EXISTS my_web_db;
CREATE DATABASE my_web_db CHARSET utf8;
USE my_web_db;

DROP TABLE IF EXISTS downloads;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users
(
user_id       INT          PRIMARY KEY	AUTO_INCREMENT,
email_address VARCHAR(100) NOT NULL,
first_name    VARCHAR(45)  NOT NULL,
last_name     VARCHAR(45)  NOT NULL
) ENGINE = InnoDB;

CREATE TABLE products
(
product_id    INT          PRIMARY KEY  AUTO_INCREMENT,
product_name  VARCHAR(45)  NOT NULL
) ENGINE = InnoDB;

CREATE TABLE downloads
(
download_id   INT          PRIMARY KEY  AUTO_INCREMENT,
user_id	      INT,
download_date DATETIME,
filename      VARCHAR(50),
product_id    INT,
CONSTRAINT downloads_fk_products foreign key(product_id) 
            REFERENCES products (product_id),
CONSTRAINT downloads_fk_users foreign key(user_id)
            REFERENCES users (user_id)
) ENGINE = InnoDB;

/*ch 11 sql statement 3*/
INSERT INTO users (user_id, email_address, first_name, last_name) VALUES 
(1, 'johnsmith@gmail.com', 'john', 'smith'),
(2, 'janedoe@yahoo.com', 'jane', 'doe');

INSERT INTO products (product_id, product_name) VALUES
(1, 'Local Music Vol 1'),
(2, 'Local Music Vol 2');

INSERT INTO downloads (download_id, user_id, download_date, filename, product_id) VALUES
(1, 2, NOW(), 'turn_signal.mp3', 1),
(2, 1, NOW(), 'pedals_are_falling.mp3', 2),
(3, 2, NOW(), 'one_horse_town.mp3', 2);

SELECT a.email_address, a.first_name, a.last_name, b.download_date, b.filename, c.product_name
FROM users a
JOIN downloads b ON a.user_id=b.user_id
JOIN products c ON b.product_id=c.product_id
ORDER BY a.email_address DESC, c.product_name ASC;

/*ch 11 sql statement 4*/

ALTER TABLE products
ADD column product_price decimal(5,2) DEFAULT 9.99,
ADD column payment_date_and_time DATETIME;

/*ch 11 sql statement 5*/
ALTER TABLE users
MODIFY first_name VARCHAR(20) NOT NULL;

UPDATE users 
SET first_name = NULL
WHERE user_id = 1;
    
UPDATE users
SET first_name = '20_char_name_131415161718'
WHERE user_id = 1;




