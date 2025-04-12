terraform {
  backend "s3" {
    bucket  = "rajan-prod-terraform-state-bucket1"
    key     = "prod/webserver/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
