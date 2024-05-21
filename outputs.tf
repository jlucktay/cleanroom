output "instance_image" {
  description = "Boot disk image used by the instance."
  sensitive   = false

  value = one(google_compute_instance.main.boot_disk[*].initialize_params[*].image)
}

output "ssh_into_instance" {
  description = "Command to run to SSH into the instance."
  sensitive   = false

  value = format(
    "gcloud compute ssh --project=%s %s --zone=%s",
    var.project,
    google_compute_instance.main.name,
    google_compute_instance.main.zone,
  )
}
