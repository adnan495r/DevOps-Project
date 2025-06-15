# Launch Template for Amazon Linux 2
resource "aws_launch_template" "al2_lt" {
  name_prefix   = "al2-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/userdata_al2.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-al2"
    }
  }
}

# Auto Scaling Group for Amazon Linux 2
resource "aws_autoscaling_group" "al2_asg" {
  name                      = "al2-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = var.asg_desired_capacity
  health_check_type         = "ELB"                # Using ALB health checks
  health_check_grace_period = 300                  # 5 mins grace
  launch_template {
    id      = aws_launch_template.al2_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.public_1.id,
                               aws_subnet.public_2.id,
							   aws_subnet.public_3.id]

  target_group_arns         = [aws_lb_target_group.tg_al2.arn]

  tag {
    key                 = "Name"
    value               = "al2-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Metabase Launch Template
resource "aws_launch_template" "metabase" {
  name_prefix            = "metabase-lt-"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.metabase.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(
    templatefile("${path.module}/rds_tunnel.sh", {
      postgres_host       = aws_db_instance.postgresql.address
      postgres_port       = aws_db_instance.postgresql.port
      postgres_db_name    = var.postgresql_db_name
      postgres_username   = var.db_username
      postgres_password   = var.db_password
      mysql_host          = aws_db_instance.mysql.address
      mysql_port          = aws_db_instance.mysql.port
      mysql_db_name       = var.mysql_db_name
      mysql_username      = var.db_username
      mysql_password      = var.db_password
      s3_bucket_name      = aws_s3_bucket.scripts.id
      script_version      = local.script_version
    })
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "metabase-lt"
      Role = "metabase"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Metabase Auto Scaling Group
resource "aws_autoscaling_group" "metabase" {
  name                = "metabase-asg"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.public_metabase.id]
  target_group_arns   = [aws_lb_target_group.metabase.arn]

  launch_template {
    id      = aws_launch_template.metabase.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "metabase-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "metabase"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}