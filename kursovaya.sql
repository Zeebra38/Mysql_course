use Kursovaya;

/*Данная база данных создана для хранения расписания занятий студентов. Тут присутвует расписание звонков, список студентов, дата рождения их шифр ("группа").
Также для каждого дня недели (понедельник - суббота) создана своя таблица, предметы в которой могут быть на четной/нечетной неделе, а чтобы узнать текущую неделю 
была создана таблица со специальными триггерами и функциями, для вычисления текущей недели относительно начала семестра. 
Расписания по дням можно найти по своей группе.
Также созднана таблица с предметами и преподавателем, который обучает данному предмету.*/

-- создаем таблицу с расписанием звонков
drop table if exists timetable;
create table timetable(
id int unique not null AUTO_INCREMENT,
time_start time unique not null,
time_end time unique not null,
primary key (id)
);


-- заполняем ее
insert	into timetable(time_start, time_end)
values ("9:00","10:30"),
("10:40","12:10"),
("12:40","14:10"),
("14:20","15:50"),
("16:20","17:50"),
("18:00","19:30"),
("20:00","21:30");

-- select * from  timetable t ;

-- создаем таблицу для студентов и индекс для студента, группа является 
-- специльным уникальным идентификатором студента, по которой он может узнать свое расписание. У каждой "группы" оно может быть индивидуально
drop table if exists students;
create table students(
`group` varchar(20),
fio varchar(100),
birth date,
primary key(`group`)
);
create UNIQUE  index student
on students (`group`, fio);

-- создаем таблицу для недели
drop table if exists weeks;
create table weeks(
cur_d datetime default now(),
weeknum int default 1,
parity int default 1
);

-- создаем процедуру для подсчета текущей недели 
DROP function IF EXISTS countweek;
delimiter //
create  function countweek()
returns int
DETERMINISTIC
begin
return datediff(curdate(), "2020:09:01") div 7 + 1;
end; //
delimiter ;

-- создаем триггер для подсчета номера недели
DROP TRIGGER IF EXISTS updateweek;
delimiter //
CREATE TRIGGER updateweek before update ON weeks
FOR EACH ROW
begin
set new.weeknum = countweek();
set new.parity = mod(countweek(), 2);
-- insert into weeks values(now(), countweek(), mod(countweek(), 2));
END //
delimiter ;

DROP TRIGGER IF EXISTS insertweek;
delimiter //
CREATE TRIGGER insertweek before insert ON weeks
FOR EACH ROW
BEGIN
set new.weeknum = countweek();
set new.parity = mod(countweek(), 2);
END //
delimiter ; 

-- создаем запись в таблицы для недели, в дальнейшем будем ее обновлять 
insert into weeks values();

-- создаем таблицу с предметами 
drop table if exists objects;
create table objects(
subj varchar(20),
prepod varchar(30),
primary key(subj)
);

-- создаем таблицы для дней недели

drop table if exists monday;
create table monday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

drop table if exists tuesday;
create table tuesday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

drop table if exists wednesday;
create table wednesday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

drop table if exists thursday;
create table thursday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

drop table if exists friday;
create table friday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

drop table if exists saturday;
create table saturday(
`group` varchar(20),
`week` int,
`number` int,
subj varchar(20),
FOREIGN KEY (`group`) REFERENCES students(`group`),
FOREIGN KEY (`number`) REFERENCES timetable(id),
FOREIGN KEY (subj) REFERENCES objects(subj)
);

