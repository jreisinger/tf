output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.cloudserver.public_ip
}

output "instance_public_name" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_route53_record.cloudserver.name
}
