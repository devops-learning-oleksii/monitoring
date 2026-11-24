variable "security_groups" {
  type = map(object({
    ingress_ports       = list(number)
    allowed_cidr_blocks = list(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "tags" {
}