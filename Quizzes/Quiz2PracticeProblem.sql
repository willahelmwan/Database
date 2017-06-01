drop database if exists notownrecords;
create database notownrecords;

use notownrecords;

create table musicians
(
musician_ssn 		int 		primary key,
musician_name		varchar(50) not null,
musician_addressid	int			not null,
musician_phone		int,
constraint musician_address_fk
	foreign key (musician_addressid)
    references addresses(address_id)
    on delete cascade
    on update cascade
);

create table addresses
(
address_id			int 		auto_increment,
address_street		varchar(50)	not null,
address_city		varchar(50) not null,
address_state		varchar(50) not null,
address_zip			int			not null
);

create table instruments
(
instrument_id		int			auto_increment,
instrument_name		varchar(50)	not null,
instrument_key		varchar(50)	not null
);

create table albums
(
album_id 			int 		auto_increment,
album_title			varchar(50)	not null,
album_date			date		not null,
album_format		varchar(50) not null,
album_producer		int			not null,
constraint album_producer_fk
	foreign key (album_producer)
    references musicians(musician_ssn)
    on delete cascade
    on update cascade
);

create table songs
(
song_id			int			auto_increment,
song_title		varchar(50) not null,
song_author		int			not null,
song_album		int			not null,
constraint song_author_fk
	foreign key (song_author)
    references musicians(musician_ssn)
    on delete cascade
    on update cascade,
constraint song_album_fk
	foreign key (song_album)
    references albums(album_id)
    on delete cascade
    on update cascade
);



