 /* * * * *
 **  -- test_000 
 **  --  creation of new Manga Project by a mangaka @@
 **  --  
 * * * * */ 


\! clear -- to clear the screen --

-- insert a new mangaka
insert into USER_MANGAKA(name_mangaka,lastName_mangaka,pseudo,email,password,rating_mangaka,famous_manga_written) 
	values('TOTO1','TTTI1','****','mail@g.c','1233',5,'spirited away');


-- to verify whether is in the table
select * from USER_MANGAKA where name_mangaka = 'TOTO1';

-- create the new manga 
select create_new_manga(
	(select id_mangaka  from USER_MANGAKA where name_mangaka = 'TOTO1'),
	'princesse mononoke',
	'SHONEN',
	'10000'
);


-- showing the result 
select * from MANGA;
select * from CREATE_MANGA;
