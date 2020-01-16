locals {
  app_origin_id = var.ecs_service_name
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
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
