resource "aws_instance" "bastion" {
  ami                         = "ami-083e9f3cc36cb84a8" # Ubuntu 20.04 LTS
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  # key_name                    = var.key_name

  tags = {
    Name  = "Bastion"
    Owner = "CloudAcademy"
  }
}
