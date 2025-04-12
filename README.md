# Terraform Multi-Environment Infrastructure Deployment Guide


# Introduction

This project automates the deployment of a multi-environment infrastructure using Terraform. The setup includes:
•	Two isolated VPCs (Nonprod and Prod) with respective public and private subnets.
•	Bastion Host for secure SSH access to private VMs.
•	Application Load Balancer to distribute traffic in the Nonprod environment.
•	EC2 Instances for web servers, application servers, and databases.
•	Security Groups to enforce access control and firewall rules.
•	NAT Gateway to allow outbound internet access from private subnets.

This guide ensures a smooth deployment, testing, and troubleshooting process.


# System Setup-Pre-requisites

Before starting the deployment, ensure that the following requirements are met:

1.	Terraform Installed: Ensure Terraform is installed on your system. I
    If not, install it using: 
    
        sudo yum install -y terraform

2.	AWS CLI Configured: Set up AWS CLI with your credentials. 

        aws configure
            
3.	Cloud9 IP Update: Update allowed_ips variable.tf file for SSH access into bastion host

    •	Open modules /terraformproject/modules/aws_network/variables.tf
    •	Locate the variable allowed_ips
    •	Update the value with Cloud9's Public IP
    •	Example:

                variable "allowed_ips" {
                  default = ["<Cloud9-Public-IP>/32"]
            }
            
4. S3 Backend for Remote State:

You must create an S3 bucket before deployment.

    Update config.tf with Your S3 Bucket Name

    In both Nonprod and Prod, navigate to config.tf inside networking and webserver folders.

    Change the backend "s3" block to match your S3 bucket name:

        terraform {
          backend "s3" {
            bucket         = "<your-bucket-name>"
            key            = "terraform/state"
            region         = "us-east-1"
          }
        }


5.	SSH Key Pair Configuration:

    • Key pair should be created once and used in all deployments.
    • key1.pem already exist in the root folder, you can upload that to your aws environment or If you create a new key, reference it in modules/aws_network/variables.tf.
        Example: 

            variable "ssh_key_name" {
              default = "your_key_pair_name"
            }
            
            
   • To create a new key (if required), run: ssh-keygen -t rsa -f key1.pem
      
   • If needed copy key to Bastion Host: scp -i key1.pem key1.pem ec2-user@<bastion_public_ip>:~
     
   • Ensure correct permissions:  chmod 400 key1.pem
    
   • If needed copy key to VM1(Webserver) to SSH into private VMs(Database server): scp -i key1.pem key1.pem ec2-user@<vm1_private_ip>:~
   
  

# 🛠 Deployment Steps

<Step 1: Deploy Nonprod Networking>

Run the following commands from terraformproject/nonprod/networking/:

        terraform init
        terraform apply -auto-approve
            
Outputs after successful deployment:

        •	VPC ID
        •	Subnet IDs (Public & Private)
        •	Bastion Public IP
        •	Security Group IDs (Web, App, DB)
        
        
<Step 2: ⚠ Update terraform.tfvars for Webserver Deployment>

Before deploying the web servers, manually update terraform.tfvars with VPC ID, Subnets, and Security Groups obtained in Step 1.
        •	Navigate to nonprod/webserver: cd ../webserver
        
        •	Edit terraform.tfvars file and update: vpc_id ,public_subnets, private_subnets,  bastion_sg_id,  web_sg_id , db_sg_id , app_sg_id
        
        •	Example:
                    vpc_id          = "vpc-XXXXXXXX"
                    public_subnets  = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
                    private_subnets = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
                    bastion_sg_id   = "sg-XXXXXXXX"
                    web_sg_id       = "sg-XXXXXXXX"
                    db_sg_id        = "sg-XXXXXXXX"
                    app_sg_id       = "sg-XXXXXXXX"
                    
                    
<Step 3: Deploy Nonprod Webserver> 

Move to terraformproject/nonprod/webserver/ and run using “env=nonprod” :

                terraform init
                terraform apply -var="env=nonprod" -auto-approve

Outputs after successful deployment:

                •	Webserver Private & Public IPs
                •	ALB DNS Name

<Step 4: Verify Nonprod Setup>

    1.	Access the Bastion Host: ssh -i key1.pem ec2-user@<bastion_public_ip>
    2.	Test Web Server & Load Balancer
        •	Open a web browser and access: http://<alb_dns_name>, http://<webserver0_public_ip>, http://<webserver1_private_ip>
        •	Run curl from Cloud9: curl http://<alb_dns_name>, curl http://<webserver0_public_ip>, curl http://<webserver1_private_ip>

    3.	SSH into Instances:     ssh -i key1.pem ec2-user@<vm1_private_ip>
                                ssh -i key1.pem ec2-user@<vm2_private_ip>
                                ssh -i key1.pem ec2-user@<vm3_private_ip>
                                ssh -i key1.pem ec2-user@<vm4_private_ip>
                                

<Step 5: Deploy Prod Networking with help of terraform.tfvars file>

Move to terraformproject/prod/networking/ and run:

        terraform init
        terraform apply -var-file=../terraform.tfvars -auto-approve
    
Outputs after successful deployment:

        •	VPC ID
        •	Subnet IDs (Private Only)
        •	Security Group IDs
    
<Step 6: ⚠ Update terraform.tfvars Before Deploying Prod Webserver>

Before deploying the web server, update the _tfvars_ file with the correct values. Otherwise it will ask to enter value manually.

•	Navigate to prod/webserver: cd ../prod/webserver
•	Edit terraform.tfvars file and update: vpc_id, private_subnets, vm_sg_id
•	Example:  

            vpc_id          = "vpc-XXXXXXXX"
            private_subnets = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
            vm_sg_id        = "sg-XXXXXXXX"
            
<Step 7: Deploy Prod Webserver with help of updated terraform.tfvars file>

Move to terraformproject/prod/webserver/ and run:

            terraform init
            terraform apply -var-file=../terraform.tfvars -auto-approve
            

# Troubleshooting & Common Issues

<1. SSH Issues:>
    •	If "Permission denied" occurs: 
        o	Ensure you copied the correct key1.pem to the bastion host.
        o	Update file permissions:
                        chmod 400 key1.pem

•	If Bastion cannot reach private VMs, check security group rules.

<2. Load Balancer 504 Gateway Timeout:>

    •	Ensure web servers are running: 
                systemctl status httpd

•	Ensure security groups allow HTTP traffic.

<3. Database Connection Issues>

•	Verify VM1 can reach VM3 on port 3306: 

        telnet <vm3_private_ip> 3306
        
•	Restart MariaDB: 

        sudo systemctl restart mariadb
        

# Cleanup and Destroy

Destroy the infrastructure, run the following in the correct order:

1.	Destroy Prod Webserver 
        terraform destroy -var-file=../terraform.tfvars -auto-approve

2.	Destroy Prod Networking 
        terraform destroy -var-file=../terraform.tfvars -auto-approve

3.	Destroy Nonprod Webserver 
        terraform destroy -var="env=nonprod" -auto-approve

4.	Destroy Nonprod Networking 
        terraform destroy -auto-approve

# Contact

If you encounter any issues, feel free to contact: rhpatel27@myseneca.ca


