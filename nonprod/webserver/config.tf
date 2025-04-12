terraform {
  backend "s3" {
    bucket  = "rajan-nonprod-terraform-state-bucket1"
    key     = "nonprod/webserver/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
