module "networking" {
  source             = "../../modules/aws_network"
  vpc_cidr           = "10.0.0.0/16"
  public_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  prefix             = "Rajan_nonprod"
  env                = "nonprod"
}
