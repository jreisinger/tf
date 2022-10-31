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
  region = var.region
}

# --- networking ---

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --- security ---

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- instance ---

resource "aws_key_pair" "pubkey" {
  key_name   = "jr-mac-pub-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0ScV2K2jy1Vah+tgri4eHAn9+iTt8Rt5n5dQfb2DcCVjRyBZNj4nudwtPjE6raiVqWEmD2vn31i32+Xgq/B8bonMV8tgdJ7GSM9980+CZxJlO03b8rr7MQTYVDQ+J9Op/DQsZ1w/gCg93XEKeFQZp+UaUVydImI8IKEWpKA4OQHdGMoIdt6woWzCUvvmygMvzq+eEymbZgrxqD+Iwb9TZHfIWLPXsxVq9kn0iTQaaAusPY8hxrfv/bj0ns+ULVQ/67dmA1aeFB5yRbo3mq+vRt9dRAjHOKvqDR9JmBwtgEWiMYbdK5+GFVExiQLPnzWIyWTSahAuSdet3swBf9+sRaokz0f54sxFXRfynivlyxb34bMpUfZzrOuZMKRFDkM7udymugF1RPxEb69W5p+BA3k5KZy0Gf83VmW9k9QiM4rjM9fO6gvCfiu2xLAgdDWh8jBu6mK07nrhY5Wsj+/S2BgV+MGfmQDv9LEXXIb9NcR39nzDRRTvFao4TsWLbCgU="
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "cloudserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "jr-mac-pub-key"

  private_ip = "10.0.0.12"
  subnet_id  = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = <<-EOF
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install ${join(" ", var.packages)}
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
