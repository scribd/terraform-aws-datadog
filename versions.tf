terraform {
  required_version = ">= 0.13, < 1.3.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 2.10, < 4"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
