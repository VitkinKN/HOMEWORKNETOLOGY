# INTRIDUCTION_ECOSYSTEM_ARCHTITECTURE_DOCKER_CONTAINER_LIFECYCLE_5_3_(VITKIN_K_N)

### 1. Создать собственный образ операционной системы с помощью Packer.
- *Устанавливаем Packer (пришлось ставить с не официального ресурса через vpn*
```
kkonstantin@konstantin-forever ~/DEVOPS_COURSE/HOMEWORKNETOLOGY $ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
konstantin@konstantin-forever ~/DEVOPS_COURSE/HOMEWORKNETOLOGY $ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
konstantin@konstantin-forever ~/DEVOPS_COURSE/HOMEWORKNETOLOGY $ sudo apt-get update && sudo apt-get install packer
konstantin@konstantin-forever ~/DEVOPS_COURSE/HOMEWORKNETOLOGY $ packer -v
1.8.0
```
- *Coздаём файл конфигурации MY_OS_PACKER.pkr.hcl для нашей новой и прописываем конфигурацию*

```
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu"
  commit = true
}

build {
  name    = "MY_VM-packer"
  sources = [
    "source.docker.ubuntu"
  ]
}
```
- *Инициируем файл конфигурации и проверяем правильность работы файла*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/PACKER_VM1 $ packer init MY_OS_PACKER.pkr.hcl
Installed plugin github.com/hashicorp/docker v1.0.3 in "/home/konstantin/.config/packer/plugins/github.com/hashicorp/docker/packer-plugin-docker_v1.0.3_x5.0_linux_amd64"
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/PACKER_VM1 $ packer validate MY_OS_PACKER.pkr.hcl
The configuration is valid.
```
- *Создаём наш образ Ubuntu-Docker*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/PACKER_VM1 $ sudo docker login docker.io 
[sudo] пароль для konstantin: 
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/konstantin/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/PACKER_VM1 $ sudo packer build  MY_OS_PACKER.pkr.hcl
learn-packer.docker.ubuntu: output will be in this color.

==> learn-packer.docker.ubuntu: Creating a temporary directory for sharing data...
==> learn-packer.docker.ubuntu: Pulling Docker image: ubuntu
    learn-packer.docker.ubuntu: Using default tag: latest
    learn-packer.docker.ubuntu: latest: Pulling from library/ubuntu
    learn-packer.docker.ubuntu: 125a6e411906: Pulling fs layer
    learn-packer.docker.ubuntu: 125a6e411906: Download complete
    learn-packer.docker.ubuntu: 125a6e411906: Pull complete
    learn-packer.docker.ubuntu: Digest: sha256:26c68657ccce2cb0a31b330cb0be2b5e108d467f641c62e13ab40cbec258c68d
    learn-packer.docker.ubuntu: Status: Downloaded newer image for ubuntu:latest
==> learn-packer.docker.ubuntu: Starting docker container...
    learn-packer.docker.ubuntu: Run command: docker run -v /home/konstantin/.config/packer/tmp4072817532:/packer-files -d -i -t --entrypoint=/bin/sh -- ubuntu
    learn-packer.docker.ubuntu: Container ID: 7ccfd7434ba7df0f005be5decc04622fcde019dd510bcde42538c34c980b3ac6
==> learn-packer.docker.ubuntu: Using docker communicator to connect: 172.17.0.2
==> learn-packer.docker.ubuntu: Committing the container
    learn-packer.docker.ubuntu: Image ID: sha256:4baea1da856d8bb4da622d629c5546da4db270d348a095a7dbe6630e2b8a2d99
==> learn-packer.docker.ubuntu: Killing the container: 7ccfd7434ba7df0f005be5decc04622fcde019dd510bcde42538c34c980b3ac6
Build 'learn-packer.docker.ubuntu' finished after 47 seconds 471 milliseconds.

==> Wait completed after 47 seconds 471 milliseconds

==> Builds finished. The artifacts of successful builds are:
--> learn-packer.docker.ubuntu: Imported Docker image: sha256:4baea1da856d8bb4da622d629c5546da4db270d348a095a7dbe6630e2b8a2d99
```

![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/10.png )

___
### *2. Создадим виртуальную машину в Яндекс.Облаке.*

##### *Получили токен установили утилиту ус и настроили доступ к нашему облаку*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/PACKER_VM1 $ curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9739  100  9739    0     0  20283      0 --:--:-- --:--:-- --:--:-- 20289
Downloading yc 0.90.0
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 83.5M  100 83.5M    0     0  9673k      0  0:00:08  0:00:08 --:--:-- 10.8M
Yandex Cloud CLI 0.90.0 linux/amd64

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'netology' with new settings 
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'default'
 [4] Switch to and re-initialize existing profile: 'netlog'
 [5] Switch to and re-initialize existing profile: 'neto'
Please enter your numeric choice: 1
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: [AQAAAAAKR*********************ik4zSfY9M] AQAAAAAKRmttAATuwRK4ViENv0tRhxik4zSfY9M
You have one cloud available: 'cloud-net-vitkinkn' (id = b1gjj00oe6mlvmeoj0h6). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1gkroi916atvgla1522)
 [2] netology (id = b1g3r78e9ad9be8bcmdr)
 [3] Create a new folder
