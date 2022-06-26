# HOMEWORK_TERRAFORM_INTRO_7_1_(VITKIN_K_N)

### 1. Выбор инструментов. 
- *Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо будет уже сегодня. На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам. Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.
Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры. На данный момент в вашей компании уже используются следующие инструменты:*
- *остатки Сloud Formation + некоторые образы сделаны при помощи Packer + год назад начали активно использовать Terraform + разработчики привыкли использовать Docker + уже есть большая база Kubernetes конфигураций + для автоматизации процессов используется Teamcity + также есть совсем немного Ansible скриптов + и ряд bash скриптов для упрощения рутинных задач*
######  Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:
###### *1.Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?*
```
Инфраструктура должна быть изменяемой, так как проект только развивается и требует большого количества изменений
```
###### *2.Будет ли центральный сервер для управления инфраструктурой?*
```
Центрального сервера не будет, проект развивается и будет маштабироватся в будущем,  клиентов станет больше со временем - с одним сервером будет ограниченный вариант
```
###### *3. Будут ли агенты на серверах?*
```
Так как мы будем использовать Ansible, у которого нет агентов в структуре, то их не будет.
```
###### *4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?*
```
Да - проект требует моножества доработок и тестов - требуется использовать terraform, docker и ansible 
```
###### *Какие инструменты из уже используемых использовать для нового проекта? Какие новые инструменты для этого проекта?*
```
Всё что использовалось Ansible,Terraform, Docker, Packer, Kubernetes, bash скрипты, Сloud Formation
Добавил бы Jenkins, GitLab CI/CD
Исключил бы Teamcity
```
___
### 2. Установка терраформ
- *Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе. В виде результата этой задачи приложите вывод команды terraform --version.*
```
konstantin@konstantin-forever ~ $ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
konstantin@konstantin-forever ~ $ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
konstantin@konstantin-forever ~ $ sudo apt-get update && sudo apt-get install terraform
Сущ:1 http://archive.ubuntu.com/ubuntu xenial InRelease                        
Сущ:2 http://archive.canonical.com/ubuntu xenial InRelease 

konstantin@konstantin-forever ~ $ terraform --version
Terraform v1.1.9
on linux_amd64
Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
...
```

### 3.Поддержка легаси кода.
- *В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. А код одного из проектов настолько устарел, что не может работать с версией 0.13. В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи штатного менеджера пакетов и устаревшую версию 0.12.*
```
konstantin@konstantin-forever ~ $ sudo mkdir -p /usr/local/tf/12
konstantin@konstantin-forever /usr/local/tf/12 $ sudo wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
--2022-06-26 11:08:47--  https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
Распознаётся releases.hashicorp.com (releases.hashicorp.com)... 151.101.86.49
Подключение к releases.hashicorp.com (releases.hashicorp.com)|151.101.86.49|:443... соединение установлено.
HTTP-запрос отправлен. Ожидание ответа... 200 OK
Длина: 16207833 (15M) [application/zip]
Сохранение в каталог: ««terraform_0.12.20_linux_amd64.zip»».
terraform_0.12.20_l 100%[===================>]  15,46M  3,48MB/s    in 5,5s    
2022-06-26 11:08:53 (2,83 MB/s) - «terraform_0.12.20_linux_amd64.zip» сохранён [16207833/16207833]
konstantin@konstantin-forever /usr/local/tf/12 $ sudo unzip terraform_0.12.20_linux_amd64.zip
Archive:  terraform_0.12.20_linux_amd64.zip
  inflating: terraform               
konstantin@konstantin-forever /usr/local/tf/12 $ rm terraform_0.12.20_linux_amd64.zip
konstantin@konstantin-forever /usr/local/tf/12 $ sudo rm terraform_0.12.20_linux_amd64.zip
konstantin@konstantin-forever /usr/local/tf/12 $ sudo ln -s /usr/local/tf/12/terraform /usr/bin/terraform12
konstantin@konstantin-forever /usr/local/tf/12 $ sudo chmod ugo+x /usr/bin/terraform12
```
- *При использовании более ранней версии вводим terraform12 вместо terraform и отрабатывет нужная нам версия terraform12*
```
konstantin@konstantin-forever /usr/local/tf/12 $ terraform12 --version
Terraform v0.12.20

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
konstantin@konstantin-forever /usr/local/tf/12 $ terraform --version
Terraform v1.1.9
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
```
___
