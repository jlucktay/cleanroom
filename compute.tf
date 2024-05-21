data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

resource "random_shuffle" "compute_zones" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

resource "google_compute_instance" "main" {
  project = var.project
  name    = var.name

  machine_type = "e2-standard-2"

  metadata_startup_script = file("${path.module}/files/instance_startup.sh")

  zone = one(random_shuffle.compute_zones.result)

  allow_stopping_for_update = true
  can_ip_forward            = false
  deletion_protection       = false
  enable_display            = false

  labels = {}

  resource_policies = []

  metadata = {
    enable-guest-attributes : "TRUE",

    # https://github.com/GoogleCloudPlatform/guest-agent/issues/394
    enable-oslogin : "FALSE",

    serial-port-logging-enable : "TRUE",
  }

  tags = [
    "ssh",
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 100
      type  = "pd-ssd"

      resource_manager_tags = {}
    }

    auto_delete = true

    mode = "READ_WRITE"
  }

  network_interface {
    access_config {
      network_tier = "PREMIUM"

      // Ephemeral public IP
    }

    network            = module.network.network_name
    subnetwork         = one(module.network.subnets_names[*])
    subnetwork_project = var.project

    stack_type = "IPV4_ONLY"
  }

  scheduling {
    automatic_restart = true
    preemptible       = false

    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = google_service_account.main.email

    scopes = [
      "cloud-platform",
    ]
  }
}
