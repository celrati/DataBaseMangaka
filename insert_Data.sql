-- a script to fill all the tables --

insert into USER_DONOR(name_donor,lastName_donor,pseudo,email,password) 
	values('achraf','charif','TheDonor','m.charif.achraf@gmail.com','1234'),
		('oussama','aouesser','Dota','dota@gmail.com','7789'),
		('hinata','hyuga','byaku','byaku@hyuga.nr','999'),
		('sasuke','uchiha','shar','sharingan@sas.nr','3333'),
		('Gon','freecs','hun','gon@hunter.x','12'),
		('killua','zoldyk','zolzol','killua@hunter.x','122'),
		('hisoka','morow','joker','hisoka@hunter.x','1111'),
		('luffy','D monkey','mugiwara','luffy@mugiwaras.gd','1'),
		('zoro','roronoa','PirateHunter','zoro@mugiwaras.gd','2'),
		('sanji','vinsmoke','blackLeg','sanji@mugiwaras.gd','3');



insert into USER_MANGAKA(name_mangaka,lastName_mangaka,pseudo,email,password,rating_mangaka,famous_manga_written)
	values('hayao','miyazaki','hayaom','hayao.m@gmail.com','1233',5,'spirited away'),
		('eiichiro','oda','odaoda','oda@gmail.com','2354',5,'one piece'),
		('akira','toriyama','akirato','akira@outlook.fr','4522',4,'dragonBall'),
		('masashi','kishimoto','masaKishi','masa@hotmail.fr','4564',3,'naruto'),
		('hajime','isayma','hajisa','haji@msn.fr','2334',5,'Shingeki no Kyojin'),
		('hiro','mashima','mashimashi','mashi@yahoo.fr','1444',5,'fairy tail'),
		('yusuke','murata','mumu','musu@gmail.com','4555',4,'one punch man'),
		('tite','kubo','titi','titi@gmail.com','44433',4,'bleach'),
		('yoshihiro','togashi','togo','toga@outlook.fr','11',3,'hunter x hunter'),
		('akiyuki','nosaka','nono','nosaka@msn.fr','2222',5,'Grave of the Fireflies');



insert into MANGA(name_manga,state_manga,theme_manga,step_manga,sum_needed)
	values('one piece','IN_PROGRESS','SHONEN',1,500),
		('naruto','IN_PROGRESS','SHONEN',1,250),
		('spirited away','IN_PROGRESS','SHONEN',1,350);


insert into CREATE_MANGA(id_mangaka,id_manga,creation_date)
	values(2,1,CURRENT_DATE),
	(4,2,CURRENT_DATE),
	(1,3,CURRENT_DATE);


insert into DON(id_donor,id_manga,how_much,donation_date,donor_comment)
	values(1,3,50,CURRENT_DATE,'a good one im glad to contribute to give life to this great manga !!'),
	(1,1,20,CURRENT_DATE,'the anime is just amazing !'),
	(2,3,40,CURRENT_DATE,'a wonderful anime !!');



insert into GLOBAL_PARAM(param_name, param_value)
	values('commission_value',5), -- 5% for the commission --
	('step_2',10),  -- 10% increasing --
	('step_3',25),  -- 25% increasing --
	('life_manga',5), -- a manga project cant exceed 5 months --
	('min_to_give', 10),  -- min don to give
	('max_to_give', 100);  -- max don to give


insert into DATE_DATE(date_date)
	values(CURRENT_DATE);