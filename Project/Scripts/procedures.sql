use smartfridge;

drop PROCEDURE if EXISTS p_check_expiry_items_inventory;

DELIMITER //
CREATE PROCEDURE p_check_expiry_items_inventory ()
BEGIN
DECLARE itemId int;
DECLARE itemName VARCHAR(64);
DECLARE expiredDate date;
DECLARE daysToExpire int;
DECLARE rowData int;
DECLARE rowData1 int;

DECLARE expiredItemsCur CURSOR FOR 
		select item_id, item_name, item_exp 
		from inventory 
		where item_exp <= CURDATE();

DECLARE expiringItemsCur CURSOR FOR 
		select item_id, item_name, (item_exp - CURDATE())
		from inventory 
		where item_exp > CURDATE() and item_exp between CURDATE() and CURDATE() + 5;

delete from expired_items;
delete from expiring_items;

-- populate expired items table
OPEN expiredItemsCur;
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET rowData = 1;
expiredLoop:LOOP
    FETCH expiredItemsCur INTO itemId, itemName, expiredDate;
    IF rowData = 1 THEN
    	LEAVE expiredLoop;
    END IF;
    IF NOT EXISTS (select * from expired_items where item_id = itemId) THEN
    	insert into expired_items values (itemId, itemName, expiredDate); 
    END IF;
END LOOP expiredLoop;
END;
CLOSE expiredItemsCur;

-- populate expiring items table
OPEN expiringItemsCur;
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET rowData1 = 1;
	expiringLoop:LOOP
    FETCH expiringItemsCur INTO itemId, itemName, daysToExpire;
    IF rowData1 = 1 THEN
    	LEAVE expiringLoop;
    END IF;
    IF NOT EXISTS (select * from expiring_items where item_id = itemId) THEN
    	insert into expiring_items values (itemId, itemName, daysToExpire);
    END IF;
END LOOP expiringLoop;
END;
CLOSE expiringItemsCur;
end//

DELIMITER ; 


drop PROCEDURE if EXISTS p_pin_item_inventory;

DELIMITER //
create PROCEDURE p_pin_item_inventory(IN itemNm VARCHAR(64))
BEGIN
	DECLARE currPinVal char; 
	declare quant int;
	-- get current pin value of item id
	select item_pin into currPinVal from inventory where item_name = itemNm limit 1;
	-- if N update to Y, else if Y update to N, if updating to Y change pin threshold and quantity to default 2
	 
	if(currPinVal = 'Y') THEN
		update inventory set item_pin = 'N', pin_threshold = 0, pin_quantity = 0  where item_name = itemNm;
	elseif(currPinVal = 'N') THEN
		update inventory set item_pin = 'Y', pin_threshold = 2, pin_quantity = 2 where item_name = itemNm;
	end if;
	
	select item_pin into currPinVal from inventory where item_name = itemNm limit 1;
	select sum(item_quantity) into quant from inventory where item_name = itemNm;
	if(currPinVal = 'N' AND quant = 0) THEN
		delete from inventory where item_name = itemNm;
	end if;
END//

DELIMITER ;  


drop PROCEDURE if EXISTS p_add_item_inventory;

DELIMITER //
create PROCEDURE p_add_item_inventory(IN itemId int)
BEGIN
	if EXISTS (select * from inventory where item_id = itemId) then 
		update inventory set item_quantity = item_quantity + 1 where item_id = itemId;
	end if;
END//

DELIMITER ; 


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
	
	declare siQuantity int;
	declare provideNm VARCHAR(64);
	
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
	
		-- select pd_name, pd_price, provider_id, pd_id
		-- into pdName, pdPrice, providerId, pdId
		-- from product_details where pd_name = itemNm order by pd_price asc limit 1;
		
		select pd.pd_name, pd.pd_price, p.ProviderName, pd.pd_id
		into pdName, pdPrice, provideNm, pdId
		from product_details pd, providers p where pd.provider_id = p.ProviderId and pd.pd_name = itemNm order by pd.pd_price asc limit 1;
		
		-- select ProviderName into provideNm from providers where ProviderId = providerId;
		
		if not EXISTS (select * from shopping_list where si_name = pdName and order_flag = 'Y') THEN
			insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
			values (pdName, pinQuant, provideNm, pdPrice, 'Y', pdId);
		elseif exists (select * from shopping_list where si_name = pdName and order_flag = 'Y') THEN
			-- check the already ordered quantity, place order if thershold quant is more otherwise no order
			select sum(si_quantity) into siQuantity from shopping_list where si_name = pdName and order_flag = 'Y';
			
			if(siQuantity < pinQuant) THEN
				insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
				values (pdName, (pinQuant - siQuantity), provideNm, pdPrice, 'Y', pdId);
			end if;
		end if;
		
	end if;
	
