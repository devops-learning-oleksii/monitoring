module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = merge(
    var.default_tags,
    {
      Unit = "Network"
    }
  )
}

module "sg" {
  source = "${path.module}/modules/sg"

  vpc_id          = module.vpc.vpc_id
  security_groups = local.security_groups

  tags = var.default_tags
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.olzak.zone_id
  name = "www"
  type = "A"

  alias {
    name = aws_lb.httpd.dns_name
    zone_id = aws_lb.httpd.zone_id
    evaluate_target_health = true
  }
}