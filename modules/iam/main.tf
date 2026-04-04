resource "aws_iam_policy" "startStopInstance_policy" {
  name        = "${var.project_name}_startStopInstance"
  path        = "/"
  description = "Start and Stop instance policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user" "user" {
  name = "${var.project_name}_startStopInstance"
}

resource "aws_iam_user_policy_attachment" "startStopInstance_policy_attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.startStopInstance_policy.arn
}