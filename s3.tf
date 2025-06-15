# S3 (optional): For logs or backups for metabase
locals {
  script_version = "v1.0.0"  # Increment this version when scripts change
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}


# Bucket name must be globally unique — the creation will fail if the name is already taken by any AWS user worldwide.
resource "aws_s3_bucket" "scripts" {
  bucket = "scripts-${random_string.suffix.result}"  
  
  tags = {
    Name        = "scripts"
    Environment = "dev"
    Version     = local.script_version
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "scripts" {
  bucket = aws_s3_bucket.scripts.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "scripts" {
  bucket = aws_s3_bucket.scripts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload MySQL dummy data SQL script to S3
resource "aws_s3_object" "mysql_dummy_data" {
  bucket  = aws_s3_bucket.scripts.id
  key     = "metabase_mysql_dummy_data.sql"
  source  = "${path.module}/metabase_mysql_dummy_data.sql"
  etag    = filemd5("${path.module}/metabase_mysql_dummy_data.sql")
  
  metadata = {
    "version"     = local.script_version
    "description" = "MySQL dummy data for Metabase"
  }
}

# Upload Metabase setup script to S3
resource "aws_s3_object" "metabase_setup" {
  bucket  = aws_s3_bucket.scripts.id
  key     = "metabase_setup.sh"
  source  = "${path.module}/metabase_setup.sh"
  etag    = filemd5("${path.module}/metabase_setup.sh")
  content_type = "text/x-shellscript"
  
  metadata = {
    "version"     = local.script_version
    "description" = "Metabase setup automation script"
  }
}

# Upload MySQL loader script to S3
resource "aws_s3_object" "mysql_loader" {
  bucket  = aws_s3_bucket.scripts.id
  key     = "metabase_load_mysql_dummy_data.sh"
  source  = "${path.module}/metabase_load_mysql_dummy_data.sh"
  etag    = filemd5("${path.module}/metabase_load_mysql_dummy_data.sh")
  content_type = "text/x-shellscript"
  
  metadata = {
    "version"     = local.script_version
    "description" = "MySQL data loader script"
  }
}