END//

DELIMITER ; 


drop PROCEDURE if EXISTS p_update_pinItem_inventory;

DELIMITER //
create PROCEDURE p_update_pinItem_inventory(IN itemNm varchar(64), IN thres int, quant int)
BEGIN
	DECLARE totalQuant int;
	declare pinVal char;
	declare pinThres int;
	declare pinQuant int;
	
	declare pdName varchar(64);
	declare pdPrice int;
	declare providerId int;
	declare pdId int;
	declare provideNm VARCHAR(64);
	declare siQuantity int;
	
	if EXISTS (select * from inventory where item_name = itemNm and item_pin = 'Y') then 
		update inventory set pin_threshold = thres, pin_quantity = quant where item_name = itemNm;
	end if;
	
	-- check if item quantity is less than threshold, place a new order 
	select sum(item_quantity) into totalQuant from inventory where item_name = itemNm;
	
	select item_pin, pin_threshold, pin_quantity 
	into pinVal, pinThres, pinQuant from inventory where item_name = itemNm limit 1;
	
	if(pinThres > totalQuant) THEN
		-- select pd_name, pd_price, provider_id, pd_id
		-- into pdName, pdPrice, providerId, pdId
		-- from product_details where pd_name = itemNm order by pd_price asc limit 1;
		
		select pd.pd_name, pd.pd_price, p.ProviderName, pd.pd_id
		into pdName, pdPrice, provideNm, pdId
		from product_details pd, providers p where pd.provider_id = p.ProviderId and pd.pd_name = itemNm order by pd.pd_price asc limit 1;
		
		-- select ProviderName into provideNm from providers where ProviderId = providerId;
		
		if not EXISTS (select * from shopping_list where si_name = pdName and order_flag = 'Y') THEN
			insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
			values (pdName, pinQuant, provideNm, pdPrice, 'Y', pdId);
		elseif exists (select * from shopping_list where si_name = pdName and order_flag = 'Y') THEN
			-- check the already ordered quantity, place order if thershold quant is more otherwise no order
			select sum(si_quantity) into siQuantity from shopping_list where si_name = pdName and order_flag = 'Y';
			
			if(siQuantity < pinQuant) THEN
				insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
				values (pdName, (pinQuant - siQuantity), provideNm, pdPrice, 'Y', pdId);
			end if;
		end if;
	end if;
	
END//

DELIMITER ; 


DELIMITER ; 

drop PROCEDURE if EXISTS p_add_shopping_items;

DELIMITER //
create procedure p_add_shopping_items(prodNm VARCHAR(64), quant int, provNm VARCHAR(64), price int, vendorId int)
BEGIN
	DECLARE prodId int;
	
	select pd_id into prodId from product_details where pd_name = prodNm and provider_id = vendorId;
	
	insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id)
	VALUES (prodNm, quant, provNm, price, 'N', prodId);
END//

DELIMITER ; 

drop PROCEDURE if EXISTS p_add_manual_item_inventory;

