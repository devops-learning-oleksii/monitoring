locals {
  security_groups = {
    https_public = {
      ingress_ports       = [80, 443]
      allowed_cidr_blocks = ["0.0.0.0/0"]
    }
    httpd = {
        ingress_ports = [80]
        allowed_cidr_blocks = ["10.0.0.0/16"]
    }
  }
}

data "aws_acm_certificate" "olzak" {
  domain = "*.olzak.click"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "olzak" {
  name = "olzak.click"
  private_zone = false
}