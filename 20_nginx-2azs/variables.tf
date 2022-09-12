variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}
# variable "key_name" {
#   type = string
# }

variable "availability_zones" {
  type = list(string)
}

variable "workstation_ip" {
  type = string
}

variable "amis" {
  type = map(any)
  default = {
    # filtered from https://cloud-images.ubuntu.com/locator/ec2/
    "eu-central-1" : "ami-083e9f3cc36cb84a8"
    "eu-central-1" : "ami-083e9f3cc36cb84a8"
  }
}
