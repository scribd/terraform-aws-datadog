terraform {
  required_version = ">= 0.13"

  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 2.10"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}
