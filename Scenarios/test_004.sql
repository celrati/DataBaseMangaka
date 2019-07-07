
/* * * * * * * * 
**  -- test_004                     
**  -- we have to close the project (Concerns Date)
* * * * * * * * * * */




\! clear

-- we're gonna change the date of the project 
-- id_manga = 1 is for the project 'one piece'


-- we give some dons
select give_a_don(1,1,20,'don1');
select give_a_don(1,1,30,'don2');


-- change the date of the manga 'one piece'
update CREATE_MANGA set creation_date = '2017-01-01' where id_manga = 1;


-- now we're gonna have error because 
select give_a_don(1,1,40,'don3');


-- the system gonna remove all the dons for this manga
-- and do refunding
select * from REFUND;
select * from DON;






































