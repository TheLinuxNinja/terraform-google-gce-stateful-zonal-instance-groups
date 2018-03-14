locals {
  region = "${var.region == "" ? data.google_client_config.current.region : var.region}"
}

data "google_compute_zones" "all" {
  region = "${local.region}"
}

data "google_compute_network" "current" {
  name = "${var.network}"
}

data "google_client_config" "current" {}

data "google_compute_subnetwork" "current" {
  name   = "${data.google_compute_network.current.name}"
  region = "${local.region}"
}
