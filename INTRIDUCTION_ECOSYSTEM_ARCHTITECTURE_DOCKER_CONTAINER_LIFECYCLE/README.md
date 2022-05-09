# INTRIDUCTION_ECOSYSTEM_ARCHTITECTURE_DOCKER_CONTAINER_LIFECYCLE_5_3_(VITKIN_K_N)

### 1. Cоздаём свой репозиторий на https://hub.docker.com; выбераем любой образ, который содержит веб-сервер Nginx; создаём свой fork образа:
- *Выбираем образ nginx, загружаем его и запускаем*
```
konstantin@konstantin-forever ~ $ sudo docker run -d -p 192.168.0.102:8080:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
1fe172e4850f: Pull complete 
35c195f487df: Pull complete 
213b9b16f495: Pull complete 
a8172d9e19b9: Pull complete 
f5eee2cb2150: Pull complete 
93e404ba8667: Pull complete 
Digest: sha256:859ab6768a6f26a79bc42b231664111317d095a4f04e4b6fe79ce37b3d199097
Status: Downloaded newer image for nginx:latest
5b856e23432865c089efc0ddc97be4d82780401b9fcdade4fb4de02b35696466

```
- *Смотрим в браузере работу контейнера*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/9.png )

konstantin@konstantin-forever ~/DEVOPS_COURSE $ nano index.html
- *Делаем html - страничку и копирем ее в наш контейнер.*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE $ nano index.html
<html>
	        <head>
	                Hey, Netology
	        </head>
	<body>
	        <h1>I’m DevOps Engineer!</h1>
	</body>
	</html>
konstantin@konstantin-forever ~/DEVOPS_COURSE $ sudo docker cp index.html 5b856e234328:/usr/share/nginx/html/
```
- *Cмотрим в браузере работу контейнера - как отображается наша страничка*
- 
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/8.png )

- *Логинимся через командную строку на hub.docker (перименуем в удобочитаемую форму на image) и пушим в заранее созданный репозитории наш модифицированный image*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE $ sudo docker login docker.io
[sudo] пароль для konstantin: 
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: vitkinkon
Password: 
WARNING! Your password will be stored unencrypted in /home/konstantin/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded

konstantin@konstantin-forever ~/DEVOPS_COURSE $ sudo docker tag nginx vitkinkon/netology:5_3_task

konstantin@konstantin-forever ~/DEVOPS_COURSE $ sudo docker push vitkinkon/netology:5_3_task
The push refers to repository [docker.io/vitkinkon/netology]
b6812e8d56d6: Mounted from library/nginx 
7046505147d7: Mounted from library/nginx 
c876aa251c80: Mounted from library/nginx 
f5ab86d69014: Mounted from library/nginx 
4b7fffa0f0a4: Mounted from library/nginx 
9c1b6dd6c1e6: Mounted from library/nginx 
5_3_task: digest: sha256:61face6bf030edce7ef6d7dd66fe452298d6f5f7ce032afdd01683ef02b2b841 size: 1570
```
##### *Ccылка на наш image:*
###### [Image in Hub.docker.com](https://hub.docker.com/layers/210207984/vitkinkon/netology/5_3_task/images/sha256-61face6bf030edce7ef6d7dd66fe452298d6f5f7ce032afdd01683ef02b2b841?context=repo&tab=layers )
___
### 2.Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?" 
- *Высоконагруженное монолитное java веб-приложение;* 
###### *Подойдут все три варианта, так как каждый вариант в своей мере справляется с рабочими нагрузками, конечно лучше упаковать приложение в контейнер(в задании нет требований к системе OS), сложно сказать для чего помещать подобного рода приложения в виртуалку - на мой взгляд она хуже справится с данной функцией(из-за доп процессов при виртуализации). Физ сервер может быть лучше всего подходит под данный вариант.*
- *Nodejs веб-приложение;*
###### *Данный сценарий лучше всего подходит для docker, также неплохо размерстить на виртуальной машине, можно и на физическом сервере если высоки требования к отказоустойчивости и безопасности*
- *Мобильное приложение c версиями для Android и iOS;*
###### *На данные сценарий больше подходит вируальные машины с разными операционными системами*
- *Шина данных на базе Apache Kafka;*
###### *Если используется Apache Kafka вероятно высоки требования в надёжности и отказоустойчивости что возможно на физическом сервере, а также система типа docker - compose c высокими параметрами быстродействия и надёжности*
- *Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;*
###### *Данный сценарий лучше всего подходит для docker*
- *Мониторинг-стек на базе Prometheus и Grafana;*
###### *Данный сценарий лучше всего подходит для docker*
- *MongoDB, как основное хранилище данных для java-приложения;*
###### *Данный сценарий лучше всего подходит для docker и физического сервера*
- *Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.*
###### *Данный сценарий подходит для всех вариантов*

___

### *3.Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера; Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера; Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data; Добавьте еще один файл в папку /data на хостовой машине; подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера..* 

```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ mkdir data

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker pull centos
[sudo] пароль для konstantin: 
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker pull debian
Using default tag: latest
latest: Pulling from library/debian
6aefca2dc61d: Pull complete 
Digest: sha256:6846593d7d8613e5dcc68c8f7d8b8e3179c7f3397b84a47c5b2ce989ef1075a0
Status: Downloaded newer image for debian:latest

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker image ls
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
debian               latest              a11311205db1        2 weeks ago         124MB
centos               latest              5d0da3dc9764        7 months ago        231MB

```
- *Запускаем контейнеры и подключаем папку data к папке контейнера /data (для этого используем простой процесс sleep*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker run -d -v /home/konstantin/DEVOPS_COURSE/TASK_5_3/data:/data debian sleep 1000
bc2a75f7b13504eaacda2d9728beba94e101bd2600fe87fccf7d837b513fa95e

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker run -d -v /home/konstantin/DEVOPS_COURSEK_5_3/data:/data centos sleep 1000
2d046ff54b832f9f08d0115bf40b0b1dbb3d548e9706597f157445b54a4e8c21

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
2d046ff54b83        centos              "sleep 1000"        41 seconds ago      Up 39 seconds                           competent_rosalind
bc2a75f7b135        debian              "sleep 1000"        52 seconds ago      Up 50 seconds                           epic_goodall
```
- *Заходим в контейнер сenos контейнер и создаем там файл  first_file*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker exec -it 2d046ff54b83 /bin/bash
[root@2d046ff54b83 /]#  cd /data
[root@2d046ff54b83 data]# echo Hey_DevOps > first_file.txt
[root@2d046ff54b83 data]# exit
exit
```
- *С хостовой машины в папке /data создаем файл Second_file, заходим в контейнер debian и смотрим что у нас в папке ./data*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ cd data
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3/data $ touch Second_file.txt
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3/data $ cd ..
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ sudo docker exec -it bc2a75f7b135 /bin/bash
root@bc2a75f7b135:/# cd /data
root@bc2a75f7b135:/data# ls
Second_file.txt  first_file.txt
root@bc2a75f7b135:/data# exit
exit
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_3 $ 
```
