 /* * * * *
 **  -- test_001
 **  --    give a don from a donor to some manga and check it in the don table
 **  --  
 * * * * */ 



\! clear -- to clear the screen --

-- we have already the manga 'one piece'
-- we have already the donor 'hinata'

select give_a_don(
	(select id_donor from USER_DONOR where name_donor = 'hinata'),
	(select id_manga from MANGA where name_manga = 'one piece'),
	12,
	'i liked this manga soo muchh'
);

-- to verify whether our don is in the table DON
select * from DON;




















