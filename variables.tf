variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "TempCloudInstance"
}

variable "zone_name" {
  description = "Name of the AWS Route53 zone"
  type        = string
  default     = "reisinge.net."
}
