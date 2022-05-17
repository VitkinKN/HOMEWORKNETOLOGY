# ORCESTRRSION_CLASTER_DOCKER_CONTEINERS_FOR_LESS_DOCKER_SWARM_5_5_(VITKIN_K_N)

### 1. Вопросы.
- *В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?*
###### *в replicated создается явно указанное количество реплик сервиса, в global создается по одной реплике сервиса на каждом узле своры*

- *Какой алгоритм выбора лидера используется в Docker Swarm кластере?*
###### *Используется алгоритм распределенного соглашения Raft*
- *Что такое Overlay Network?*
###### *Наложенная сеть между хостами, на которых запущены docker-демоны, трафик шифруется с помощью IPsec.*


### 2. Создаём наш первый Docker Swarm кластер в Яндекс.Облаке.

- *Cоздаём сервисный аккаунт и делаем для него key.json файл*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ yc iam key create --service-account-name konstantinvit --folder-id b1g3r78e9ad9be8bcmdr --output key.json
id: aje5f61mo2j1cggm6cgi
service_account_id: aje7p4gkg2jt146197pg
created_at: "2022-05-17T18:11:10.454323331Z"
key_algorithm: RSA_2048
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ yc iam key create --service-account-id aje7p4gkg2jt146197pg --output key.json
id: ajei4eg3qifugvl5fn65
service_account_id: aje7p4gkg2jt146197pg
created_at: "2022-05-17T18:20:24.018570646Z"
key_algorithm: RSA_2048
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ yc config profile create my-robot-profile
Profile 'my-robot-profile' created and activated
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ yc config set service-account-key key.json
```
- *Настроим наш json файл: folder id, subnet_id, key..*
- *Также запустим постройку нашего образа в облаке*

##### *Настроим терраформ*

- *Делаем конфигурацию терраформ для облака в файлах*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/05-virt-04-docker-compose/src/ansible $ 
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1gjj00oe6mlvmeoj0h6"
  folder_id = "b1g3r78e9ad9be8bcmdr"
}
```
```
# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "enp84akg6umv6ofhfk6c"
  v4_cidr_blocks = ["192.168.101.0/24"]
}
```

- *Инициируем терраформ, проверяем конфигурацию и создаём кластер*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ terraform init
...
Terraform has been successfully initialized!

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ terraform validate
Success! The configuration is valid.
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_5/terraform $ terraform plan
...
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/terraform $ terraform apply
...
 null_resource.monitoring: Creation complete after 1m12s [id=8328377331314427324]

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "51.250.91.186"
external_ip_address_node02 = "51.250.84.16"
external_ip_address_node03 = "51.250.91.129"
external_ip_address_node04 = "51.250.91.72"
external_ip_address_node05 = "51.250.80.248"
external_ip_address_node06 = "51.250.74.55"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
...
```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/14.png )
___

### *3. Создём готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.*

![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/15.png )

