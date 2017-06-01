drop database if exists bp;
create database bp;
use bp;

create table blogposts
(
post_id 		int 			auto_increment	primary key,
post_title		varchar(64) 	not null,
post_text		varchar(1000) 	not null,
post_date 		date			not null
);

create table authors
(
author_id 		int				auto_increment 	primary key,
author_name		varchar(64)		not null,
author_affiliation varchar(64) 	not null,
author_email	varchar(64)		not null,
author_post		int				not null,
constraint author_post_fk 
	foreign key (author_post)
    references blogposts(post_id)
    on delete cascade
    on update cascade
);

create table readers
(
reader_id		int			auto_increment 	primary key,
reader_name		varchar(64)	not null,
reader_email	varchar(64)	not null,
reader_post		int			not null,
constraint	reader_post_fk
	foreign key (reader_post)
    references blogposts(post_id)
    on delete cascade
    on update cascade
);

create table comments
(
comment_id		int 		auto_increment 	primary key,
comment_creater	int			not null,
comment_date	date		not null,
comment_text	varchar(1000)	not null,
constraint comment_creater_fk
	foreign key (comment_creater)
    references	readers(reader_id)
    on delete cascade
    on update cascade
);

create table political_topics
(
political_topic	varchar(64)		primary key
);

create table key_phrases
(
key_phrase 		varchar(64)		primary key,
key_topic		varchar(64),
constraint key_topic_fk
	foreign key (key_topic)
    references political_topics(political_topic)
    on delete cascade
    on update cascade
);

create table instances
(
instance_id		int  	auto_increment 	primary key,
instance_position	int	not null,
instance_post		int,
instance_comment	int,
instance_phrase		varchar(64)		not null,
constraint	instance_phrase_fk
	foreign key (instance_phrase)
	references	key_phrases(key_phrase)
    on delete cascade
    on update cascade,
constraint	instance_post_fk
	foreign key (instance_post)
    references	blogposts(post_id)
    on delete cascade
    on update cascade,
constraint	instance_comment_fk
	foreign key (instance_comment)
    references	comments(comment_id)
    on delete cascade
    on update cascade
);


