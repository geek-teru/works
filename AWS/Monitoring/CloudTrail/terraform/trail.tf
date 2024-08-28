resource "aws_cloudtrail" "trail" {
  depends_on = [aws_s3_bucket.trail]

  name                          = "trail"
  s3_bucket_name                = aws_s3_bucket.trail.bucket
  s3_key_prefix                 = "trail"
  include_global_service_events = false

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }


}