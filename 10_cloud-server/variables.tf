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
