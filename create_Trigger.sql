/**
*   triggers and functions ** /
*
**/


-- first functions is create new manga  --
/**
*    add new project for some mangaka he can specify which manga he want to create --
**/

--############################################### sending reports to donors or mangakas ¤¤¤¤¤¤¤¤¤¤¤¤


create or replace function send_report_to_donors(id_manga_1 int, report_to_send text) returns void as $$
declare
	cursor_donors refcursor; -- to loop over donors --
	id_donor_1 integer;
begin
	OPEN cursor_donors FOR select distinct id_donor from don where id_manga = id_manga_1;
	loop 
		fetch cursor_donors into id_donor_1;
		exit when not found;
		insert into REPORT_DONOR(id_donor,message_to_report) values(id_donor_1,report_to_send);
	end loop;

end;
$$ LANGUAGE plpgsql;


create or replace function send_report_to_mangaka(id_mangaka_1 int, report_to_send text) returns void as $$
begin
	insert into REPORT_MANGAKA(id_mangaka,message_to_report) values(id_mangaka_1,report_to_send);
end;
$$ LANGUAGE plpgsql;


create or replace function go_time() returns void as $$
begin
	update DATE_DATE set date_date = CURRENT_DATE where id_date = 1;
end;
$$ LANGUAGE plpgsql;	
-------------------------------------------------------------------------------------------------




create or replace function create_new_manga(
	id_mangaka_1 int, name_manga_1 text, theme_manga_1 text, sum_needed_1 int)
	returns void as $$

declare
	exist_mangaka boolean;
	id_new_manga_created integer;
begin
	-- check whether the id_mangaka exists or no --
	select count(*) = 1 into exist_mangaka from USER_MANGAKA where id_mangaka = id_mangaka_1;
	if not exist_mangaka then 
		raise 'ERROR:THE ID_MANGAKA % DOES NOT EXIST !',id_mangaka_1;
	end if;
	raise notice 'the id_mangaka % does exist in the table USER_MANGAKA',id_mangaka_1;
	-- now we have to add the new manga to the MANGA table --
	insert into MANGA(name_manga,state_manga,theme_manga,step_manga,sum_needed)
		values(name_manga_1,'IN_PROGRESS',theme_manga_1,1,sum_needed_1);
	select id_manga into id_new_manga_created from MANGA where name_manga = name_manga_1;
	-- now we have to insert the relation between MANGA and MANGAKA to the CREATE_MANGA table --
	insert into CREATE_MANGA(id_mangaka,id_manga,creation_date)
		values(id_mangaka_1,id_new_manga_created,CURRENT_DATE);
	-- send a report to mangaka to inform him that his mangaka is now in progress
	execute send_report_to_mangaka(id_mangaka_1,'YOUR PROJECT MANGA IS NOW IN PROGRESS');
end;
$$ LANGUAGE plpgsql;

/* 
*  to test this function
*	select create_new_manga(2,'manga1','SHONEN',100);
*/


-- ################################### a function to handle steps for the manga #####################



-- ##################################################################################################

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ check date and do refund ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤



create or replace function do_refunding(id_manga_1 int) returns void as $$
declare
	cursor_donors refcursor; -- to loop over the table donor
	row_don_to_fetch don%ROWTYPE;
begin
	-- we have to delete all don of this manga from don table
	-- and move 'em to the table refund
	OPEN cursor_donors FOR select * from don where id_manga = id_manga_1;
	raise notice 'fetching dons for manga % ',id_manga_1;
	loop 
		fetch cursor_donors into row_don_to_fetch;
		EXIT WHEN NOT FOUND;
		-- insert the data to refund --
		insert into REFUND(sum_to_refund,id_donor) values(row_don_to_fetch.how_much,row_don_to_fetch.id_donor);
	end loop;
	-- now we have to delete it from don
	delete from don where id_manga = id_manga_1;
end;
$$ LANGUAGE plpgsql;



-- _____________________________________________________________________________________________

-- ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤  GIVE A DON section begin ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤


-- a function to give a don to some manga by some user_donor

create or replace function give_a_don(id_donor_1 int, id_manga_1 int, how_much_1 int, comment_1 text ) returns void as $$
	-- this function does not verify anything at all it just fill the table DON and fire a trigger insert on DON --
	-- this function just for test --
declare
	state_manga_1 text;

	date_creation_manga date;
	limit_duration_manga int; -- count with months --
	duration_right_now int;
	date_now date;
	ret_bool boolean;
	id_mangaka_1 int;
	min_value int;
	max_value int;
