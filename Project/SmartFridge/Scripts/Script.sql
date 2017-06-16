drop PROCEDURE if EXISTS p_delete_item_inventory;

DELIMITER //
create PROCEDURE p_delete_item_inventory(IN itemNm VARCHAR(64))
BEGIN
	declare pinVal char;
	declare quant int;
	declare itemId int;
	declare pinThres int;
	declare pinQuant int;
	declare pdName varchar(64);
	declare pdPrice int;
	declare providerId int;
	declare pdId int;
	
	select item_pin, pin_threshold, pin_quantity into pinVal, pinThres, pinQuant from inventory where item_name = itemNm limit 1;
	
	select item_id into itemId from inventory WHERE item_name = itemNm and item_quantity > 0 limit 1;
	
	if EXISTS (select * from inventory where item_name = itemNm and item_quantity > 0) then 
		update inventory set item_quantity = item_quantity - 1 where item_id = itemId;
	end if;
	
	select sum(item_quantity) into quant from inventory where item_name = itemNm;
	
	if(pinVal = 'N' AND quant = 0) THEN
		delete from inventory where item_name = itemNm and item_quantity = 0;
	end if;
	
	delete from inventory where item_quantity = 0 and item_pin = 'N' and item_name = itemNm;
	
	-- check for pin auto order, if quant is less than pin threshold
	if(pinVal = 'Y' AND (pinThres > quant)) THEN
	
		select pd_name, pd_price, provider_id, pd_id
		into pdName, pdPrice, providerId, pdId
		from product_details where pd_name = itemNm order by pd_price asc limit 1;
		
		if not EXISTS (select * from shopping_list where si_name = pdName and order_flag = 'Y') THEN
			insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
			values (pdName, pinQuant, providerId, pdPrice, 'Y', pdId);
		end if;
		
	end if;
	
END//

DELIMITER ;

-- select * from shopping_list;

-- select * from product_details where pd_name = 'Beer' order by pd_price asc limit 1;