# 🚀 Terraform Multi-Environment Infrastructure Deployment Guide

![Infrastructure Overview](https://github.com/PatelRajan-2481/Terraform-Multi-Environment-Infrastructure-Deployment/blob/main/Infrastrucutre-Overview.png)

---


---

## 📘 INTRODUCTION
This project demonstrates an automated deployment of a multi-environment infrastructure in AWS using:
- **Terraform** (Infrastructure as Code)

The setup provisions and configures the following:
- Two isolated VPCs (**Nonprod** and **Prod**) with respective public and private subnets
- Bastion Host for secure SSH access to private instances
- Application Load Balancer to distribute traffic (Nonprod only)
- EC2 instances for web, application, and database tiers
- NAT Gateway for private subnet internet access
- Strict Security Groups to enforce access control

---

## ⚙️ SYSTEM SETUP - PRE-REQUISITES
Before deploying, ensure the following:

### ✅ AWS Requirements
- AWS CLI is configured:
```bash
aws configure
```
- S3 bucket is created and backend blocks are updated in `config.tf`

### ✅ Terraform Setup
Install Terraform:
```bash
sudo yum install -y terraform
```

Update allowed IPs in:
```hcl
# modules/aws_network/variables.tf
variable "allowed_ips" {
  default = ["<Cloud9-Public-IP>/32"]
}
```

Update SSH key name in:
```hcl
variable "ssh_key_name" {
  default = "your_key_pair_name"
}
```

---

## 🛠 DEPLOYMENT STEPS

### 1️⃣ Deploy Nonprod Networking
```bash
cd terraformproject/nonprod/networking/
terraform init
terraform apply -auto-approve
```
Outputs:
- VPC ID
- Public & Private Subnet IDs
- Bastion Host IP
- Security Group IDs

### 2️⃣ Update `terraform.tfvars` for Nonprod Webserver
```hcl
vpc_id          = "vpc-XXXXXXXX"
public_subnets  = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
private_subnets = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
bastion_sg_id   = "sg-XXXXXXXX"
web_sg_id       = "sg-XXXXXXXX"
db_sg_id        = "sg-XXXXXXXX"
app_sg_id       = "sg-XXXXXXXX"
```

### 3️⃣ Deploy Nonprod Webserver
```bash
cd ../webserver/
terraform init
terraform apply -var="env=nonprod" -auto-approve
```

### 4️⃣ Verify Nonprod Setup
```bash
ssh -i key1.pem ec2-user@<bastion_public_ip>
curl http://<alb_dns_name>
curl http://<webserver0_public_ip>
curl http://<webserver1_private_ip>
ssh -i key1.pem ec2-user@<vm1_private_ip>
```

### 5️⃣ Deploy Prod Networking
```bash
cd terraformproject/prod/networking/
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve
```

### 6️⃣ Update `terraform.tfvars` for Prod Webserver
```hcl
vpc_id          = "vpc-XXXXXXXX"
private_subnets = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
vm_sg_id        = "sg-XXXXXXXX"
```

### 7️⃣ Deploy Prod Webserver
```bash
cd ../webserver/
terraform init
terraform apply -var-file=../terraform.tfvars -auto-approve
```

---

## 🧪 TROUBLESHOOTING & COMMON ISSUES

### 🔐 SSH Errors
```bash
chmod 400 key1.pem
```
Ensure security groups allow port 22.

### 🌐 Load Balancer Timeout
```bash
systemctl status httpd
```
Ensure port 80 is allowed.

### 🛑 Database Access Issues
```bash
telnet <vm3_private_ip> 3306
sudo systemctl restart mariadb
```

---

## 🧹 CLEANUP
```bash
# Destroy in order
terraform destroy -var-file=../terraform.tfvars -auto-approve   # Prod Webserver
terraform destroy -var-file=../terraform.tfvars -auto-approve   # Prod Networking
terraform destroy -var="env=nonprod" -auto-approve              # Nonprod Webserver
terraform destroy -auto-approve                                 # Nonprod Networking
```

---

## 📬 CONTACT
**Email**: rhpatel27@myseneca.ca

