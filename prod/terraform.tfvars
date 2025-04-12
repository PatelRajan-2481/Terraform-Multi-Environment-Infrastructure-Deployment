env = "prod"
prefix = "Rajan_prod"

vpc_cidr = "10.10.0.0/16"

private_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24"] #Only private subnets in prod

ssh_key_name = "key1"

vpc_id          = "vpc-02354d7193337bb1d"  
private_subnets = ["subnet-00d79a169ff897486", "subnet-087e98b54f84f679d"] 
vm_sg_id        = "sg-09f06e17fb3d5331a" 
 