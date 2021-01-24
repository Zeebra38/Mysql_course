-- Операторы, фильтрация, сортировка и ограничение
-- задание 1
/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */

update users 
set created_at = now(), updated_at = now();


-- задание 2
/*Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
 и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, 
 сохранив введеные ранее значения */

-- ALTER TABLE users 
--     CHANGE COLUMN `created_at` `created_at` VARCHAR(256) NULL,
--     CHANGE COLUMN `updated_at` `updated_at` VARCHAR(256) NULL;
-- 
-- describe users;
-- SELECT created_at from users;

ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHANGE COLUMN `updated_at` `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

describe users;
SELECT created_at from users;

-- задание 3
/*В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
Однако, нулевые запасы должны выводиться в конце, после всех записей.*/
DROP TABLE IF EXISTS storehouses_products;
create table storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT unsigned,
    product_id INT unsigned,
    `value` INT unsigned COMMENT 'Запас товарный позиции на складке',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
    storehouses_products (storehouse_id, product_id, value)
VALUES
    (1, 1, 15),
    (1, 3, 0),
    (1, 5, 10),
    (1, 7, 5),
    (1, 8, 0);

SELECT 
    value
FROM
    storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;
    
   
 -- Агрегация данных
-- задание 1
   -- Подсчитайте средний возраст пользователей в таблице users
   SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())), 0) AS AVG_Age FROM users;
   
 -- задание 2
--   Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
--   Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday), DAY(birthday))), '%W') AS weekday,
	COUNT(*) AS total
FROM
	profiles
GROUP BY
	weekday
ORDER BY
	total DESC;
  
   -- задание 3
  -- (по желанию) Подсчитайте произведение чисел в столбце таблицы
DROP TABLE IF EXISTS integers;
CREATE TABLE integers(
    value SERIAL PRIMARY KEY
);

INSERT INTO integers VALUES
    (NULL),
    (NULL),
    (NULL),
    (NULL),
    (NULL);
   
SELECT ROUND(exp(SUM(ln(value))), 0) AS factorial FROM integers;