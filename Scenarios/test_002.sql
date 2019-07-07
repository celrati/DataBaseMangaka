 /* * * * *
 **  -- test_002
 **  --    give a don from a donor to some manga , and trigger the case when the sum to give is
 **  --         inf to 10 or sup to 100    the min max to give
 * * * * */




\! clear -- to clear the screen --

-- we have already the manga 'one piece'
-- we have already the donor 'hinata'

select give_a_don(
	(select id_donor from USER_DONOR where name_donor = 'hinata'),
	(select id_manga from MANGA where name_manga = 'one piece'),
	120,
	'i liked this manga soo muchh 1'
);

-- to verify whether our don is in the table DON
select * from DON;

