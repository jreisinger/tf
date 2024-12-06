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
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMiUjr78aDlJ3689mhuOhi4+D8aaSO+o43GhrF3QtHH"
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
  ami = var.ami != "" ? var.ami : data.aws_ami.ubuntu.image_id

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
