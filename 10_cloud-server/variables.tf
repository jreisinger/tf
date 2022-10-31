variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "eu-central-1" # Frankfurt
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "TempCloudServer"
}

variable "packages" {
  description = "Ubuntu packages to install into the server"
  type        = list(string)
  default     = ["nmap"]
}

variable "ami" {
  description = "AMI ID to deploy"
  type        = string
  default     = "" # will use data from AWS
}
