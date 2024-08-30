resource "aws_s3_bucket" "test" {
  bucket = "${var.aws_account_id}-test-bucket"
}

resource "aws_s3_object" "test" {
  bucket = aws_s3_bucket.test.bucket
  key    = "test.txt"
  source = "${path.module}/objects/test.txt" 
}

resource "aws_s3_bucket_public_access_block" "test" {
  bucket                  = aws_s3_bucket.test.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_test_notification" {
  bucket      = aws_s3_bucket.test.id
  eventbridge = true
}

resource "aws_s3_bucket_policy" "test_policy" {
  bucket = aws_s3_bucket.test.id
  policy = templatefile("${path.module}/policies/bucket-policy-test.json", {
    bucket_arn                              = aws_s3_bucket.test.arn
    admin_role_id     = var.admin_role_id
    developer_role_id = var.developer_role_id
    operator_role_id  = var.operator_role_id
    iam_user_id       = var.iam_user_id
  })
  depends_on = [ aws_s3_object.test ]
}