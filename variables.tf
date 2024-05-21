variable "project" {
  description = "Google Cloud project."
  type        = string
}

variable "region" {
  description = "Google Cloud region."
  type        = string
}

variable "name" {
  description = "Name the network, VM, and other assorted resources."
  type        = string
  default     = "cleanroom"

  validation {
    condition     = length(var.name) <= 30
    error_message = "Name must be at most 30 characters in length."
  }
}
