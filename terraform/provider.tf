provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project   = "int333-webserver"
      ManagedBy = "Terraform"
    }
  }
}
