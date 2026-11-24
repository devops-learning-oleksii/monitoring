resource "aws_security_group" "this" {
  for_each = var.security_groups
  name     = each.key
  vpc_id   = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = each.value.allowed_cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}