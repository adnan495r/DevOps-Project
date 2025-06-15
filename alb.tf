resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [ # Use public subnets
                        aws_subnet.public_1.id,
                        aws_subnet.public_2.id,
                        aws_subnet.public_3.id
                       ]
  tags = { Name = "app-alb" }
  depends_on = [aws_security_group.alb_sg]
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tg_al2.arn
        weight = 100
      }
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.tg_al2.arn
        weight = 100
      }
    }
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]
}

# Listener Rules
resource "aws_lb_listener_rule" "rule_al2_http" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  condition {
    host_header {
      values = ["${var.subdomain}.${var.domain_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2.arn
  }


}

resource "aws_lb_listener_rule" "rule_al2_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 20

  condition {
    host_header {
      values = ["${var.subdomain}.${var.domain_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_al2.arn
  }


}

# Metabase Listener Rule (subdomain_bi.domain.com) - HTTPS
resource "aws_lb_listener_rule" "rule_metabase_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 15

  condition {
    host_header {
      values = ["${var.subdomain_bi}.${var.domain_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase.arn
  }
}