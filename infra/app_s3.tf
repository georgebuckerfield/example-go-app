resource "aws_s3_bucket" "images" {
  bucket = "${var.app_service_name}-images"
}
resource "aws_s3_bucket_policy" "cdn-access" {
  bucket = aws_s3_bucket.images.id
  policy = data.aws_iam_policy_document.img_bucket_policy.json
}
data "aws_iam_policy_document" "img_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.images.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.oai.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.app_service_name}-alb-logs"
}
resource "aws_s3_bucket_policy" "alb_logging" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = data.aws_iam_policy_document.log_bucket_policy.json
}
data "aws_iam_policy_document" "log_bucket_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.alb_logging_accounts[var.region]}:root"]
    }
  }
}
