data "aws_caller_identity" "current" {}

variable "system_name" {
  type = string
}

variable "env" {
  type = string
}
