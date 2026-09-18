terraform {
  required_version = ">= 1.1.5"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 4.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
