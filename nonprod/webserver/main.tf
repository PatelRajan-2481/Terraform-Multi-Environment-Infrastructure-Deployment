module "webserver" {
  source          = "../../modules/aws_webserver"
  prefix          = "nonprod"
  ssh_key_name    = var.ssh_key_name
  vpc_id          = var.vpc_id
  public_subnets  = var.public_subnets
  bastion_sg_id   = var.bastion_sg_id
  private_subnets = var.private_subnets
  db_sg_id        = var.db_sg_id
  app_sg_id       = var.app_sg_id
  web_sg_id      = var.web_sg_id
  env             = "nonprod"
}
