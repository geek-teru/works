# Lambda関数のソースコードをZIP化
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda関数の定義
resource "aws_lambda_function" "config_change_notifier" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "config-change-notifier"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.config_changes.arn
    }
  }
}

# Lambda関数用のIAMロール
resource "aws_iam_role" "lambda_role" {
  name = "config-change-notifier-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda関数用のIAMロールポリシー
resource "aws_iam_role_policy" "lambda_policy" {
  name = "config-change-notifier-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.config_changes.arn
      }
    ]
  })
}

# EventBridgeルール
resource "aws_cloudwatch_event_rule" "config_changes" {
  name        = "capture-aws-config-changes"
  description = "Capture AWS Config configuration changes"

  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail-type = ["Config Configuration Item Change"]
  })
}

# EventBridgeルールとLambda関数の関連付け
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.config_changes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.config_change_notifier.arn
}

# Lambda関数のEventBridge呼び出し許可
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_change_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.config_changes.arn
}

# SNSトピック（通知用）
resource "aws_sns_topic" "config_changes" {
  name = "config-changes-notification"
}
