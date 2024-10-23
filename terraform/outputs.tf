# Output API Gateway URL
output "api_url" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}
