#Before Fixing to support both env
# resource "aws_instance" "bastion" {
# count             = var.env == "nonprod" ? 1 : 0 
#   ami                         = "ami-014d544cfef21b42d"
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_subnet[0].id # Deploy in public subnet
#   associate_public_ip_address = true
#   key_name                    = var.ssh_key_name
#   security_groups             = [aws_security_group.bastion_sg.id]

#   tags = {
#     Name = "${var.prefix}-bastion"
#   }
# }

resource "aws_instance" "bastion" {
  count           = var.env == "nonprod" ? 1 : 0 #Only create in `nonprod`
  ami             = "ami-01f5a0b78d6089704"
  instance_type   = "t2.micro"
  subnet_id       = length(aws_subnet.public_subnet) > 0 ? aws_subnet.public_subnet[0].id : null
  associate_public_ip_address = true
  key_name        = var.ssh_key_name
  security_groups = length(aws_security_group.bastion_sg) > 0 ? [aws_security_group.bastion_sg[0].id] : []

  tags = {
    Name = "${var.prefix}-bastion"
  }
}
