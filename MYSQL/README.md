# HOMEWORK_MYSQL_6_3_(VITKIN_K_N)

### 1. 
- *Используя docker поднимаем инстанс MySQL (версию 8). Данные БД сохраним в volume.*
- *Содаём volium и копируем туда нашу базу данных*
```
konstantin@konstantin-forever ~ $ sudo docker pull mysql:8.0
8.0: Pulling from library/mysql
..
Digest: sha256:548da4c67fd8a71908f17c308b8ddb098acf5191d3d7694e56801c6a8b2072cc
Status: Downloaded newer image for mysql:8.0
konstantin@konstantin-forever ~ $ sudo docker volume create mysql_voliume
mysql_voliume
konstantin@konstantin-forever ~ $ sudo docker run --rm --name DOCKER_SQL -e MYSQL_ROOT_PASSWORD=admin -ti -p 8080:8080 -v vol_mysql:/etc/mysql/ mysql:8.0
konstantin@konstantin-forever ~ $ sudo docker cp /home/konstantin/DEVOPS_COURSE/test_dump.sql 77dc273b1d5f:/var/tmp/test_dump.sql
konstantin@konstantin-forever ~ $ sudo docker exec -it 77dc273b1d5f sh
# 
```
- *Заходим в наш контейнер и запускаем работу с базой данных*
```
konstantin@konstantin-forever ~ $ sudo docker exec -it 77dc273b1d5f sh
# mysql -uroot -p"admin" 
# mysql> 
```
- *Cоздаём базу для бэкапа*
```
mysql> CREATE DATABASE test_mysql_db;
Query OK, 1 row affected (0.17 sec)
```
- *Восстанавливаем базу из test_dump.sql файла* 
```
# mysql -uroot -p"admin" test_mysql_db < /var/tmp/test_dump.sql     
mysql: [Warning] Using a password on the command line interface can be insecure.
```
- *Находим команду для выдачи статуса БД и приведим в ответе из ее вывода версию сервера БД*
```
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		14
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.29 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			21 min 26 sec

Threads: 2  Questions: 43  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.033
--------------
```
- *Подключяемся к восстановленной БД и получяем список таблиц из этой БД.*
```
mysql> USE test_mysql_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-------------------------+
| Tables_in_test_mysql_db |
+-------------------------+
| orders                  |
+-------------------------+
1 row in set (0.00 sec)
```
- *Приведите в ответе количество записей с price > 300.*
```
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```
___
### 2 
- *Создайте пользователя test в БД c паролем test-pass, используя: плагин авторизации mysql_native_password; срок истечения пароля - 180 дней; количество попыток авторизации - 3; максимальное количество запросов в час - 100; аттрибуты пользователя: Фамилия "Pretty"; Имя "James"*
```
mysql> create user 'test'@'localhost' 
    ->     identified with mysql_native_password by 'test-pass' 
    ->     with max_queries_per_hour 100
    ->     password expire interval 180 day 
    ->     failed_login_attempts 3 
    ->     attribute '{"fname": "James","lname": "Pretty"}';\
Query OK, 0 rows affected (0.18 sec)
```
- *Предоставьте привелегии пользователю test на операции SELECT базы test_db*
```
mysql> GRANT SELECT ON test_mysql_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.13 sec)
```
- *Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test*
```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTEs where user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```
- *предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db*
```
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO test_simple_user;
GRANT
```
___


### 3
- *Установите профилирование SET profiling = 1*
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```
- *Изучите вывод профилирования команд SHOW PROFILES;*
```
mysql> show profiles;
+----------+------------+------------------------------+
| Query_ID | Duration   | Query                        |
+----------+------------+------------------------------+
|        1 | 0.00046200 | select count(*) from comment |
|        2 | 0.00048600 | select count(*) from message |
+----------+------------+------------------------------+
2 rows in set, 1 warning (0.00 sec)
```
- *Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.*
```
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_mysql_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
- *Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе: на MyISAM; на InnoDB*
```
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.91 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (1.80 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                         |
+----------+------------+-----------------------------------------------------------------------------------------------+
|        1 | 0.00046200 | select count(*) from comment                                                                  |
|        2 | 0.00048600 | select count(*) from message                                                                  |
|        3 | 0.00171925 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_mysql_db' |
|        4 | 0.00159925 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_mysql_db' |
|        5 | 0.00009100 | mysql> ALTER TABLE orders ENGINE=MyISAM                                                       |
|        6 | 0.90545850 | ALTER TABLE orders ENGINE=MyISAM                                                              |
|        7 | 1.79472825 | ALTER TABLE orders ENGINE=InnoDB                                                              |
+----------+------------+-----------------------------------------------------------------------------------------------+
7 rows in set, 1 warning (0.00 sec)
```
### 4.
- *Изучите файл my.cnf в директории /etc/mysql. Измените его согласно ТЗ (движок InnoDB): Скорость IO важнее сохранности данных; Нужна компрессия таблиц для экономии места на диске; Размер буффера с незакомиченными транзакциями 1 Мб; Буффер кеширования 30% от ОЗУ; Размер файла логов операций 100 Мб*
- *Сжатие страниц InnoDB также поддерживается, только если таблица InnoDB находится в табличном пространстве файлов. Сжатие страницы InnoDB поддерживается только в том случае, если таблица InnoDB использует формат файла Barracuda .*
```
mysql> \q
Bye
# cat /etc/mysql/my.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_log_file_size = 100M
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 4800M
innodb_file_per_table ON
innodb_file_format = Barracuda
```
___
