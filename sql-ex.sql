https://sql-ex.ru/learn_exercises.php

Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)
Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price. Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.

1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT model, speed, hd
FROM PC
WHERE price < 500

2. Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'

5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT model, speed, hd
FROM PC
WHERE price < 600 
AND (cd = '12x' OR cd = '24x')

6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
SELECT DISTINCT Product.maker, Laptop.speed
FROM Product 
JOIN Laptop 
ON Laptop.hd >= 10
WHERE Product.model = Laptop.model

7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT model, price 
FROM (SELECT model, price FROM PC
      UNION
      SELECT model, price FROM Laptop
      UNION
      SELECT model, price FROM Printer
      ) AS types
WHERE types.model IN (SELECT model FROM Product WHERE maker = 'B')

8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT DISTINCT maker
FROM Product
WHERE type = 'PC'
AND maker NOT IN (SELECT maker FROM Product WHERE type = 'Laptop')

9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT maker FROM Product
JOIN PC
ON Product.model = PC.model
AND PC.speed >= 450

10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
SELECT model, price
FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)

11. Найдите среднюю скорость ПК.
SELECT AVG(speed)
FROM PC

12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT AVG(speed) 
FROM Laptop
WHERE price > 1000

13. Найдите среднюю скорость ПК, выпущенных производителем A.
SELECT AVG(speed) 
FROM PC
JOIN Product 
ON Product.maker = 'A' AND PC.model = Product.model

15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) > 1

16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
SELECT DISTINCT PC.model, p.model, PC.speed, PC.ram 
FROM PC as p
JOIN PC
ON PC.model > p.model 
WHERE PC.speed = p.speed 
AND PC.ram = p.ram

17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
SELECT DISTINCT Product.Type, Laptop.model, Laptop.speed 
FROM Laptop
JOIN Product
ON Laptop.model = Product.model
WHERE Laptop.speed < ALL (SELECT speed FROM PC)

18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT Product.Maker, Printer.price 
FROM Product
JOIN Printer
ON Product.model = Printer.model
WHERE Printer.color = 'y'
AND Printer.price = (SELECT MIN(price) FROM Printer WHERE color = 'y')

19. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. Вывести: maker, средний размер экрана.
SELECT Product.maker, AVG(Laptop.screen)
FROM Product
JOIN Laptop
ON Product.model = Laptop.model
GROUP BY Product.maker

20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT maker, COUNT(type) 
FROM Product
WHERE Product.type = 'PC'
GROUP BY maker
HAVING COUNT (type) >= 3

21. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. Вывести: maker, максимальная цена.
SELECT DISTINCT Product.maker, MAX(PC.price) 
FROM Product
JOIN PC
ON Product.model = PC.model
WHERE Product.type = 'PC' 
GROUP BY Product.maker

22. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.
SELECT speed, AVG(price) 
FROM PC
WHERE speed > 600
GROUP BY speed

23. Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker
SELECT DISTINCT maker 
FROM Product
JOIN PC 
ON Product.model = PC.model
WHERE PC.speed >= 750
AND maker IN
(
SELECT maker 
FROM Product 
JOIN Laptop 
ON Product.model=Laptop.model
WHERE speed>=750
)

24. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
SELECT model FROM 
(
SELECT model, price FROM PC
UNION
SELECT model, price FROM Laptop
UNION
SELECT model, price FROM Printer
) mod
WHERE price = (SELECT MAX(Price) FROM 
(
SELECT price FROM PC
UNION
SELECT price FROM Laptop
UNION
SELECT price FROM Printer
) pri
      )

25. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
SELECT DISTINCT maker 
FROM Product
WHERE maker IN (SELECT maker FROM Product WHERE type = 'Printer')
AND
model IN (SELECT model FROM PC WHERE ram = (SELECT MIN(ram) FROM pc) 
AND 
speed = (SELECT MAX(speed) FROM PC WHERE ram = (SELECT MIN(ram) FROM pc) 
))

26. Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
SELECT AVG(price) 
FROM 
(
SELECT code, model, price 
FROM PC
WHERE model 
IN (SELECT model FROM PRODUCT WHERE maker = 'A')
      
UNION
      
SELECT code, model, price 
FROM Laptop
WHERE model 
IN (SELECT model FROM PRODUCT WHERE maker = 'A')
)avg

27. Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
SELECT maker, AVG(hd) 
FROM Product
JOIN PC 
ON PC.model = Product.model
WHERE maker 
IN (SELECT maker FROM Product WHERE type = 'Printer')
GROUP BY maker

28. Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
SELECT COUNT(maker) FROM 
(
SELECT maker 
FROM Product
GROUP BY maker
HAVING COUNT(model) = 1
)m

