module "networking" {
  source              = "../../modules/aws_network"
  vpc_cidr            = "10.10.0.0/16"
  public_cidr_blocks  = []
  private_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24"]
  prefix              = "Rajan_prod"
  env                 = "prod"
}
