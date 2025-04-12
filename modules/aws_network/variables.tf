variable "public_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "private_cidr_blocks" {
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}


variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR Block"
}

variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags for AWS resources"
}

variable "prefix" {
  type        = string
  default     = "Rajan"
  description = "Resource Name Prefix"
}

variable "env" {
  default     = "nonprod"
  type        = string
  description = "Environment Name"
}

#Change everytime Cloud9'ip change or assign elastic ip to cloud 9
variable "allowed_ips" {
  default     = ["54.227.66.30/32"] #Allowing Cloud9 to access Bastion Host
  type        = list(string)
  description = "Allowed IPs for SSH access"
}

variable "ssh_key_name" {
  default     = "key1"
  type        = string
  description = "SSH Key for EC2 instances"
}
