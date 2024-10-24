# Output API Gateway URL
output "api_url" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

# output "cloudfront_domain_name" {
#   value       = aws_cloudfront_distribution.cdn.domain_name
#   description = "La URL de CloudFront para acceder al contenido."
# }
