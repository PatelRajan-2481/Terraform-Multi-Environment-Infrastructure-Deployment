variable "prefix" {
  type        = string
  description = "Prefix for resource naming"
}

variable "env" {
  type        = string
  description = "Environment (nonprod/prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key for EC2 instances"
}

variable "vm_sg_id" {
  type        = string
  description = "Security Group for VM5 & VM6"
}
