terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # ~> (pessimistic constraint operator) allows only the rightmost version
      # component to increment
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "cloud_server" {
  # ami chosen via https://cloud-images.ubuntu.com/locator/ec2/
  ami           = "ami-083e9f3cc36cb84a8"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get isntall nmap
              # echo "Hello, World" > index.html
              # nohup busybox httpd -f -p 8080 &
              EOF

  # So when you change user_data and run apply, Terraform will terminate the
  # original insance and launch a new instance.
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}
