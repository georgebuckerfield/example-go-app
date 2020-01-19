locals {
  app_origin_id = var.app_service_name
  s3_origin_id = "s3-${var.app_service_name}"
}

resource "aws_cloudfront_distribution" "app" {
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id = local.app_origin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = aws_s3_bucket.images.bucket_regional_domain_name
    origin_id = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  aliases = [var.app_dns_name]
  enabled = true
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.app_origin_id

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["Host"]
    }
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    path_pattern = "/images/*"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
     acm_certificate_arn = var.cdn_acm_cert_id
     minimum_protocol_version = "TLSv1.2_2018"
     ssl_support_method = "sni-only"
  }
  depends_on = [
    aws_ecs_service.goapp
  ]
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "${var.app_service_name} S3 bucket access"
}
