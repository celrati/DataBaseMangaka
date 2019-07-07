 /* * * * * * * * * * * * * 
 **  -- test_003
 **  --    give a don from a donor to some manga , and go all over the steps and get the commission @@
 **    --    and the check the audit table
 * * * * */



\! clear

-- create new project manga with TOTO1
select create_new_manga(
	(select id_mangaka  from USER_MANGAKA where name_mangaka = 'hayao'),
	'boruto',
	'SHONEN',
	'99'
);

-- 
select give_a_don(
	(select id_donor from USER_DONOR where name_donor = 'hinata'),
	(select id_manga from MANGA where name_manga = 'boruto'),
	40,
	'boruto 1'
);

-- to verify the don
select * from DON;

select give_a_don(
	(select id_donor from USER_DONOR where name_donor = 'hinata'),
	(select id_manga from MANGA where name_manga = 'boruto'),
	60,
	'boruto 2'
);

-- to verify the don
select * from DON;

-- we can see clearly that the manga boruto is on step 2 right now and raise the amount by same pourcent
select * from MANGA;

-- we took the fisrt commission 
select * from COMMISSION;




select give_a_don(
	(select id_donor from USER_DONOR where name_donor = 'hinata'),
	(select id_manga from MANGA where name_manga = 'boruto'),
	40,
	'boruto 3'
);
-- to verify the don
select * from DON;

-- we can see clearly that the manga boruto is on step 3 right now and raise the amount by same pourcent
-- we can see the state of the manga is FINISHED now 
select * from MANGA;

-- we took the fisrt commission 
select * from COMMISSION;





-- audit  archivage
select * from AUDIT_MANGA;