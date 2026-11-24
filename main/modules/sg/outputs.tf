output "sg_id" {
  value = { for sg, res in aws_security_group.this : sg => res.id }
}