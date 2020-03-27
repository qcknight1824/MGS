/*ch 16 sql statement 1*/
   delimiter //

   create trigger products_before_update
   before update on products
   for each row
   begin
       declare msg varchar(150);
       if new.discount_percent < 0 then
           set msg = concat('discount percent < 0');
           signal sqlstate '45000' set message_text = msg;
       else if new.discount_percent >100.0 then
           set msg = concat('discount percent > 100');
           signal sqlstate '45000' set message_text = msg;
       else if new.discount_percent <1.0 then
           set new.discount_percent = (NEW.discount_percent * 100);
       else
           set new.discount_percent = (NEW.discount_percent);
       end if;
       end if;
       end if;
   end
   //

   delimiter ;
   
   update products
   SET discount_percent = 1500;
   
/*ch 16 sql statement 2*/
   
delimiter //

create trigger Products_Insert
after insert on products
for each row
begin
UPDATE products
 SET new.date_added=curdate()
 WHERE new.date_added is null;
end
//

insert into products (product_name, category_id, product_code, description, list_price, discount_percent)
values ('XXXXXXX_TEST', 5, 5, 'TEST TRIGGER', 9999.99, 99);

/*ch 16 sql statement 3*/

CREATE TABLE ProductsAudit (
AuditID int NOT NULL AUTO_INCREMENT,
product_id int(11) NOT NULL,
category_id int(11) NOT NULL,
product_code varchar(10) NOT NULL,
product_name varchar(255) NOT NULL,
list_price decimal(10,2) NOT NULL,
discount_percent decimal(10,2) NOT NULL DEFAULT '0.00',
DateUpdated datetime DEFAULT NULL,
PRIMARY KEY (AuditID)
);


   delimiter //

   create trigger Products_UPDATE
   after update on products
   for each row
   begin
    insert into ProductsAudit values(null,new.product_id, new.category_id,new.product_code,
    new.product_name,new.list_price, new.discount_percent, curdate());
   end
   //
    delimiter ;

UPDATE products

