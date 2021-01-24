use vk;

/* Задача 1.
Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека,
 который больше всех общался с выбранным пользователем (написал ему сообщений).*/
-- пользователь 1
select 
from_user_id as id, concat(u.firstname, ' ', u.lastname) as name, count(*) as `count`
from messages m 
join users u on u.id = m.from_user_id 
where m.to_user_id = 1
order by `count` desc 
limit 1;


/* Задача 2.
Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.*/
select count(*) as `count`
from likes l 
join media m on l.media_id = m.id 
join  profiles p2 on p2.user_id = m.user_id 
where year(now()) - year(birthday) < 10;

/*Задача 3.
 Определить кто больше поставил лайков (всего): мужчины или женщины.*/
select gender, count(*) as `count`
from likes l2 
join profiles p2 on l2.user_id = p2.user_id 
group by gender
order by `count` desc 
limit 1;

