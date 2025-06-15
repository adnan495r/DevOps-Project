# **AWS DevOps Infrastructure Project with Full-Stack Deployment & BI Dashboard**

This project is intended for learning or demonstrating end-to-end DevOps practices in a cloud-native environment.

It use Terraform and docker to automate the deployment of a secure, scalable, and containerized cloud infrastructure on AWS. 
It includes a basic full-stack application with a React frontend, Node.js backend, and a Metabase BI dashboard, backed by MySQL and PostgreSQL RDS databases.

**Key Features:**

**Infrastructure as Code:** Modular Terraform for VPC, EC2, RDS, ALB, ACM, IAM, and Route53.
**Secure Architecture:** 

 * HTTPS via ACM and Route53 DNS validation

 * Private RDS instances accessed via SSH tunnel through EC2

 * IAM roles with least privilege

**Containerized Deployment:** Dockerized frontend/backend with EC2 bootstrap scripts.

**BI & Analytics:** Metabase dashboard displaying live data from RDS.

**Load Balancing & SSL:** ALB with HTTPS, host-based routing, SSL certs via ACM, Auto-scaling, and HTTP to HTTPS redirection.


**Deployment includes:**
  * Terraform infrastructure provisioning
  * Secure database access and data loading
  * Application deployment via Docker Compose
  * Access to services through custom domains with HTTPS

**You'll need**
* An AWS account
* AWS console CLI
* Terraform
* Docker
* Command line tool of your choice

**Instructions**
1. Clone this repo
2. Configure AWS CLI
3. Review variables.tf and modify as needed
4. Use terraform to deploy
   - terraform init
   - terraform validate
   - terraform plan
   - terraform apply

**License**
This project is licensed under the MIT License. See the LICENSE file for details.
