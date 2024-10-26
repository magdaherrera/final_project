# Create ZIP file for the source code at deployment time
data "archive_file" "back_lambda_source_package" {
  type        = "zip"
  source_dir  = "${local.src_root_path}/back"
  output_path = "${local.src_root_path}/back.zip"
}

resource "aws_lambda_function" "insertarDatoslambda" {
  function_name = "${var.lambda_function_name_dynamo}-${random_string.id.result}"
  filename      = "${local.src_root_path}/back.zip"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "main.handler"
  runtime       = var.lambda_python_runtime                  
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.bird_table.name
    }
  }

  depends_on = [
    data.archive_file.back_lambda_source_package,
    aws_dynamodb_table.bird_table
  ]
  tags = var.aws_resource_tags
}




