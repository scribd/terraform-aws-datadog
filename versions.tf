terraform {
  required_version = ">= 0.13, < 0.14"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 2.13"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}
