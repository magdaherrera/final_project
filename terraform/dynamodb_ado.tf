locals {
  extra_tag = "extra-tag"
}

#Creamos la tabla en dynamo db 

resource "aws_dynamodb_table" "bird_table" {
  name           = "bird_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "bird_table"
  }
}


#Creacion de la politica IAM 

resource "aws_iam_policy" "lambda_dynamodb_policy_test" {
  name        = "LambdaDynamoDBPolicy"
  description = "Policy that allows Lambda to write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.bird_table.arn
      }
    ]
  })
}

#Crear role IAM 

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy_test.arn
}


resource "aws_lambda_function" "insertarDatoslambda" {
  function_name = "InsertDynamoDBFunction"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"  
  runtime       = "python3.9"                     
  filename      = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.bird_table.name
    }
  }

  tags = {
    Name = "insertarDatoslambda"
  }
}




