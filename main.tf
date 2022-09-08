terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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
              apt-get update
              apt-get isntall nmap
              EOF

  tags = {
    Name = var.instance_name
  }
}
