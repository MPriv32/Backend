provider "aws" {
  region = "us-west-1"
  access_key = var.my_access_key
  secret_key = var.my_secret_key
}

variable "my_access_key" {
  type = string
}

variable "my_secret_key" {
  type = string
}

terraform {
  required_providers {
    aws = {
      version = "~> 3.63.0"
    }
  }
}