resource "aws_acm_certificate" "app_cert" {
  domain_name               = "${var.subdomain}.${var.domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = [
    "${var.subdomain_al2}.${var.domain_name}", 
	"${var.subdomain_bi}.${var.domain_name}"
  ]

  tags = {
    Name = "alb-and-ec2-subdomains-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
