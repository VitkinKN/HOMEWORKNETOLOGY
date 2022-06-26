# HOMEWORK_TERRAFORM_SINTAXIS_7_2_(VITKIN_K_N)

### 1. Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно)
- *Обратите внимание на период бесплатного использования после регистрации аккаунта. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки базового терраформ конфига. Воспользуйтесь инструкцией на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.*

###### *C регистрацией в Яндекс - облаке мы познакомились в ТАSK_5_3, TASK_5_4*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/23.png )

___
### 2. Создание aws ec2 или yandex_compute_instance через терраформ.

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
}
}
  required_version =  ">= 0.13"
}

provider yandex {
  service_account_key_file = "key.json"
  cloud_id  = "b1gjj00oe6mlvmeoj0h6"
  folder_id = "b1g3r78e9ad9be8bcmdr"
  zone      = "default-ru-central1-a"
}

resource yandex_compute_image ubu-img {
  name          =  "centos-7-base"
  source_image  = "fd8fphmm1jud0338snf9"
}
```
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/22.png )
- *при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?*
###### *При помощи инструмента Packer*
[Ccылка на репозиторий с исходной конфигурацией терраформа.](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/TERRAFORM-SINTAX/main.tf )

___