begin
	raise notice 'trying to give a don !';

	select state_manga into state_manga_1 from MANGA where id_manga = id_manga_1;

	if state_manga_1 = 'STOPPED' then
		raise 'ERROR: this manga % is already closed !!!! ',id_manga_1;
	end if;

	ret_bool := false;
	-- check whether is it too late to give a don id the project, so we have to close the project 
	-- and refund the others donors

	raise notice 'checking date of manga .. ';
	 select creation_date into date_creation_manga from CREATE_MANGA join manga using(id_manga) where id_manga = id_manga_1;
	 select param_value into limit_duration_manga  from GLOBAL_PARAM where param_name = 'life_manga';

	 execute go_time(); -- to update the date of the SI --
	 select date_date into date_now from DATE_DATE where id_date = 1;

	 select (DATE_PART('year', date_now::date) - DATE_PART('year', date_creation_manga::date)) * 12 +
              (DATE_PART('month', date_now::date) - DATE_PART('month', date_creation_manga::date)) into duration_right_now;

     raise notice 'date of manga is : %',date_creation_manga;
     raise notice 'duration of a manga is %',limit_duration_manga;
     raise notice 'duration of this manga % is %',id_manga_1,duration_right_now;

     if (duration_right_now >= 4) then

		raise notice 'ERROR: the manga % is very old you cant give a don to it !!',id_manga_1;

		select id_mangaka into id_mangaka_1 from CREATE_MANGA where id_manga = id_manga_1;
		-- send report to mangaka and donor
		execute send_report_to_mangaka(id_mangaka_1,'your project is closed now');
		execute send_report_to_donors(id_donor_1,'the project is closed you cant give a don to it');

		-- here we do refunding
		raise notice 'we do refunding now ..';
		execute do_refunding(id_manga_1);
		ret_bool := true;
     end if;


     if ret_bool then
     	-- we have to close the project because it's to late
     	update MANGA set state_manga = 'STOPPED' where id_manga = id_manga_1;
     else
		select state_manga into state_manga_1 from MANGA where id_manga = id_manga_1;

		if state_manga_1 = 'FINISHED' then
			raise 'ERROR: this manga % is already finished ',id_manga_1;
		else
		-- test if the dum to give is respectin the min max
		select param_value into max_value from GLOBAL_PARAM where param_name = 'max_to_give';
		select param_value into min_value from GLOBAL_PARAM where param_name = 'min_to_give';
		if how_much_1 < min_value or how_much_1 > max_value then
			raise notice 'you cannot give this don its sup or inf to the normes';
			execute send_report_to_donors(id_donor_1,'YOU DID NOT GIVE A DON');
		else
			insert into DON(id_donor,id_manga,how_much,donation_date,donor_comment) 
				values(id_donor_1,id_manga_1,how_much_1,CURRENT_DATE,comment_1);
			execute send_report_to_donors(id_donor_1,'YOU GIVE A DON ');		
		end if;

		end if;
     end if;
end;
$$ LANGUAGE plpgsql;



-- here we have our functions that gets fired within the trigger to verify all --
create or replace function verify_before_give_a_don() returns trigger as $$
declare
	how_much_we_need_for_manga int;
	total_of_don_for_this_manga_rightnow int;
	okay_to_insert boolean;
	to_don_now int;
	exists_don int;
	commission_to_take int;
	step_manga_1 int;
	rate_to_add int;
