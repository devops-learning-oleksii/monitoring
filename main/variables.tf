variable "default_tags" {
  type = object({
    Environment = string
    managed_by  = string
    project     = string
  })

  default = {
    Environment = "dev"
    managed_by  = "terraform"
    project     = "nebo"
  }
}