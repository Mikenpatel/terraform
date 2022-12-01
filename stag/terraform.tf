terraform {

  cloud {
    organization = "Miken001"

    workspaces {
     // name = "Serverless-sa-east-1"
     name = "Serverless-ca-central-1"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }

  //required_version = ">= 0.14.0"
}