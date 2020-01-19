output "cloudfront_dns" {
  value = aws_cloudfront_distribution.app.domain_name
}
