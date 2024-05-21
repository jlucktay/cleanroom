data "external" "get_my_ip" {
  program = [
    "/bin/bash",
    "${path.module}/scripts/get-my-ip.sh",
  ]
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project
  network_name = var.name

  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name   = "cleanroom"
      subnet_ip     = "10.128.0.0/24"
      subnet_region = var.region
    },
  ]

  ingress_rules = [
    {
      name = "ssh"

      source_ranges = [
        format("%s/%s", data.external.get_my_ip.result["public_ip"], 32),
      ]

      target_tags = [
        "ssh",
      ]

      allow = [
        {
          protocol = "TCP"

          ports = [
            "22",
          ]
        },
      ]
    },
  ]
}
