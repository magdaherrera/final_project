output "lambda_url" {
    value = aws_lambda_function_url.lambda_url.function_url
}

# Output API Gateway URL
output "api_url" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}
