# Create Dynamodb table
resource "aws_dynamodb_table" "bird_table" {
  name           = lower("dynamo-${var.aws_resource_tags["project"]}-${var.aws_resource_tags["environment"]}-${random_string.id.result}")
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.aws_resource_tags
}

# IAM Role to be assumed by lambda
resource "aws_iam_role" "lambda_exec" {
  name = lower("iam-role-lambda-back-${var.aws_resource_tags["project"]}-${var.aws_resource_tags["environment"]}-${random_string.id.result}")

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy to access dynamodb
resource "aws_iam_policy" "lambda_dynamodb_policy_test" {
  name        = lower("iam-policy-dynamo-${var.aws_resource_tags["project"]}-${var.aws_resource_tags["environment"]}-${random_string.id.result}")
  description = "Policy that allows Lambda to write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.bird_table.arn
      }
    ]
  })
}

# Bind policies to role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy_test.arn
}


