use smartfridge;
select * from category;
select * from currentproviders;
select * from expired_items;
select * from expiring_items;
select * from fridgeusers;
select * from inventory;


drop procedure if exists p_apply_promotion;

delimiter //
create procedure p_apply_promotion (promotion_id int)
BEGIN
declare promotion_item_id int;
declare promotion_quantity int;
declare promotion_related int;
declare promotion_discount decimal(5,2);
declare promotion_price int;
declare related_item_price int;
declare promotion_item_name varchar(45);
declare related_item_name varchar(45);
declare promotion_item_provider int;
declare related_item_provider int;


select item_quantity, related_item, discount, prom_item
into promotion_quantity, promotion_related, promotion_discount, promotion_item_id
from promotions
where prom_id = promotion_id;

select pd_price, pd_name, provider_id
into promotion_price, promotion_item_name, promotion_item_provider
from product_details
where pd_id = promotion_item_id;

select pd_price, pd_name, provider_id
into related_item_price, related_item_name, related_item_provider
from product_details
where pd_id = promotion_related;

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
create procedure p_delete_promotion (shop_id int)
BEGIN
declare promotion_id int;
select prom_id 
into promotion_id
from shopping_list
where si_id = shop_id;

if promotion_id is null then
	delete from shopping_list where si_id = shop_id;
else 
	delete from shopping_list where prom_id = promotion_id;
    
    update promotions
	  set prom_flag = 'Y'
	  WHERE prom_id = (select prom_id from shopping_list where si_id = shop_id);
end if;

END//

DELIMITER ;
delete from shopping_list where prom_id = 2;

call p_apply_promotion(2);
call p_delete_promotion(4);

select * from product_details join providers on provider_id = 1;

select * from product_details;
select * from promotions;
select * from providers;
select * from currentproviders;
select * from shopping_list;
delete from shopping_list where si_quantity=1;