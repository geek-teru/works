# AWS Configの設定
resource "aws_config_configuration_recorder" "main" {
  name     = "config-recorder"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    all_supported = false
    include_global_resource_types = true
    
    resource_types = [
      "AWS::IAM::Group",
      "AWS::IAM::Policy",
      "AWS::IAM::Role",
      "AWS::IAM::User",
      "AWS::S3::Bucket",
      "AWS::S3::AccountPublicAccessBlock",
      "AWS::S3::BucketPolicy"
    ]
  }
}

# AWS Config配信チャネル（S3バケットに結果を保存）
resource "aws_config_delivery_channel" "main" {
  name           = "config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  depends_on     = [aws_config_configuration_recorder.main]
}

# AWS Config設定レコーダーの有効化
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.main]
}
