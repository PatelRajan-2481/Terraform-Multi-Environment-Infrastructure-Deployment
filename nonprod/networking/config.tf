terraform {
  backend "s3" {
    bucket = "rajan-nonprod-terraform-state-bucket1"
    key    = "nonprod/networking/terraform.tfstate"
    region = "us-east-1"
  }
}
