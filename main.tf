data "yandex_compute_image" "vps" {
  family    = var.image_family
}

resource "yandex_vpc_address" "addr" {
  # for_each  = var.instance

  for_each = { for k, v in var.instance : k => v if v.is_nat }

  folder_id = var.folder_id
  name      = "${tostring(each.value.name)}-addr"

  external_ipv4_address {
    zone_id = tostring(each.value.zone)
  }
}

resource "yandex_compute_disk" "disks" {
  for_each = var.secondary_disk
  name     = each.key
  size     = each.value["size"]
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
    ignore_changes        = [id]
    create_before_destroy = true
  }

  dynamic "secondary_disk" {
    for_each = var.secondary_disk
    content {
      auto_delete = lookup(secondary_disk.value, "auto_delete", true)
      disk_id     = yandex_compute_disk.disks[secondary_disk.key].id
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
  }

  allow_stopping_for_update = true
}
