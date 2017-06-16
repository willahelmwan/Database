drop database if exists smartfridge;
create database smartfridge;
use smartfridge;

-- drop user if exists 'smartfridge'@'%';
-- create user 'smartfridge'@'%' identified by 'smart';
-- GRANT ALL PRIVILEGES ON *.* TO 'smartfridge'@'%';

CREATE TABLE providers (
  ProviderId int(11) NOT NULL AUTO_INCREMENT,
  ProviderName varchar(45) NOT NULL,
  PRIMARY KEY (ProviderId)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

CREATE TABLE currentproviders (
  CurrProviderId int(11) NOT NULL,
  CurrProviderNm varchar(45) NOT NULL,
  PRIMARY KEY (CurrProviderId),
  CONSTRAINT currprovdid FOREIGN KEY (CurrProviderId) REFERENCES providers (ProviderId) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table category (
	cat_id		int 	auto_increment primary key,
    cat_name	varchar(64)	not null
);

create table fridgeusers (
	Userid int NOT NULL AUTO_INCREMENT,
  	UserName varchar(45) NOT NULL,
  	UserPassword varchar(45) NOT NULL,
  	PRIMARY KEY (Userid),
  	UNIQUE KEY (UserName)
);

create table inventory (
	item_id		int auto_increment primary key,
    item_name	varchar(64) not null,
    item_quantity	int,
    item_cat	int,
    item_exp	date,
    item_pin	char default 'N',
    pin_threshold	int default 1,
    pin_quantity	int	default 1,
    constraint item_cat_fk 
		foreign key (item_cat) 
		references category(cat_id)
		on delete cascade
		on update cascade
);

create table product_details (
	pd_id			int auto_increment primary key,
    pd_name			varchar(64) not null,
    pd_price		int not null,
    pd_exp			date,
    provider_id		int,
    pd_cat 			int,
    pd_delvdays     int,
	constraint provider_id_fk
		foreign key (provider_id)
        references providers(providerid)
        on delete cascade
        on update cascade,
	constraint provider_cat_id_fk
		foreign key (pd_cat)
        references category(cat_id)
        on delete cascade
        on update cascade
);

create table promotions (
	prom_id 		int 	auto_increment	primary key,
    prom_item		int,
    prom_detail		varchar(1000), 
    item_quantity	int default 1,
    related_item	int,
    discount		int default 1,
    prom_flag		varchar(10) default 'Y',
	constraint prom_item_fk
		foreign key (prom_item)
        references product_details(pd_id)
        on delete cascade
        on update cascade
);

create table expired_items (
	item_id		int,
    item_name	varchar(64) not null,
    date_exp	date	not null,
    constraint item_id_fk
		foreign key (item_id)
        references inventory(item_id)
        on delete cascade
        on update cascade
);

create table expiring_items (
	item_id		int,
    item_name	varchar(64) not null,
    days_exp	int		not null,
    constraint item_ei_id_fk
		foreign key (item_id)
        references inventory(item_id)
        on delete cascade
        on update cascade
);

create table shopping_list (
	si_id			int		auto_increment primary key,
    si_name			varchar(64)		not null,
    si_quantity		int		not null,
    lowest_provider	varchar(64),
    lowest_price	int,
    order_flag		varchar(20), -- NotOrdrd Ordrd Arrived
    pd_id			int,
    prom_id			int,
    constraint shopping_pdid_fk 
		foreign key (pd_id) 
		references product_details(pd_id)
		on delete cascade
		on update cascade
);