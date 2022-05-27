# HOMEWORK_SQL_6_2_(VITKIN_K_N)

### 1. Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы:
- *Поднимаем наш инстанс(предварительно создаём 2 voliums) с помощью команды:*

```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker volume create voliume_DB
voliume_DB
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker volume create voliume_backup
voliume_backup

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker run --rm --name POSTGREG_SQL_DOCKER -e POSTGRES_PASSWORD=admin -ti -p 5432:5432 -v voliume_DB:/var/lib/postgresql/data -v voliume_backup:/var/lib/postgresql postgres:12
```
- *Заходим в наш контейнер и запускаем работу с базами данных*
```
konstantin@konstantin-forever ~ $ sudo docker exec -it POSTGREG_SQL_DOCKER bash
[sudo] пароль для konstantin: 
root@a4dac204d094:/# psql --username=postgres --dbname=postgres
psql (12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.
postgres=# 
```
___
### 2.В сoзданной БД создайте: 
- *создайте пользователя test-admin-user и БД test_db. Cоздайте пользователя test-simple-user в БД test_db создайте таблицу orders и clients*
```
postgres=# CREATE DATABASE test_db;
CREATE USER test_admin_user;
CREATE TABLE orders ( id SERIAL PRIMARY KEY, наименование TEXT,  цена INT );
CREATE DATABASE
CREATE ROLE
CREATE TABLE
postgres=# CREATE TABLE clients(
postgres(# id SERIAL PRIMARY KEY, фамилия TEXT, страна_проживания TEXT,
postgres(# заказ INT);
CREATE TABLE
```
- *предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db*
```
postgres=# GRANT ALL ON ALL TABLES IN SCHEMA "public" TO "test_admin_user";
GRANT
```
- *создайте пользователя test-simple-user*
```
postgres=# CREATE USER test_simple_user;
CREATE ROLE
```
- *предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db*
```
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO test_simple_user;
GRANT
```
- *Итоговый список БД после выполнения пунктов выше, описание таблиц (describe), SQL-запрос для выдачи списка пользователей с правами над таблицами test_db, список пользователей с правами над таблицами test_db:*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/16.png )
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/18.png )
___


### 3.Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
- **
```
postgres=# INSERT INTO orders                                                           
VALUES (1, 'Шоколад', 10),
(2, 'Принтер', 3000),
(3, 'Книга',   500),
(4, 'Монитор', 7000),
(5, 'Гитара',  4000);
INSERT 0 5

postgres=# INSERT INTO clients
postgres-# VALUES (1, 'Иванов Иван Иванович', 'USA'),
postgres-# (2, 'Петров Петр Петрович', 'Canada'),
postgres-# (3, 'Иоганн Себастьян Бах', 'Japan'),
postgres-# (4, 'Ронни Джеймс Дио', 'Russia'),
postgres-# (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
```
- *вычислите количество записей для каждой таблицы*
```
postgres=# SELECT COUNT(id) FROM orders;
 count 
-------
     5
(1 row)
postgres=# SELECT COUNT(id) FROM clients;
 count 
-------
     5
(1 row)
```

___
### 4.Часть пользователей из таблицы clients решили оформить заказы из таблицы orders. Используя foreign keys свяжите записи из таблиц.
- *Используя foreign keys связываем записи из таблиц, согласно таблице в задании*
```
postgres=# UPDATE clients SET заказ=3 WHERE id=1;
UPDATE 1
postgres=# UPDATE clients SET заказ=4 WHERE id=2;
UPDATE 1
postgres=# UPDATE clients SET заказ=5 WHERE id=3;
UPDATE 1
```
- *Приведём SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также выведем данный запрос.*
```
postgres=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна_проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```
___
### 5.Получим полную информацию по выполнению запроса выдачи всех пользователей из задачи
```
postgres=# EXPLAIN (FORMAT YAML) SELECT * FROM clients WHERE заказ IS NOT NULL;
              QUERY PLAN               
---------------------------------------
 - Plan:                              +
     Node Type: "Seq Scan"            + \\ Типы узлов: Последовательное сканирование
Последовательное сканирование (фрагмента) таблицы базы данных
     Parallel Aware: false            + \\Параллельное выполнение: ложь
     Relation Name: "clients"         + \\наименование объекта где идёт сканирование
     Alias: "clients"                 + \\псевдоним объекта
     Startup Cost: 0.00               + \\затраты ресурса на старт(затратность операции)
     Total Cost: 18.10                + \\затраты ресурса на выполнение(затратность операции)
     Plan Rows: 806                   + \\количество возвращаемых строк при выполнении операции
     Plan Width: 72                   + \\средний размер одной строки в байтах.
     Filter: "(\"заказ\" IS NOT NULL)"
(1 row)
```
- *EXPLAIN -План выполнения показывает, как будут сканироваться таблицы, затрагиваемые оператором (SELECT, UPDATE, INSERT, DELETE и REPLACE.)— просто последовательно, по индексу и т. д. — а если запрос связывает несколько таблиц, какой алгоритм соединения будет выбран для объединения считанных из них строк*
___
### 6.Создание бэкапа БД и его восстановление.
- *Создаем бэкап БД test_db и помещаем его в volume, предназначенный для бэкапa*
```
postgres=# pg_dump -U postgres test_db -f /var/lib/postgresql/dump_test.sql
postgres-# \q
# ls /var/lib/postgresql
data  dump_test.sql
```
- *Останавливаем контейнер с базой. Поднимимаем новый пустой контейнер с PostgreSQL. Восстанавливаем БД test_db в новом контейнере.*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker stop POSTGREG_SQL_DOCKER
POSTGREG_SQL_DOCKER
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker run --rm --name SQL_DOCKER_2 -e POSTGRES_PASSWORD=admin -ti -p 5433:5433 -v voliume_DB:/var/lib/postgresql/data -v voliume_backup:/var/lib/postgresql postgres:12-alpine
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                              NAMES
2c11e1a3d2e0        postgres:12-alpine   "docker-entrypoint.s…"   11 seconds ago      Up 10 seconds       5432/tcp, 0.0.0.0:5433->5433/tcp   SQL_DOCKER_2
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_6_2 $ sudo docker exec -ti 2c11e1a3d2e0 /bin/sh
/ # ls /var/lib/postgresql
data           dump_test.sql
/ # psql --username=postgres --dbname=postgres
psql (12.11)
Type "help" for help.
postgres=# psql -f /var/lib/postgresql/dump_test.sql
```
- *Проверим что восстановилось*
```
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

postgres-# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
postgres=# SELECT * FROM orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)
postgres=# SELECT * FROM clients;
 id |       фамилия        | страна_проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)
```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/19.png )