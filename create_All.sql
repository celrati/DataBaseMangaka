-- a script to create all the tables --


drop table if exists DON cascade;  -- relation between MANGA and USER_DONOR --
drop table if exists CREATE_MANGA cascade;  -- relation between MANGA and USER_MANGAKA --

drop table if exists USER_DONOR cascade;
drop table if exists USER_MANGAKA cascade;
drop table if exists AUDIT_MANGA cascade;
drop table if exists MANGA cascade;


drop table if exists COMMISSION cascade;
drop table if exists REFUND cascade;
drop table if exists REPORT cascade;

drop table if exists GLOBAL_PARAM;
drop table if exists DATE_DATE;
drop table if exists REPORT_DONOR;
drop table if exists REPORT_MANGAKA;

create table USER_DONOR(
	id_donor serial primary key,
	name_donor varchar(32) not null,
	lastName_donor varchar(32) not null,
	pseudo varchar(31) not null,
	email varchar(32) not null,
	password varchar(32) not null,
	unique(pseudo)
);

create table USER_MANGAKA(
	id_mangaka serial primary key,
	name_mangaka varchar(32) not null,
	lastName_mangaka varchar(32) not null,
	pseudo varchar(32) not null,
	email varchar(32) not null,
	password varchar(32) not null,
	rating_mangaka integer,
	famous_manga_written varchar(32),
	check (rating_mangaka >= 0  and rating_mangaka <= 5),
	unique(pseudo)
);

-- this table contains all the operations --
create table AUDIT_MANGA (
	id_audit serial primary key,
	pseudo varchar(32) not null,
	operation_name varchar(32) not null,
	operation_date date not null,
	check (operation_name in ('CREATE_MANGA', 'GIVE_DON', 'NEW_MANGAKA', 'NEW_DONOR'))
	-- here we have foreign key that point to two types of user mangaka and donor --
);

create table MANGA(
	id_manga serial primary key,
	name_manga varchar(32) not null,
	state_manga varchar(32) not null default 'IN_PROGRESS' ,
	theme_manga varchar(32) not null,
	step_manga integer not null default 1,
	sum_needed integer not null,
	check ( theme_manga in ('SHONEN','SEINEN','KODOMO','HENTEI','SHOJO')),
	check ( state_manga in ('IN_PROGRESS','FINISHED','STOPPED')),
	check (step_manga >= 1 and step_manga <= 3),
	unique(name_manga)
);



-- we have to implement two relations DON and CREATE_MANGA

create table DON(
	id_don serial primary key,
	id_donor integer not null references USER_DONOR,
	id_manga integer not null references MANGA,
	how_much integer not null,
	donation_date date not null,
	donor_comment varchar(128) 
);

create table CREATE_MANGA(
	id_create_manga serial primary key,
	id_mangaka integer not null references USER_MANGAKA,
	id_manga integer not null references MANGA,
	creation_date date not null
);


create table COMMISSION(
	id_commission serial primary key,
	id_manga integer not null references MANGA,
	sum_taken integer not null
);

create table REFUND(
	id_refund serial primary key,
	sum_to_refund integer not null,
	id_donor integer not null references USER_DONOR
);


create table REPORT_DONOR(
	id_report serial primary key,
	id_donor integer not null references USER_DONOR,
	message_to_report varchar(128) not null
);
create table REPORT_MANGAKA(
	id_report serial primary key,
	id_mangaka integer not null references USER_MANGAKA,
	message_to_report varchar(128) not null
);


create table GLOBAL_PARAM(
	id_global_param serial primary key,
	param_name varchar(16) not null,
	param_value int not null
);

create table DATE_DATE(
	id_date serial primary key,
	date_date date
);



/**
  -- INDEXES --
*/
CREATE UNIQUE INDEX ON USER_DONOR (pseudo,password);
CREATE UNIQUE INDEX ON USER_MANGAKA (pseudo,password);
CREATE INDEX ON DON (id_don,donation_date);