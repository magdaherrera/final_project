
# # resource "aws_s3_bucket" "static_site" {
# #   bucket = "your-private-bucket-name"
  
# #   # Block public access
# #   acl = "private"
# # }

# # resource "aws_s3_bucket_policy" "s3_policy" {
# #   bucket = aws_s3_bucket.static_site.id

# #   policy = jsonencode({
# #     Version = "2012-10-17",
# #     Statement = [
# #       {
# #         Action    = "s3:GetObject",
# #         Effect    = "Allow",
# #         Resource  = "arn:aws:s3:::your-private-bucket-name/static/*",
# #         Principal = {
# #           AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
# #         }
# #       }
# #     ]
# #   })
# # }

# # resource "aws_cloudfront_origin_access_identity" "oai" {
# #   comment = "Access for CloudFront to S3 bucket"
# # }

# # resource "aws_cloudfront_distribution" "cdn" {
# #   origin {
# #     domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
# #     origin_id   = "S3-static-origin"

# #     s3_origin_config {
# #       origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
# #     }
# #   }

# #   enabled             = true
# #   is_ipv6_enabled     = true
# #   default_root_object = "index.html"

# #   default_cache_behavior {
# #     allowed_methods  = ["GET", "HEAD"]
# #     cached_methods   = ["GET", "HEAD"]
# #     target_origin_id = "S3-static-origin"

# #     forwarded_values {
# #       query_string = false
# #       cookies {
# #         forward = "none"
# #       }
# #     }

# #     viewer_protocol_policy = "redirect-to-https"
# #   }

# #   restrictions {
# #     geo_restriction {
# #       restriction_type = "none"
# #     }
# #   }

# #   viewer_certificate {
# #     cloudfront_default_certificate = true
# #   }
# # }
# # locals {
# #   s3_bucket_name = ""
# #   domain         = ""
# #   hosted_zone_id = ""
# #   cert_arn       = ""
# # }

# # resource "aws_s3_bucket" "main" {
# #   bucket = local.s3_bucket_name
# # }


# # resource "aws_cloudfront_distribution" "main" {
# #   aliases             = [local.domain]
# #   default_root_object = "index.html"
# #   enabled             = true
# #   is_ipv6_enabled     = true
# #   wait_for_deployment = true

# #   default_cache_behavior {
# #     allowed_methods        = ["GET", "HEAD", "OPTIONS"]
# #     cached_methods         = ["GET", "HEAD", "OPTIONS"]
# #     cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
# #     target_origin_id       = aws_s3_bucket.main.bucket
# #     viewer_protocol_policy = "redirect-to-https"
# #   }

# #   origin {
# #     domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
# #     origin_access_control_id = aws_cloudfront_origin_access_control.main.id
# #     origin_id                = aws_s3_bucket.main.bucket
# #   }

# #   restrictions {
# #     geo_restriction {
# #       restriction_type = "none"
# #     }
# #   }

# #   viewer_certificate {
# #     acm_certificate_arn      = local.cert_arn
# #     minimum_protocol_version = "TLSv1.2_2021"
# #     ssl_support_method       = "sni-only"
# #   }
# # }

# # resource "aws_cloudfront_origin_access_control" "main" {
# #   name                              = "s3-cloudfront-oac"
# #   origin_access_control_origin_type = "s3"
# #   signing_behavior                  = "always"
# #   signing_protocol                  = "sigv4"
# # }

# # data "aws_iam_policy_document" "cloudfront_oac_access" {
# #   statement {
# #     principals {
# #       type        = "Service"
# #       identifiers = ["cloudfront.amazonaws.com"]
# #     }

# #     actions = [
# #       "s3:GetObject"
# #     ]

# #     resources = ["${aws_s3_bucket.main.arn}/*"]

# #     condition {
# #       test     = "StringEquals"
# #       variable = "AWS:SourceArn"
# #       values   = [aws_cloudfront_distribution.main.arn]
# #     }
# #   }
# # }

# # resource "aws_s3_bucket_policy" "main" {
# #   bucket = aws_s3_bucket.main.id
# #   policy = data.aws_iam_policy_document.cloudfront_oac_access.json
# # }


# # Obtener el ID de la cuenta AWS
# data "aws_caller_identity" "current" {}

# # Crear un bucket de S3 para la página web
# resource "aws_s3_bucket" "static_website_bucket" {
#   bucket = "birdsbogota-static-website-34"

#   tags = {
#     Name        = "BirdsBogotaStaticWebsite"
#     Environment = "Production"
#   }
# }

# # Configurar el bucket para servir una página web estática
# resource "aws_s3_bucket_website_configuration" "website_config" {
#   bucket = aws_s3_bucket.static_website_bucket.bucket

#   index_document {
#     suffix = "index.html"
#   }
# }

# resource "aws_s3_object" "static_files_test_cdn" {
#   bucket = aws_s3_bucket.static_website_bucket.bucket
#   key    = "index.html"                     # S3 key, the file path in S3
#   source = "index.html"  # The local file to upload
# }

# # Política del bucket para permitir acceso solo a través de CloudFront
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.static_website_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           "Service": "cloudfront.amazonaws.com"
#         },
#         Action = "s3:GetObject",
#         Resource = "${aws_s3_bucket.static_website_bucket.arn}/*",
#         # Condition = {
#         #   StringEquals = {
#         #     "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cdn.id}"
#         #   }
#         # }
#       }
#     ]
#   })
# }

# # Crear la distribución de CloudFront para servir el contenido del bucket de S3
# resource "aws_cloudfront_distribution" "cdn" {
#   origin {
#     domain_name = aws_s3_bucket.static_website_bucket.bucket_regional_domain_name
#     origin_id   = "S3-birdsbogota-origin"
#   }

#   enabled = true

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "S3-birdsbogota-origin"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#   }

#   # Añadir el bloque de restricciones (sin restricciones geográficas)
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   # Usar el certificado predeterminado de CloudFront
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   # Optimización de costos: distribución limitada a regiones populares
#   price_class = "PriceClass_200"

#   # Establecer el objeto raíz predeterminado
#   default_root_object = "index.html"

#   tags = {
#     Name        = "BirdsBogotaCloudFrontDistribution"
#     Environment = "Production"
#   }
# }

# # Output para obtener la URL de CloudFront
# output "cloudfront_domain_name" {
#   value       = aws_cloudfront_distribution.cdn.domain_name
#   description = "La URL de CloudFront para acceder al contenido."
# }


