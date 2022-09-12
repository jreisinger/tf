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

resource "aws_key_pair" "pubkey" {
  key_name   = "mac-pub-key"
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
  key_name      = "mac-pub-key"

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

data "aws_route53_zone" "selected" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "cloudserver" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.record_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.cloudserver.public_ip]
}
