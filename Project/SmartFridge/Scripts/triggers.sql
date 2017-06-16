use smartfridge;


drop trigger if exists t_shopping_list_after_ins_update_inventory;

DELIMITER //
CREATE TRIGGER t_shopping_list_after_ins_update_inventory
  AFTER UPDATE ON shopping_list
  FOR EACH ROW 
BEGIN
	
	DECLARE itemCat int;
	DECLARE itemExp date;
	DECLARE invItemPinThres int;
	DECLARE invItemPinQuant int;
	DECLARE invItemPin char;
	
	if (new.order_flag = 'A') THEN
		Select pd_cat, pd_exp into itemCat, itemExp from product_details where pd_id = new.pd_id;
	
	    if EXISTS (select * from inventory where item_name = new.si_name) THEN
			select item_pin, pin_threshold, pin_quantity into invItemPin,invItemPinThres, invItemPinQuant
			from inventory where item_name = new.si_name limit 1;
			
			insert into inventory (item_name, item_quantity, item_cat, item_exp, item_pin, pin_threshold, pin_quantity) 
	    	VALUES (new.si_name, new.si_quantity, itemCat, itemExp, invItemPin, invItemPinThres, invItemPinQuant);
		ELSE
			insert into inventory (item_name, item_quantity, item_cat, item_exp) 
	    	VALUES (new.si_name, new.si_quantity, itemCat, itemExp);
		end if;
	end if;
end//

DELIMITER ;