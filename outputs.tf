output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.cloud_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.cloud_server.public_ip
}

output "instance_public_name" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_route53_record.cloud_server-record.name
}
