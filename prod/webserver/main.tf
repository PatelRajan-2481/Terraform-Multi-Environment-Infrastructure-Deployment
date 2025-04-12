module "webserver" {
  source         = "../../modules/aws_webserver"
  prefix         = var.prefix
  vpc_id         = var.vpc_id
  private_subnets = var.private_subnets
  ssh_key_name   = var.ssh_key_name
  env            = var.env
  
#Ensure correct security groups for both environments
  public_subnets = var.env == "nonprod" ? var.public_subnets : []
  bastion_sg_id  = var.env == "nonprod" ? var.bastion_sg_id : null
  db_sg_id       = var.env == "nonprod" ? var.db_sg_id : null
  app_sg_id      = var.env == "nonprod" ? var.app_sg_id : null
  web_sg_id      = var.env == "nonprod" ? var.web_sg_id : null  #Only needed in nonprod
  vm_sg_id       = var.env == "prod" ? var.vm_sg_id : null # Only needed in prod
}
