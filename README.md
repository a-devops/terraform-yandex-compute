# Terraform module for Yandex.Cloud Compute

Terraform module which creates [compute instance](https://cloud.yandex.ru/services/compute) on [Yandex.Cloud](https://cloud.yandex.ru/).

## Examples usage

- [Dev instance example](https://github.com/avbuben/terraform-yandex-compute/tree/master/examples/dev-instance)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| yandex | >= 0.88.0 |

## Providers

| Name | Version |
|------|---------|
| yandex | >= 0.88.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance | Instance parameters| <pre>map(object({<br>  name = string<br>  zone = string<br>  subnet_id = string<br>  is_nat = bool<br> secondary_disk = bool<br> secondary_disk_name = string<br> secondary_disk_size = string<br> }))</pre> | `{}` | yes |
| core\_fraction | Baseline performance for a core as a percent | `number` | `100` | no |
| cores | CPU cores for the instance | `number` | `2` | no |
| folder\_id | Yandex Cloud Folder ID where resources will be created | `string` | n/a | yes |
| image\_family | Yandex Cloud Compute Image family | `string` | `"debian-10"` | yes |
| memory | Memory size for the instance in GB | `number` | `2` | no |
| nat\_ip\_address | Public IP address for instance to access the internet over NAT | `string` | `""` | no |
| platform\_id | The type of virtual machine to create | `string` | `"standard-v3"` | no |
| preemptible | Specifies if the instance is preemptible | `bool` | `false` | no |
| size | Size of the boot disk in GB | `string` | `"10"` | no |
| ssh\_pubkey | SSH public key for access to the instance | `string` | `"~/.ssh/id_rsa.pub"` | no |
| ssh\_username | User for SSH access to the instance | `string` | `"debian"` | no |
| cloud-init-file | cloud-init file content | `string` | null | no |

## Outputs

| Name | Description |
|------|-------------|
| compute\_instance\_external\_ips | The external IP address of the instance |
| compute\_instance\_fqdns | The fully qualified DNS name of this instance |
| compute\_instance\_internal\_ips | The internal IP address of the instance |
| cloud-init-file | cloud-init file content |
