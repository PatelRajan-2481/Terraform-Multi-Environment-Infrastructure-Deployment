# Web Servers (Only in Nonprod)
resource "aws_instance" "web" {
  count                       = var.env == "nonprod" ? 2 : 0
  ami                         = "ami-01f5a0b78d6089704"
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnets[count.index] # Deploy in Public Subnets
  security_groups = var.web_sg_id != null ? [var.web_sg_id] : []
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  # User Data Script:
  user_data = <<-EOF
               #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
              
              echo "<html>
              <head><title>Welcome to NonProd</title></head>
              <body>
              <h1>Deployed by Terraform</h1>
              <p><strong>Name:</strong> Rajan Patel</p>
              <p><strong>Environment:</strong> NonProd</p>
              <p><strong>Private IP:</strong> $PRIVATE_IP</p>
              </body>
              </html>" > /var/www/html/index.html
              
              EOF

  tags = {
    Name = "${var.prefix}-web-${count.index}"
  }
}

# Database (Only in Nonprod)
resource "aws_instance" "db" {
  count                 = var.env == "nonprod" ? 1 : 0
  ami                   = "ami-01f5a0b78d6089704"
  instance_type         = "t2.micro"
  subnet_id             = var.private_subnets[0] # Deploy in Private Subnet
  vpc_security_group_ids = var.db_sg_id != null ? [var.db_sg_id] : [] 
  key_name              = var.ssh_key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y mariadb-server
              sudo systemctl start mariadb
              sudo systemctl enable mariadb
              echo "Database VM3 setup complete" > /home/ec2-user/db_setup.log
              EOF

  tags = {
    Name = "${var.prefix}-db"
  }
}

#App Server (Only in Nonprod)
resource "aws_instance" "app_server" {
  count                 = var.env == "nonprod" ? 1 : 0
  ami                   = "ami-01f5a0b78d6089704"
  instance_type         = "t2.micro"
  subnet_id             = var.private_subnets[1] # Deploy in Private Subnet
  vpc_security_group_ids = [var.app_sg_id]
  key_name              = var.ssh_key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              echo "App Server VM4 setup complete" > /home/ec2-user/app_setup.log
              EOF

  tags = {
    Name = "${var.prefix}-app"
  }
}

#Deploy VM5 in Private Subnet 1 (Only in Prod)
resource "aws_instance" "vm5" {
  count           = var.env == "prod" ? 1 : 0
  ami             = "ami-01f5a0b78d6089704"
  instance_type   = "t2.micro"
  subnet_id       = var.private_subnets[0]
  security_groups = var.vm_sg_id != null ? [var.vm_sg_id] : []
  key_name        = var.ssh_key_name

  tags = {
    Name = "${var.prefix}-vm5"
  }
}

# VM6 in Private Subnet 2 (Only in Prod)
resource "aws_instance" "vm6" {
  count           = var.env == "prod" ? 1 : 0
  ami             = "ami-01f5a0b78d6089704"
  instance_type   = "t2.micro"
  subnet_id       = var.private_subnets[1]
  security_groups = var.vm_sg_id != null ? [var.vm_sg_id] : []
  key_name        = var.ssh_key_name

  tags = {
    Name = "${var.prefix}-vm6"
  }
}
