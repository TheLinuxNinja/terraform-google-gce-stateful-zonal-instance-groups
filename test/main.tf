provider "google" {}

data "google_compute_image" "ubuntu_1604" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-1604-lts"
}

module "machines" {
  source = ".."

  machine_type           = "n1-standard-1"
  boot_disk_source_image = "${data.google_compute_image.ubuntu_1604.self_link}"
  boot_disk_size         = "10"

  base_name = "m"

  preemptible = true
  amount      = 3
}

output "nat_ips" {
  value = "${module.machines.nat_ips}"
}
