variable "tags" {
  type = object({
    Environment = string
    managed_by  = string
  })
  default = {
    Environment = "dev"
    managed_by  = "terraform"
  }
}