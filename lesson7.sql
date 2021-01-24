

/* Задача 1. 
Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине. */
select u.name, count(*) as `count`
from orders o
join users u on u.id = o.user_id 
group by u.name;


/* Задача 2. 
Выведите список товаров products и разделов catalogs, который соответствует товару. */
select p.name, (select c2.name from catalogs c2 where p.catalog_id = c2.id) as Category
from products p 
group by p.name;

/* Задача 3. 
(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов.
 */
select f.id, (select c.name from cities c where c.label = f.`from`) as `from`, (select c.name from cities c where c.label = f.`to`) as `to`
from flights f;


/*INSERT INTO flights
(id, `from`, `to`)
VALUES(1, 'moscow', 'omsk'), (2, 'novgorod', 'kazan'), (3, 'irkutsk', 'moscow'), 
(4, 'omsk', 'irkutsk'), (5, 'moscow', 'kazan');

INSERT INTO cities
(label, name)
VALUES('moscow', 'Москва'), ('irkutsk', 'Иркутск'), ('novgorod', 'Новгород'), ('kazan', 'Казань'), ('omsk', 'Омск');*/
