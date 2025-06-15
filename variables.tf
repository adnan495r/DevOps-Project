variable "aws_region" {
  description = "AWS Region is London"
  type        = string
  default     = "eu-west-2"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "aali_new_Key_pair"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# used in asg.tf
variable "asg_desired_capacity" {
  description = "AWS auto scaling group desired capacity"
  type        = number
  default     = 1
}

variable "al2_name" {
  description = "Amazon Linux 2 AMI Name for searching ID"
  type        = string
  default     = "amzn2-ami-hvm-*-x86_64-gp2"
}


variable "domain_name" {
  description = "my domain name"
  type        = string
  default     = "devops42.online"
}

variable "subdomain" {
  description = "Subdomain name for al2"
  type        = string
  default     = "aali"
}


variable "subdomain_al2" {
  description = "Subdomain name for al2"
  type        = string
  default     = "aali-al2"
}

variable "subdomain_bi" {
  description = "BI subdomain name"
  type        = string
  default     = "aali-bi"
}


# used in rds.tf
variable "db_username" {
  description = "database username"
  type        = string
  default     = "adnanfp"
  sensitive   = true
}

# used in rds.tf
variable "db_password" {
  description = "database password"
  type        = string
  default     = "Question42!"
  sensitive   = true
}

# used in rds.tf
variable "mysql_db_name" {
  description = "MySQL db name"
  type        = string
  default     = "mysql_db"
}

# used in rds.tf
variable "postgresql_db_name" {
  description = "PostgreSQL db name"
  type        = string
  default     = "postgresql_db"
}

variable "db_admin_email" {
  description = "Email for db admin"
  type        = string
  default     = "adnan@example.com"
}