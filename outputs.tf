output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.public_3.id,
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
    aws_subnet.private_3.id,
  ]
}

output "ec2_public_ips" {
  description = "EC2 Instances Public IPs"
  value = [
    aws_instance.amazon_linux_2.public_ip
  ]
}

output "rds_mysql_endpoint" {
  description = "MySQL RDS Endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_postgresql_endpoint" {
  description = "PostgreSQL RDS Endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.app_alb.dns_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.scripts.bucket
}



data "aws_instances" "metabase" {
  filter {
    name   = "tag:Role"
    values = ["metabase"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

output "all_metabase_instance_ids" {
  value = data.aws_instances.metabase.ids
}
