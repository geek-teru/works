# iam policy
resource "aws_iam_policy" "trail" {
  name = "trail-policy"
  policy = file("${path.module}/policies/trail-role.json")
}

# iam role
resource "aws_iam_role" "trail" {
  name = "trail-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "trail.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "trail" {
  role       = aws_iam_role.trail.name
  policy_arn = aws_iam_policy.trail.arn
}