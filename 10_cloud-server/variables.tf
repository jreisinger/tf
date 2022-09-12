variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "TempCloudServer"
}

variable "zone_name" {
  description = "Name of the Route53 zone"
  type        = string
  default     = "reisinge.net."
}

variable "record_name" {
  description = "Name of the Route53 record"
  type        = string
  default     = "cloud"
}

variable "packages" {
  description = "Ubuntu packages to install into the server"
  type        = list(string)
  default     = ["nmap"]
}
