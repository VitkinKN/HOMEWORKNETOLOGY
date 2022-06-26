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
