terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "aws" {
  #region = "us-east-1"
  #profile = "personal"
}