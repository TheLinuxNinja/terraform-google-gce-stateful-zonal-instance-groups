resource "null_resource" "start" {
  triggers = {
    depends_id = "${var.depends_id}"
  }
}

resource "google_compute_disk" "boot" {
  depends_on = ["null_resource.start"]
  count      = "${var.amount}"

  name  = "${var.base_name}-boot-${count.index+var.offset+1}"
  type  = "${var.boot_disk_type}"
  zone  = "${data.google_compute_zones.all.names[(count.index+var.offset) % length(data.google_compute_zones.all.names)]}"
  image = "${var.boot_disk_source_image}"
  size  = "${var.boot_disk_size}"
}

resource "google_compute_address" "stateful" {
  count = "${var.amount}"
  name  = "${var.base_name}-${count.index+var.offset+1}"
}

resource "google_compute_instance_template" "stateful" {
  count        = "${var.amount}"
  machine_type = "${var.machine_type}"

  tags = ["${var.tags}"]

  can_ip_forward = "${var.can_ip_forward}"

  disk = {
    boot        = true
    source      = "${google_compute_disk.boot.*.name[count.index]}"
    auto_delete = false
  }

  network_interface {
    network = "${var.network}"

    address = "${var.address_fixed ? cidrhost(data.google_compute_subnetwork.current.ip_cidr_range, count.index+2+var.address_offset) : "" }"

    access_config = {
      nat_ip = "${google_compute_address.stateful.*.address[count.index]}"
    }
  }

  scheduling {
    preemptible       = "${var.preemptible}"
    automatic_restart = "${var.preemptible ? false : true}"
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = "${var.metadata}"
}

resource "google_compute_instance_group_manager" "stateful" {
  count = "${var.amount}"

  name               = "${var.base_name}-${count.index+var.offset+1}"
  base_instance_name = "${var.base_name}-${count.index+var.offset+1}"

  instance_template = "${google_compute_instance_template.stateful.*.self_link[count.index]}"

  zone = "${data.google_compute_zones.all.names[(count.index+var.offset) % length(data.google_compute_zones.all.names)]}"

  target_size     = 1
  update_strategy = "RESTART"

  lifecycle {
    create_before_destroy = true
  }

  # auto_healing_policies {
  #   health_check      = "${var.health_check}"
  #   initial_delay_sec = 500
  # }
}
