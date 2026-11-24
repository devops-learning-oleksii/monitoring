data "aws_ami" "al2023_x86_64" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = ["al2023-ami-2023.*"]
  }
}

resource "aws_instance" "httpd" {
  count = 2
  ami = data.aws_ami.al2023_x86_64.id
  instance_type = "t3.micro"
  subnet_id = module.vpc.private_subnets[count.index % length(module.vpc.public_subnets)]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups = [ module.sg.sg_id["httpd"] ]

  user_data = file("${path.module}/configs/user_data.sh")
  depends_on = [ aws_ssm_parameter.cloudwatch_config ]
}

resource "aws_lb" "httpd" {
  name = "httpd"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.sg.sg_id["https_public"]]
  subnets = module.vpc.public_subnets
}

resource "aws_lb_target_group" "httpd" {
  name = "httpd"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "httpd" {
  for_each = { for k, v in aws_instance.httpd : k => v }

  target_group_arn = aws_lb_target_group.httpd.arn
  target_id = each.value.id
  port = 80
}

resource "aws_lb_listener" "http_httpd" {
  load_balancer_arn = aws_lb.httpd.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_httpd" {
  load_balancer_arn = aws_lb.httpd.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.olzak.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.httpd.arn
  }
}