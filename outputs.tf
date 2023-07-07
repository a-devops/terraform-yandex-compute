output "external_ips" {
  value = {
    for k, bd in yandex_compute_instance.vps : k => bd.network_interface.0.nat_ip_address
  }
}

output "fqdns" {
  value = {
    for k, bd in yandex_compute_instance.vps : k => bd.fqdn
  }
}

output "internal_ips" {
  value = {
    for k, bd in yandex_compute_instance.vps : k => bd.network_interface.0.ip_address
  }
}

output "image_id" {
  value = data.yandex_compute_image.vps.id
}

output "cloud-init-file" {
  value = data.template_file.script.rendered
}
