# ----------------------------------------
# Backend Settings
# ----------------------------------------
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "dev-terraform-aws"
    region  = "ap-northeast-1"
    key     = "s3_bucket_policy/terraform.tfstate"
    acl     = "bucket-owner-read"
    encrypt = true
  }
}