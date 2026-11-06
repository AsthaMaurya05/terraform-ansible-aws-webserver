variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "int333-webserver"
}

variable "instance_type" {
  description = "EC2 size (free-tier eligible only)"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "instance_type must be t2.micro or t3.micro."
  }
}

variable "public_key_path" {
  description = "Path to the SSH public key to upload to AWS"
  type        = string
  default     = "~/.ssh/int333_key.pub"
}

variable "ssh_allowed_cidr" {
  description = "Who may connect over SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_key_path" {
  description = "Path to the SSH private key used by Ansible"
  type        = string
  default     = "~/.ssh/int333_key"
}