DELIMITER //
create PROCEDURE p_add_manual_item_inventory(IN itemNm VARCHAR(64), IN quant int, IN catId int, IN expDt date)
BEGIN
	DECLARE invItemPinThres int;
	DECLARE invItemPinQuant int;
	DECLARE invItemPin char;
	DECLARE siname VARCHAR(64);
	DECLARE siquant int;
	DECLARE sid int;
	
	if EXISTS (select * from inventory where item_name = itemNm) THEN
		select item_pin, pin_threshold, pin_quantity into invItemPin,invItemPinThres, invItemPinQuant
		from inventory where upper(item_name) = upper(itemNm) limit 1;
		
		insert into inventory (item_name, item_quantity, item_cat, item_exp, item_pin, pin_threshold, pin_quantity) 
    	VALUES (itemNm, quant, catId, expDt, invItemPin, invItemPinThres, invItemPinQuant);
	ELSE
		insert into inventory (item_name, item_quantity, item_cat, item_exp) 
    	VALUES (itemNm, quant, catId, expDt);
	end if;
	
	if exists (select * from shopping_list where si_name = itemNm and order_flag = 'N') THEN
		select si_id, si_name, si_quantity into sid, siname, siquant
		from shopping_list where order_flag = 'N' and si_name = itemNm;
		
		if ((quant > siquant) or (quant = siquant)) THEN
			-- delete from shopping list
			delete from shopping_list where si_id = sid;
		ELSE
			-- decrease quantity from shopping list
			update shopping_list set si_quantity = (si_quantity - quant) where si_id = sid;
		end if;
	end if;
END//

DELIMITER ;

drop PROCEDURE if EXISTS p_del_pin_zero_quant_items;

DELIMITER //
create PROCEDURE p_del_pin_zero_quant_items()
BEGIN
	DECLARE itemId int;
	DECLARE rowData int;
	
	DECLARE itemsToDelete CURSOR FOR
		select i1.item_id
		from inventory i1 
		where i1.item_quantity = 0 and i1.item_pin = 'Y' 
		and not exists 
			(select * from inventory i2 
			where i1.item_name = i2.item_name and i2.item_pin = 'Y' 
			having sum(i2.item_quantity) = 0);
			
	OPEN itemsToDelete;
	BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET rowData = 1;
	itemsToDeleteLoop:LOOP
	    FETCH itemsToDelete INTO itemId;
	    IF rowData = 1 THEN
	    	LEAVE itemsToDeleteLoop;
	    END IF;
	    	delete from inventory where item_id = itemId;
	END LOOP itemsToDeleteLoop;
	END;
	CLOSE itemsToDelete;
END//

DELIMITER ;


drop procedure if exists p_apply_promotion;

delimiter //
create procedure p_apply_promotion (promotion_id int)
BEGIN
declare promotion_item_id int;
declare promotion_quantity int;
declare promotion_related int;
declare promotion_discount int;
declare promotion_price int;
declare related_item_price int;
declare promotion_item_name varchar(45);
declare related_item_name varchar(45);
declare promotion_item_provider varchar(45);
declare related_item_provider varchar(45);


select item_quantity, related_item, discount, prom_item
into promotion_quantity, promotion_related, promotion_discount, promotion_item_id
from promotions
where prom_id = promotion_id;

select pd.pd_price, pd.pd_name, p.ProviderName
into promotion_price, promotion_item_name, promotion_item_provider
from product_details pd, providers p
where pd.pd_id = promotion_item_id
and pd.provider_id = p.ProviderId;

select pd.pd_price, pd.pd_name, p.ProviderName
into related_item_price, related_item_name, related_item_provider
from product_details pd, providers p
where pd_id = promotion_related
and pd.provider_id = p.ProviderId;

update promotions set prom_flag = 'N' where prom_id = promotion_id;

if promotion_related is null then
	insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id, prom_id)
		values (promotion_item_name, promotion_quantity, promotion_item_provider, promotion_price*promotion_discount, 'N', promotion_item_id, promotion_id);
else
	insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id, prom_id)
		values (promotion_item_name, promotion_quantity, promotion_item_provider, promotion_price*promotion_discount, 'N', promotion_item_id, promotion_id);
	insert into shopping_list (si_name, si_quantity, lowest_provider, lowest_price, order_flag, pd_id, prom_id)
		values (related_item_name, 1, related_item_provider, related_item_price*promotion_discount, 'N', promotion_related, promotion_id);
end if;

END//

DELIMITER ;

drop procedure if exists p_delete_promotion;

delimiter //
create procedure p_delete_promotion (promotion_id int)
BEGIN

update promotions
  set prom_flag = 'Y'
  WHERE prom_id = promotion_id;

delete from shopping_list where prom_id = promotion_id;

END//

DELIMITER ;