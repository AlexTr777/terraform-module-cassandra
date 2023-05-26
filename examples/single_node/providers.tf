provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}
