# Target group for Amazon Linux 2
resource "aws_lb_target_group" "tg_al2" {
  name     = "tg-al2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


# Target group for Node.js application

resource "aws_lb_target_group" "node_app_tg" {
  name     = "node-app-tg"
  port     = 3000                    # Port where the app listens
  protocol = "HTTP"
vpc_id   = data.aws_vpc.default.id

# Health check to monitor app availability
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "node-app-tg"
  }
}

# Metabase Target Group
resource "aws_lb_target_group" "metabase" {
  name     = "metabase-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  # Use this target_type for instances in an auto scaling group
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"  # Updated to use dedicated health check endpoint
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "metabase-tg"
  }
}