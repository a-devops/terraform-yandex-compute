locals {
  cloud-init-file = var.cloud-init-file != "" ? var.cloud-init-file : null
}

data "yandex_compute_image" "vps" {
  family    = var.image_family
}

data "template_file" "script" {
  template = "${local.cloud-init-file}"
  vars = {
    ssh_pubkey   = "${file("${var.ssh_pubkey}")}"
    ssh_username = "${var.ssh_username}"
  }
}

resource "yandex_vpc_address" "addr" {
  for_each = { for k, v in var.instance : k => v if v.is_nat }

  folder_id = var.folder_id
  name      = "${tostring(each.value.name)}-addr"

  external_ipv4_address {
    zone_id = tostring(each.value.zone)
  }
}

resource "yandex_compute_disk" "disks" {
  for_each = { for k, v in var.instance : k => v if v.secondary_disk }
  folder_id = var.folder_id
  name     = each.value.secondary_disk_name
  type     = each.value.secondary_disk_type
  zone     = tostring(each.value.zone)
  size     = each.value.secondary_disk_size
}

resource "yandex_compute_instance" "vps" {
  for_each    = var.instance
  folder_id   = var.folder_id

  name        = tostring(each.value.name)
  hostname    = tostring(each.value.name)
  platform_id = var.platform_id
  zone        = tostring(each.value.zone)

  labels      = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vps.id
      type     = var.type
      size     = var.size
    }
  }

 lifecycle {
    ignore_changes        = [boot_disk[0].initialize_params[0].image_id]
    create_before_destroy = true
  }

  dynamic "secondary_disk" {
    for_each = contains(keys(each.value), "secondary_disk_name") ? [1] : []
    content {
      disk_id     = yandex_compute_disk.disks[each.key].id
    }
  }

  network_interface {
    subnet_id      = tostring(each.value.subnet_id)
    nat            = each.value.is_nat ? true : false
    nat_ip_address = each.value.is_nat == true ? yandex_vpc_address.addr[each.key].external_ipv4_address[0].address : null
    ip_address     = var.ip_address
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file("${var.ssh_pubkey}")}"
    serial-port-enable = var.serial-port-enable != null ? var.serial-port-enable : null
    user-data = data.template_file.script.rendered
  }

  allow_stopping_for_update = true
}
