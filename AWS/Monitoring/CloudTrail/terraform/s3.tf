resource "aws_s3_bucket" "trail" {
  bucket = "trail-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}

resource "aws_s3_bucket" "data" {
  bucket = "data-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}