begin
	
	select sum_needed into how_much_we_need_for_manga from MANGA where id_manga = new.id_manga;
	select count(*) into exists_don from DON where id_manga = new.id_manga;
	total_of_don_for_this_manga_rightnow := 0;
	if exists_don > 0 then
		select sum(how_much) into total_of_don_for_this_manga_rightnow from DON where id_manga = new.id_manga;
	end if;


	to_don_now := new.how_much;
	raise notice 'verify don ...';

	if total_of_don_for_this_manga_rightnow >= how_much_we_need_for_manga then
		raise 'ERROR: THE MANGA IS ALREADY REACHED THE SUM NEEDED !';
		return old;
	elseif (how_much_we_need_for_manga - total_of_don_for_this_manga_rightnow > to_don_now) then
		raise notice 'CONGRATS: THE DON IS GIVEN NOW THANK YOU !';
		return new;
	else 
		raise notice 'COOL WE REACHED THE SUM NEEDED !';
		raise notice 'WE NEED % but we have now % so we re gonna take % from you '
		,how_much_we_need_for_manga,total_of_don_for_this_manga_rightnow,(how_much_we_need_for_manga - total_of_don_for_this_manga_rightnow);
		new.how_much := how_much_we_need_for_manga - total_of_don_for_this_manga_rightnow;
		-- now we reached the sum needed we need to take the commission from the total sum --
		execute send_report_to_donors(new.id_donor,'we didnt take the entire amount of your donation only what was needed to finish the project ');
		select param_value into commission_to_take from GLOBAL_PARAM where param_name = 'commission_value';
		-- we insert the commission in the table COMMISSION --
		insert into COMMISSION(id_manga,sum_taken) 
			values(new.id_manga,((how_much_we_need_for_manga * commission_to_take / 100 )));

		-- we substract the commission from the sum in the MANGA table nothing is free !! --
		update MANGA
		 set sum_needed = sum_needed - ((how_much_we_need_for_manga * commission_to_take / 100 ))
		 where id_manga = new.id_manga;


		select step_manga into step_manga_1 from MANGA where id_manga = new.id_manga;
		raise notice 'The step for the manga % is %',new.id_manga,step_manga_1;
		-- a condition to know whether we need to go further or stop the don right here --

		if step_manga_1 = 1 then
			update MANGA 
				set step_manga = 2 
				where id_manga = new.id_manga;

			select param_value into rate_to_add from GLOBAL_PARAM where param_name = 'step_2';

			update MANGA
				set sum_needed = sum_needed + (sum_needed * rate_to_add / 100)
				where id_manga = new.id_manga;

		elseif step_manga_1 = 2 then
			update MANGA 
				set step_manga = 3 
				where id_manga = new.id_manga;	

			select param_value into rate_to_add from GLOBAL_PARAM where param_name = 'step_3';

			update MANGA
				set sum_needed = sum_needed + (sum_needed * rate_to_add / 100)
				where id_manga = new.id_manga;
			update MANGA 	
				set state_manga = 'FINISHED' where id_manga = new.id_manga;									
		end if;

		return new;
	end if;
end;
$$ LANGUAGE plpgsql;




-- now we have to create a trigger before insert on DON  to verify all the things related to our constraints --
drop trigger if exists don_giving on DON; 
-- here we check whether the trigger already exist ifsoo we drop it to create another again --
create trigger don_giving before insert on DON
	for each row
	-- this trigger will call the verify_before_give_a_don function --
		execute procedure verify_before_give_a_don();

-- ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤  GIVE A DON section end ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤


-- ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ we' re gonna handle the audit here begin ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤


create or replace function fill_audit() returns trigger as $$
begin
	if TG_ARGV[0] = 'MANGAKA' then
		insert into AUDIT_MANGA(pseudo,operation_name,operation_date) 
			values(new.pseudo,'NEW_MANGAKA',CURRENT_DATE);
	elseif TG_ARGV[0] = 'DONOR' then
		insert into AUDIT_MANGA(pseudo,operation_name,operation_date) 
			values(new.pseudo,'NEW_DONOR',CURRENT_DATE);
	elseif TG_ARGV[0] = 'DON' then
		insert into AUDIT_MANGA(pseudo,operation_name,operation_date) 
			values(new.id_donor,'GIVE_DON',CURRENT_DATE);
	elseif TG_ARGV[0] = 'MANGA' then
		insert into AUDIT_MANGA(pseudo,operation_name,operation_date) 
			values(new.id_mangaka,'CREATE_MANGA',CURRENT_DATE);
	end if;
	return NULL;
end;
$$ LANGUAGE plpgsql;




drop trigger if exists creating_new_mangaka on USER_MANGAKA;
create trigger creating_new_mangaka after insert on USER_MANGAKA
	for each row
		execute procedure fill_audit('MANGAKA');

drop trigger if exists creating_new_donor on USER_DONOR;
create trigger creating_new_donor after insert on USER_DONOR
	for each row
		execute procedure fill_audit('DONOR');

drop trigger if exists creating_new_manga on CREATE_MANGA;
create trigger creating_new_manga after insert on CREATE_MANGA
	for each row
		execute procedure fill_audit('MANGA');

drop trigger if exists giving_new_don on DON;
create trigger giving_new_don after insert on DON
	for each row
		execute procedure fill_audit('DON');



-- ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ we' re gonna handle the audit here end ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤












