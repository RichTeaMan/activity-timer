resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "activity-timer-frontend"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_policy     = false
  block_public_acls       = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          "${aws_s3_bucket.frontend_bucket.arn}",
          "${aws_s3_bucket.frontend_bucket.arn}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket]
}

resource "aws_s3_bucket_website_configuration" "frontend_website_configuration" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
}

locals {
  s3_origin_id = "aws_s3_origin_id"
}

#resource "aws_cloudfront_origin_access_control" "default" {
#  name                              = "example"
#  description                       = "Example Policy"
#  origin_access_control_origin_type = "s3"
#  signing_behavior                  = "always"
#  signing_protocol                  = "sigv4"
#}

resource "aws_cloudfront_distribution" "frontend_distribution" {
  depends_on = [aws_s3_bucket_website_configuration.frontend_website_configuration]
  origin {
    domain_name = aws_s3_bucket_website_configuration.frontend_website_configuration.website_endpoint
    #origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id = local.s3_origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

}