Please enter your numeric choice: 2
Your current folder has been set to 'netology' (id = b1g3r78e9ad9be8bcmdr).
Do you want to configure a default Compute zone? [Y/n] y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.


konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ yc vpc network create --name net --labels label=netology --description 'created via yc'
id: enpqvflqel7lmp8pnue5
folder_id: b1g3r78e9ad9be8bcmdr
created_at: "2022-05-15T11:17:52Z"
name: net
description: created via yc
labels:
  label: netology

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ yc vpc subnet create --name subnet --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description 'created via yc'
id: e9b6oq6q813i4dk8av9q
folder_id: b1g3r78e9ad9be8bcmdr
created_at: "2022-05-15T11:18:31Z"
name: subnet
description: created via yc
network_id: enpqvflqel7lmp8pnue5
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24


```
##### *Настроим наш json файл: folder id, subnet_id, token.*
##### *Также запустим постройку нашего образа в облаке*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ packer validate centos-7-base.json
The configuration is valid.

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ packer build centos-7-base.json
yandex: output will be in this color.
==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd8v9fc454c44fr6lngi (name: "centos-7-v20220314", family: "centos-7")
...

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/packer $ yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8fphmm1jud0338snf9 | centos-7-base | centos | f2esd9f5o5i9p7pkkk8k | READY  |
+----------------------+---------------+--------+----------------------+--------+

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4 $ yc vpc subnet delete --name subnet && yc vpc network delete --name net
done (3s)
```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/11.png )

##### *Настроим терраформ*

- *Делаем конфигурацию терраформ для облака в файлах*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/terraform $ nano 
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  token     = "AQAAAAAKRmttAATuwRK4ViENv0tRhxik4zSfY9M"
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

```
#node01
resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"
  allow_stopping_for_update = true
  resources {
    cores  = 8
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-node01"
      type        = "network-nvme"
      size        = "50"
    }
  }
  network_interface {
    subnet_id = "e9br08ja7i5nn9niqtt1"
    nat       = true
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

```
# variable

variable "yandex_cloud_id" {
  default = "b1gjj00oe6mlvmeoj0h6"
}

variable "yandex_folder_id" {
  default = "b1g3r78e9ad9be8bcmdr"
}

variable "centos-7-base" {
  default = "fd8fphmm1jud0338snf9"
}
```
- *Инициируем терраформ, проверяем конфигурацию и создаём виртуальную машину*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/terraform $ terraform init
...
Terraform has been successfully initialized!

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/terraform $ terraform validate
Success! The configuration is valid.

konstantin@konstantin-forever ~/DEVOPS_COURSE/TASK_5_4/terraform $ terraform apply
...
  Enter a value: yes
yandex_vpc_subnet.default: Creating...
yandex_vpc_network.default: Creating...
yandex_compute_instance.node01: Creating...
yandex_vpc_subnet.default: Creation complete after 7s [id=e9b5v2a42mkgef9296o9]
yandex_vpc_network.default: Creation complete after 7s [id=enpi7i7u5gstejpno2i5]
yandex_compute_instance.node01: Still creating... [10s elapsed]
yandex_compute_instance.node01: Still creating... [20s elapsed]
yandex_compute_instance.node01: Still creating... [30s elapsed]
yandex_compute_instance.node01: Still creating... [40s elapsed]
yandex_compute_instance.node01: Creation complete after 47s [id=fhmt7mheej4pkivvuqov]
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
Outputs:
external_ip_address_node01_yandex_cloud = "51.250.89.121"
internal_ip_address_node01_yandex_cloud = "10.128.0.14"

```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/12.png )
___

### *3. Создаём готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.*
```
[nodes:children]
manager
[manager]
node01.netology.cloud ansible_host=51.250.89.121
```
- *Запускаем ansible-playbook - строим наш сервис*
```
konstantin@konstantin-forever ~/DEVOPS_COURSE/05-virt-04-docker-compose/src/ansible $ ansible-playbook -i inventory provision.yml
 ______________
< PLAY [nodes] >
 --------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

 ________________________
< TASK [Gathering Facts] >
 ------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

The authenticity of host '51.250.89.121 (51.250.89.121)' can't be established.
ECDSA key fingerprint is SHA256:b/VU+JsCi5c84bwAIPm3z1EoNAZzwZ3je25Wsx7/Tn4.
Are you sure you want to continue connecting (yes/no)? yes
...
```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/13.png )

