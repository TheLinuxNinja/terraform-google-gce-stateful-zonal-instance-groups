output "id" {
  value = "${null_resource.start.id}"
}

output "nat_ips" {
  value = "${google_compute_address.stateful.*.address}"
}

module "network_interface_picker" {
  source  = "matti/map-picker/list"
  version = "0.0.1"

  list = "${flatten(google_compute_instance_template.stateful.*.network_interface)}"
  key  = "address"
}

output "addresses" {
  value = "${module.network_interface_picker.result}"
}
