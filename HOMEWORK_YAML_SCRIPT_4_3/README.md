# HOMEWORK_PYTHON_YAML_4_3_(VITKIN_K_N)

### 1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43 
            }
        ]
    }
```
### Нахожу найти и исправить все ошибки, которые допускает наш сервис
```json
    { //"info" : "Sample JSON output from our service\t", //зачемто инфа вложенна в файл-закоментируем её (хотя можно и оставить, но без \t)
        "elements" :[
            {
              "name": "first", // переносим на строку вниз и убираем пробел после "name"
              "type": "server", // делаем отступ от линии фигур скобок и убираем пробел после "type"
              "ip" : 7175 // делаем отступ от линии фигур скобок и убираем пробел после "ip"
            },  // добавили запятушку.
            {
              "name": "second",   // переносим на строку вниз от фигур скобок и убираем пробел после "name"
              "type": "proxy",   // делаем отступ от линии фигур скобок и убираем пробел после "type"
              "ip": "71.78.22.43"  // добавил кавычки перед элементом "ip"  и адресс, так как не число
            }
        ]
    }
```

### 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.```python


##### Мой скрипт:
```python
import socket # импорт библиотеки для определения ip по запросу
import time # импорт библиотеки для возможности создания задержки в работе файла
import os  # импорт библиотеки для возможности для проверки наличия и создания файла в директории
import json # импорт библиотеки для возможности работы с json файлами
import yaml # импорт библиотеки для возможности работы с yaml файлами
numer = 1 # cоздание счётчика при создании конечного или бесконечного цикла
regal = {'github.com': '', 'mail.google.com': ' ', 'google.com': ' '} словарь с нашими сервисами
if not os.path.isfile('pars.json'): 
    serv_json = open("pars.json", "w+")
if not os.path.isfile('pars.yaml'):
    serv_yaml = open("pars.yaml", "w+")   # если файлов нет то создаём их
while numer == 1:  # открываем бесконечный цикл
    for server in regal: # открываем цикл для каждого сервиса в списке
        ip_server = socket.gethostbyname(server) # находим ip сервиса
        if ip_server in regal[server]: # открываем вложенный цикл для проверки ip в словаре
            print(server + ' - ' + ip_server) # если есть то просто выводим на экран
            del regal[server] # если есть удаляем предидущую запись в словаре
            regal[server] =  ip_server # добавляем новую запись в словаре
        else:
            print('ERROR ' +  server + ' IP mismatch: ' + regal[server] +' ' + ip_server)
            del regal[server] # если нет удаляем предидущую запись в словаре
            regal[server] =  ip_server # добавляем новую запись в словаре
            with open('pars.json', 'w') as outfile: # открываем файл на ввод в него
                for server in regal: # для каждого в словаре 
                    json.dump({server : regal[server]}, outfile) # делаем запись в json файл
            with open('pars.yaml', 'w') as outfile1: # открываем файл на ввод в него
                yaml.dump(regal, outfile1, default_flow_style=False) # делаем запись в yaml файл
    time.sleep(1) # задержка цикла
```
##### Вывод скрипта при запуске при тестировании:

![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/6.JPG )

#### json-файлы, которые записал мой скрипт:
```json
{"github.com": "140.82.121.3"}{"mail.google.com": "64.233.163.18"}{"google.com": "173.194.222.139"}
```
#### yml-файлы, которые записал мой скрипт:
```yaml
github.com: 140.82.121.3
google.com: 173.194.222.139
mail.google.com: 64.233.163.18
```