-- заполняем БД данными. Для условности у нас в день лишь одно занятие
INSERT INTO `students` VALUES ('ae71','Eva Barrows','1998-10-16'),('ag33','Norma Lubowitz','2020-07-25'),('ah17','Rowan Beahan','1979-10-29'),('ay19','Eulah Strosin','2016-11-06'),('bg31','Micheal Kuphal','1997-10-05'),('bg93','Ike Thiel DDS','1980-07-22'),('bj11','Mr. Francis Skiles','1988-09-25'),('bq78','Mr. Delaney Labadie MD','1973-11-03'),('bw94','Murl Witting','1970-06-15'),('bz62','Antonietta Kerluke','1990-05-07'),('cd23','Juliet Erdman','2016-02-02'),('de57','Cali King','1986-01-25'),('dj27','Kraig Kreiger','1991-06-27'),('dr05','Vivien Hand','1999-12-23'),('dy87','Dr. Jamar Okuneva','1990-12-21'),('dz56','Jovanny Hamill','1987-08-28'),('ed72','Dr. Ima Lemke PhD','2017-01-15'),('ee82','Petra Runolfsson','1996-01-03'),('ef22','Prof. Virgil Gutkowski','1992-09-30'),('ek98','Domenic Roob','2003-03-19'),('ep26','Mr. Arthur Hettinger','1972-08-27'),('ew23','Prof. Savanna Rohan MD','1990-02-06'),('fc35','Hannah Runolfsson PhD','2013-04-02'),('fl74','Joey Reynolds','2014-01-14'),('fm55','Yvonne Kuvalis','1973-03-15'),('ge43','Gloria Feest','2008-02-19'),('gg53','Yasmine Morar','2003-08-25'),('go62','Prof. Christy Cartwright DVM','1979-01-25'),('gw49','Emile Shields','2006-03-24'),('ha91','Ines Cronin','1982-01-16'),('hf94','Angela Rippin','2011-03-17'),('hh38','Eliane West','1994-11-30'),('hi12','Ian Wuckert','1993-07-31'),('hi29','Wilton Witting PhD','1988-07-13'),('hi89','Otha Langworth','1988-03-25'),('hx86','Antonette Miller','1995-07-19'),('hx94','Frank Gottlieb','1989-06-17'),('ja13','Prof. Sienna Moen IV','1981-06-02'),('jk33','Mrs. Thelma Hoeger V','2005-01-19'),('jn45','Kiley Feil DDS','1980-04-09'),('kf47','Ressie Johnson II','2017-12-29'),('ki42','Joel Dooley','1997-07-07'),('kl53','Cristal Sipes','1971-11-18'),('ku94','Santa Cruickshank','2013-04-03'),('ld64','Alene Reichel','1984-08-19'),('lg71','Alexandre Lakin Jr.','1978-02-26'),('lm02','Carlee Runolfsdottir','1974-03-17'),('lm21','Dr. Vernie Harris','2020-06-07'),('lw85','Mr. Ryan O\'Connell Jr.','2018-07-30'),('mg63','Donny Baumbach','2018-02-05'),('mv47','Kylie Prosacco II','2003-12-27'),('na21','Prof. Elza Rau PhD','2010-10-10'),('nb65','Mr. Jabari Herman III','1999-10-23'),('nb91','Tressie Herzog','2020-12-21'),('nd55','Pansy Brekke','1990-07-26'),('ng51','Mrs. Kaela Sauer','1982-10-25'),('og58','Retha D\'Amore','1973-01-19'),('ou59','Harley Witting','1980-08-28'),('ox78','Mr. Frankie Roberts','1997-08-05'),('pb85','Chester Kihn','1973-08-10'),('pu05','Hillary Hudson','2020-06-07'),('py81','Dr. Edmond Ratke MD','1989-09-21'),('qf28','Helena Hessel','1999-07-04'),('qg66','Prof. Abigail Ryan DDS','1996-06-14'),('qm85','Mrs. Amelia Reynolds DVM','2017-01-09'),('qo56','Prof. Nora Bosco','1971-04-17'),('qq70','Vivien Baumbach','1971-01-13'),('rb58','Reilly Mitchell V','2004-08-07'),('rd58','Prof. Eddie Langosh','1999-09-07'),('rl22','Paul Jast','2001-09-08'),('rq52','Hazel O\'Hara','1982-12-24'),('sq24','Violet Barrows','2001-05-07'),('su18','Beau Sauer DDS','1977-07-07'),('tc10','Modesta Casper','1979-12-20'),('tj53','Vicky Klein','2012-05-05'),('tk06','Dr. Tyra Keebler','1972-12-01'),('to70','Mae Koepp','1996-07-17'),('tx96','Lora Huels','2004-11-10'),('uc78','Dr. Walker Predovic','2020-04-21'),('ue13','Johann Bruen','2011-12-19'),('uj03','Prof. Isaac Spencer','2016-08-03'),('uj99','Mariam Stehr','1973-04-09'),('ur23','Bradford Schmidt Sr.','1977-05-13'),('uw97','Gabe Homenick','1995-11-01'),('vo10','Elinore Wiegand','1970-04-28'),('vw52','Abigail Orn','1984-01-29'),('vy60','Cecile Bednar','1975-08-19'),('wv15','Sidney Ferry DVM','1972-09-17'),('xc85','Mr. Greyson Buckridge III','1990-08-25'),('xd48','Ms. Violette Durgan Sr.','2008-08-21'),('xe61','Barbara Brekke','1987-09-10'),('xf22','Aida Orn','2004-04-15'),('xt51','Harold Bosco','1997-07-28'),('xv45','Ashlee Lebsack','2004-07-14'),('xv47','Prof. Carlo Gutmann III','1991-01-06'),('xw92','Kadin Cummings','2015-01-23'),('yd33','Prof. Francesca Schiller IV','2003-11-11'),('yp54','Zella Schoen','1997-12-18'),('yr82','Veronica Howell III','1994-04-24'),('ys58','Mary Dibbert','2003-03-06');
INSERT INTO `objects` VALUES (' Chemistry','McKenzie'),(' English','D\'Amore'),(' History','Mitchell'),(' Medic','Towne'),(' PE','Beier'),(' Physics','Farrell'),(' Security','Adams'),('Math','Ruecker');
INSERT INTO `friday` VALUES ('ae71',2,1,' Chemistry'),('ag33',1,4,' English'),('ah17',2,4,' History'),('ay19',1,7,' Medic'),('bg31',1,3,' PE'),('bg93',2,4,' Physics'),('bj11',2,1,' Security'),('bq78',2,5,'Math'),('bw94',1,6,' Chemistry'),('bz62',1,4,' English'),('cd23',2,1,' History'),('de57',1,6,' Medic'),('dj27',1,1,' PE'),('dr05',2,5,' Physics'),('dy87',2,4,' Security'),('dz56',1,2,'Math'),('ed72',2,2,' Chemistry'),('ee82',2,6,' English'),('ef22',1,5,' History'),('ek98',1,3,' Medic');
INSERT INTO `monday` VALUES ('ae71',1,1,' Chemistry'),('ag33',2,6,' English'),('ah17',1,2,' History'),('ay19',1,1,' Medic'),('bg31',1,4,' PE'),('bg93',1,4,' Physics'),('bj11',1,6,' Security'),('bq78',2,1,'Math'),('bw94',1,5,' Chemistry'),('bz62',2,1,' English'),('cd23',1,7,' History'),('de57',2,6,' Medic'),('dj27',1,7,' PE'),('dr05',1,7,' Physics'),('dy87',2,3,' Security'),('dz56',1,6,'Math'),('ed72',1,6,' Chemistry'),('ee82',1,5,' English'),('ef22',1,3,' History'),('ek98',2,2,' Medic');
INSERT INTO `thursday` VALUES ('ae71',1,3,' Chemistry'),('ag33',2,1,' English'),('ah17',1,4,' History'),('ay19',1,4,' Medic'),('bg31',1,6,' PE'),('bg93',1,1,' Physics'),('bj11',2,7,' Security'),('bq78',2,7,'Math'),('bw94',1,4,' Chemistry'),('bz62',1,3,' English'),('cd23',1,3,' History'),('de57',2,3,' Medic'),('dj27',1,6,' PE'),('dr05',1,3,' Physics'),('dy87',1,3,' Security'),('dz56',1,1,'Math'),('ed72',2,2,' Chemistry'),('ee82',1,3,' English'),('ef22',2,5,' History'),('ek98',2,4,' Medic');
INSERT INTO `tuesday` VALUES ('ae71',1,7,' Chemistry'),('ag33',2,2,' English'),('ah17',2,1,' History'),('ay19',2,5,' Medic'),('bg31',1,2,' PE'),('bg93',2,3,' Physics'),('bj11',1,6,' Security'),('bq78',1,2,'Math'),('bw94',1,1,' Chemistry'),('bz62',1,7,' English'),('cd23',2,2,' History'),('de57',2,4,' Medic'),('dj27',1,6,' PE'),('dr05',2,5,' Physics'),('dy87',2,7,' Security'),('dz56',1,5,'Math'),('ed72',1,2,' Chemistry'),('ee82',2,3,' English'),('ef22',1,2,' History'),('ek98',1,2,' Medic'), ('ae71',1,2,' Medic'), ('ae71',1,3,' Physics');
INSERT INTO `wednesday` VALUES ('ae71',2,7,' Chemistry'),('ag33',1,1,' English'),('ah17',1,5,' History'),('ay19',1,4,' Medic'),('bg31',2,6,' PE'),('bg93',1,4,' Physics'),('bj11',1,4,' Security'),('bq78',1,5,'Math'),('bw94',1,6,' Chemistry'),('bz62',1,3,' English'),('cd23',1,7,' History'),('de57',1,3,' Medic'),('dj27',1,6,' PE'),('dr05',1,1,' Physics'),('dy87',2,6,' Security'),('dz56',2,5,'Math'),('ed72',1,7,' Chemistry'),('ee82',1,1,' English'),('ef22',1,4,' History'),('ek98',2,6,' Medic');


-- выведем расписание для группы студента Eva Barrows на вторник на нечетную неделю
select `group`, subj, number from tuesday where `group` = (select `group` from students s where fio = "Eva Barrows") order by number;

-- выведем все группы студентов
select `group` from students s group by `group`;

-- создадим представления для вывода всех студентов с их группой 
create or replace view studs as select `group` as code, fio from students order by fio;
select * from studs;

-- создадим представления для вывода группы, ее расписания на пятницу, временем проведения и преподавателем
create or replace view fridayshedule as select students.`group`, friday.`number` as number, timetable.time_start as start, timetable.time_end as end, friday.subj as subj, objects.prepod as prepod from students
left join friday on students .`group` = friday.`group` 
left join objects on friday.subj = objects.subj
left join timetable on number = timetable.id;
select * from fridayshedule;