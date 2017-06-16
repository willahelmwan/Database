use smartfridge;

INSERT INTO Providers VALUES (1,'Amazon'),(2,'Walmart'),(3,'Target'),(4,'MarketBasket');

insert into category(cat_name) values ('Beverages'), ('Vegetables'), ('Fruits'), ('Protein'), ('Miscellaneous');

-- beverages from Amazon
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pepsi',3,'2018-06-04',1, 1, 4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Juice',5,'2017-09-10',1, 1, 3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Wine',2,null,1, 1, 2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange Juice',10,'2017-09-28',1, 1, 7);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Beer',7,null,1, 1, 9);

-- Vegetables from Amazon
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Potato',3,'2017-07-04',1, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Spinach',5,'2017-07-10',1, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Carrot',2,'2017-07-25',1, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Cauliflower',10,'2017-07-28',1, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Eggplant',7,'2017-07-30',1, 2,2);

-- Fruits from Amazon
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple',3,'2017-07-04',1, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange',5,'2017-07-10',1, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Strawberry',2,'2017-07-25',1, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Peach',10,'2017-07-28',1, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pear',7,'2017-07-30',1, 3,3);

-- Protein from Amazon
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Chicken Nuggets',3,'2017-10-04',1, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Fish',5,'2017-10-10',1, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ground Beef',2,'2017-10-25',1, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Breakfast Sausage',7,'2017-10-30',1, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Milk',5,'2017-07-30',1, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Yogurt',1,'2017-08-30',1, 4,4);

-- Miscellaneous from Amazon
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ice Cream',10,'2018-06-28',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Sauce',3,'2018-06-04',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mayonnaise',5,'2018-06-10',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Salad Dressing',2,'2018-06-25',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Vanilla Extract',10,'2019-06-28',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mustard',7,'2018-06-30',1, 5, 5);


-- beverages from Walmart
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pepsi',8,'2018-06-06',2, 1, 7);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Juice',3,'2017-07-10',2, 1, 3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Wine',6,null,2, 1, 2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange Juice',9,'2017-09-28',2, 1, 9);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Beer',5,null,2, 1, 4);

-- Vegetables from Walmart
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Potato',3,'2017-08-04',2, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Spinach',5,'2017-08-10',2, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Carrot',2,'2017-07-25',2, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Cauliflower',10,'2017-08-28',2, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Eggplant',7,'2017-07-30',2, 2,2);

-- Fruits from Walmart
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple',3,'2017-07-04',2, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange',5,'2017-07-10',2, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Strawberry',2,'2017-07-25',2, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Peach',10,'2017-07-28',2, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pear',7,'2017-08-30',2, 3,3);

-- Protein from Walmart
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Chicken Nuggets',3,'2017-09-04',2, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Fish',5,'2017-09-10',2, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ground Beef',2,'2017-07-22',2, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Breakfast Sausage',7,'2017-07-30',2, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Milk',4,'2017-07-30',2, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Yogurt',2,'2017-08-30',2, 4,4);

-- Miscellaneous from Walmart
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ice Cream',10,'2018-06-28',2, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Sauce',3,'2018-06-14',2, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mayonnaise',5,'2018-06-11',2, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Salad Dressing',2,'2018-06-25',2, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Vanilla Extract',10,'2020-07-28',2, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mustard',7,'2018-05-30',2, 5, 5);


-- beverages from Target
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pepsi',3,'2018-06-06',3, 1, 1);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Juice',1,'2017-07-10',3, 1, 3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Wine',16,null,3, 1, 4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange Juice',8,'2017-09-28',3, 1, 2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Beer',4,null,3, 1, 3);

-- Vegetables from Target
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Potato',2,'2017-08-04',3, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Spinach',4,'2017-08-10',3, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Carrot',7,'2017-07-25',3, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Cauliflower',6,'2017-08-28',3, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Eggplant',4,'2017-07-30',3, 2,2);

-- Fruits from Target
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple',1,'2017-07-04',3, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange',5,'2017-07-10',3, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Strawberry',2,'2017-07-25',3, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Peach',4,'2017-07-28',3, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pear',9,'2017-08-30',3, 3,3);

-- Protein from Target
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Chicken Nuggets',3,'2017-09-04',3, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Fish',4,'2017-09-10',3, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Lunchmeat',1,'2018-07-22',3, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Breakfast Sausage',9,'2017-07-30',3, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Milk',2,'2017-07-30',3, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Yogurt',6,'2017-08-30',3, 4,4);

-- Miscellaneous from Target
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ice Cream',5,'2018-06-28',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Sauce',4,'2018-06-14',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mayonnaise',7,'2018-06-11',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Salad Dressing',2,'2018-06-25',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Vanilla Extract',10,'2020-07-28',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mustard',3,'2018-05-30',3, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ketchup',4,'2018-09-30',3, 5, 5);


-- beverages from MarketBasket
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Coke Cola',10,'2018-06-04',4, 1, 4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Juice',15,'2017-09-10',4, 1, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Wine',20,null,4, 1, 2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange Juice',16,'2017-09-28',4, 1, 8);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Beer',17,null,4, 1, 4);

-- Vegetables from MarketBasket
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Sweet Potato',6,'2017-07-04',4, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Spinach',9,'2017-07-10',4, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Carrot',4,'2017-07-25',4, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Cauliflower',5,'2017-07-28',4, 2,2);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Eggplant',14,'2017-07-30',4, 2,2);

-- Fruits from MarketBasket
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple',6,'2017-07-04',4, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Orange',6,'2017-07-10',4, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Blueberry',6,'2017-07-25',4, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Peach',8,'2017-07-28',4, 3,3);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Pear',10,'2017-07-30',4, 3,3);

-- Protein from MarketBasket
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Chicken Nuggets',3,'2017-10-04',4, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Fish',5,'2017-10-10',4, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ground Beef',2,'2017-10-25',4, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Breakfast Sausage',7,'2017-11-30',4, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Milk',5,'2017-07-30',4, 4,4);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Yogurt',1,'2017-08-30',4, 4,4);

-- Miscellaneous from MarketBasket
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Ice Cream',10,'2018-06-28',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Apple Sauce',3,'2018-06-04',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mayonnaise',5,'2018-06-10',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Salad Dressing',2,'2018-06-25',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Vanilla Extract',10,'2019-06-28',1, 5, 5);
insert into product_details (pd_name, pd_price, pd_exp,provider_id, pd_cat, pd_delvdays) values ('Mustard',7,'2018-06-30',1, 5, 5);


-- Promotion
insert into promotions (prom_item, prom_detail, item_quantity, related_item, discount, prom_flag) 
			values (4,'Buy one orange juice get one free.', 2, null, default, default);
insert into promotions (prom_item, prom_detail, item_quantity, related_item, discount, prom_flag) 
			values (4,'Buy one orange juice and one apple juice together to get 50% off on both items.', 1, 2, 1, default);
			
