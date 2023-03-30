provider "yandex" {
  service_account_key_file = "key.json"
  folder_id                = "xxx"
  zone                     = "ru-central1-a"
}

terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-dev-state"
    region     = "us-east-1"
    key        = "dev/terraform.tfstate"
    access_key = "xxx"
    secret_key = "xxx"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

module "vps" {
  source = "git@github.com:avbuben/terraform-yandex-compute"

  image_family = "debian-10"

  instance = {
    test = {
      name = "test-instance",
      zone = "ru-central1-a",
      subnet_id = "xxx",
      is_nat = false
    }
  }

  cores  = 2
  core_fraction = 50
  memory = 4
  type   = "network-ssd"
  size   = "10"
}
