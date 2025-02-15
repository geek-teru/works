# AWS Config用のS3バケット
resource "aws_s3_bucket" "config_bucket" {
  bucket = "aws-config-${data.aws_caller_identity.current.account_id}"
}

# S3バケットのバージョニングを有効化
resource "aws_s3_bucket_versioning" "config_bucket_versioning" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3バケットの暗号化を有効化
resource "aws_s3_bucket_server_side_encryption_configuration" "config_bucket_encryption" {
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
