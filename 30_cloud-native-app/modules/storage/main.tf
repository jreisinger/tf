resource "aws_instance" "mongo" {
  ami                    = "ami-083e9f3cc36cb84a8" # Ubuntu 20.04 LTS
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  # key_name               = var.key_name

  /*
  user_data = << EOF
  #! /bin/bash
  sudo apt-get update
  sudo apt-get install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  echo "<h1>CloudAcademy 2021</h1>" | sudo tee /var/www/html/index.html
	EOF
  */

  user_data = filebase64("${path.module}/install.sh")

  tags = {
    Name  = "Mongo"
    Owner = "CloudAcademy"
  }
}
