terraform {
  backend "s3" {
    bucket  = "rajan-prod-terraform-state-bucket1"
    key     = "prod/networking/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
