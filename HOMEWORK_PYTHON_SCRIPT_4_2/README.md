# HOMEWORK_PYTHON_SCRIPT_4_2_(VITKIN_K_N)

### 1. Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  |TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | a = '1'  b = '2'   c = a + b print(c)
| Как получить для переменной `c` значение 3?  | a = 1 b = 2 c = a + b print(c)|
- Добавляем кавычки получаем текст, без кавычек число.


### 2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
1. ```result_os = os.popen(' && ' .join(bash_command)).read()```
Функция popen() модуля os откроет канал для чтения (в данном случае чтения) или записи стандартного ввода-вывода запущенной команды cmd
Метод join в Python отвечает за объединение списка строк с помощью определенного указателя.
Таким образом если при запросе "git status" , будет:
- n branch main
- Your branch is up to date with 'origin/main'.
- is_change = False
- Результат команды станет: result_os = On branch main Your branch is up to date with 'origin/main'. nothing to commit, working tree clean
2. ```for result in result_os.split('\n'):``` Разбивает строку на разрывах, таких как '\ N' и возвращает Сплит списка подстроки (то есть линии )..таким образом получаем список слов из  result_os строки
result = [On, branch, main, Your, branch, is, up, to, date, with, 'origin/main', nothing, to, commit, working, tree, clean]
3. ```if result.find('modified') != -1```find(str[, start [, end]): возвращает индекс подстроки в строке. Если подстрока не найдена, возвращается число -1
Получается что в списке строк result если строки modified найдена, то условие if выполняется и мы переходим следующей строке кода(если не найдена то программа останавливается когда переберёт все слова с списке):
4. ```prepare_result = result.replace('\tmodified:   ','' )```  передает значение модифицированного файла в переменную prepare_result
print(prepare_result)    данная строка выводит название файла который модифицирован в репозитории
5. ```break``` данная команда прерывает файл когда найден первый модифицированный файл, в то же время если файлов много то все они не будут видны - удалим данную строку.
##### Мой скрипт:
```python
import os

bash_command = "cd netology/sysadm-homeworks/devops-netology", "git status"
result_os = os.popen(' && ' .join(bash_command)).read()
for result in result_os.split('\n'):
        if result.find('modified') != -1:
                    prepare_result = result.replace('\tmodified:   ','' )
                    print(prepare_result)
```
##### Вывод скрипта при запуске при тестировании:
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/2.JPG )


### 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
##### Мой скрипт:
```python
import os

host = str(input("Введите путь к Git-репозиторию для проверки файлов на модификацию: "))
bash_command =  "cd " + host, "git status"
result_os = os.popen(' && ' .join(bash_command)).read()
for result in result_os.split('\n'):
            if result.find('modified') != -1:
                                    prepare_result = result.replace('\tmodified:   ','' )
                                    print(prepare_result)
```
##### Вывод скрипта при запуске при тестировании:
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/3.JPG )

### 4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.
##### Мой скрипт:
```python
import socket
import time
numer = 1
regal = {'drive.google.com': '', 'mail.google.com': ' ', 'google.com': ' '}
while numer == 1:
    for server in regal:
        ip_server = socket.gethostbyname(server)
        if ip_server in regal[server]:
            print(server + ' - ' + ip_server)
            del regal[server]
            regal[server] =  ip_server

        else:
            print('ERROR ' +  server + ' IP mismatch: ' + regal[server] +' ' + ip_server)
            del regal[server]
            regal[server] =  ip_server
    time.sleep(1)
```
- Из условия задачи не заданно какой цикл, так что делаем его бесконечным( но при необходимости можно сделать его конечным задав numer < 50 и поставить счётчик numer += 1)
- видим из вывода программы что первые три  сообщения показали ошибку, так как в словаре не заданны правильные ip..
#### Вывод скрипта при запуске при тестировании:
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/5.JPG )


