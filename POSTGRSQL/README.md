# HOMEWORK_POSTGRSQL_6_4_(VITKIN_K_N)

### 1. 
- *Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.*
- *Coздадим volium*
```
konstantin@konstantin-forever ~ $ sudo docker pull postgres:13
Digest: sha256:a598b8679658e155020725d41601813cc8813429494514501e7f65f031774964
Status: Downloaded newer image for postgres:13
konstantin@konstantin-forever ~ $ sudo docker volume create volium_pqsql
volium_pqsql
$ sudo docker run --rm --name pgadmin -e POSTGRES_PASSWORD=admin -ti -p 5432:5432 -v volium_pqsql:/var/lib/postgresql/data postgres:13
```
- *Подключаемся к БД PostgreSQL используя psql*
```
konstantin@konstantin-forever ~ $ sudo docker exec -it pgadmin bash
[sudo] пароль для konstantin: 
root@9fe4b892100f:/# psql --username=postgres --dbname=postgres
Password: 
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

```
- *Вывод списка баз данных*
```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
   
-----------+----------+----------+------------+------------+--------------------
---
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres        
  +
           |          |          |            |            | postgres=CTc/postgr
es
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres        
  +
           |          |          |            |            | postgres=CTc/postgr
es
(3 rows)
```
- *Подключения к БД*
```
postgres=# \l template1
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
   
-----------+----------+----------+------------+------------+--------------------
---
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres        
  +
           |          |          |            |            | postgres=CTc/postgr
es
(1 row)
```
- *Вывод списка таблиц* 
```
postgres=# \dtS
..
 pg_catalog | pg_namespace            | table | postgres
 pg_catalog | pg_opclass              | table | postgres
 ..
```
- *Выхода из psql*
```
postgres-# \q
root@9fe4b892100f:/# 
```

___
### 2 
- *Используя psql создайте БД test_database*
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```
- *Восставливаем бэкап БД в test_database.*
```
konstantin@konstantin-forever ~ $ sudo docker cp /home/konstantin/DEVOPS_COURSE/TASK_6_4/test_dump.sql 9fe4b892100f:/tmp
root@9fe4b892100f:/var/lib/postgresql/data# psql -U postgres -f /tmp/test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

```
- *Подклюаемся к восстановленной БД и проведим операцию ANALYZE для сбора статистики по таблице.*
```
postgres-# \c test_database
Password: 
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE VERBOSE;
INFO:  analyzing "pg_catalog.pg_type"
INFO:  "pg_type": scanned 10 of 10 pages, containing 411 live rows and 0 dead rows; 411 rows in sample, 411 estimated total rows
INFO:  analyzing "pg_catalog.pg_foreign_table"
...
```
- *Используя таблицу pg_stats, найдём столбец таблицы orders с наибольшим средним значением размера элементов в байтах.*
```
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width 
-----------
(0 rows)

```
___


### 3 Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499). 
- *Предложите SQL-транзакцию для проведения данной операции. Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?*
```
test_database=# BEGIN;
BEGIN
test_database=*# CREATE TABLE first_orders (LIKE orders);
CREATE TABLE
test_database=*# INSERT INTO first_orders SELECT * FROM orders WHERE price >499;
INSERT 0 3
test_database=*# DELETE FROM orders WHERE price >499;
DELETE 3
test_database=*# CREATE TABLE second_orders (LIKE orders);
CREATE TABLE
test_database=*# INSERT INTO second_orders SELECT * FROM orders WHERE price <=499;
INSERT 0 5
test_database=*# DELETE FROM orders WHERE price <=499;
DELETE 5
test_database=*# COMMIT;
COMMIT
test_database=# 
```
- *Да - можно было исключить ручное разбиение, функцией PARTITION FUNCTION*
### 4.
- *Используя утилиту pg_dump создаём бекап БД test_database. Как доработать бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?*
```
postgres=# pg_dump -d test_database > /tmp/test_db_dump.sql
```
- *Ограничения уникальности. Первичные ключи.*
```
CREATE index IN orders (index integer, UNIQUE);
CREATE index IN orders (index integer, PRIMARY KEY);
```
___
