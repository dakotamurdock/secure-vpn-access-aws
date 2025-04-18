# Create an S3 bucket called "network"
resource "aws_s3_bucket" "network" {
  bucket            = var.bucket_name
  force_destroy     = true

  tags = {
    Environment = var.environment
  }
  
}

# Upload the index.html network test page to the bucket
resource "aws_s3_object" "index" {
  bucket = "${var.bucket_name}"
  key    = "index.html"
  content_type = "text/html"
  source = "${var.test_objects_src}/index.html"
  etag = filemd5("${var.test_objects_src}/index.html")

  depends_on = [ aws_s3_bucket.network ]
}

# Upload the logo.jpg network test logo to the bucket
resource "aws_s3_object" "logo" {
  bucket = "${var.bucket_name}"
  key    = "logo.jpg"
  source = "${var.test_objects_src}/logo.jpg"
  etag = filemd5("${var.test_objects_src}/logo.jpg")

  depends_on = [ aws_s3_bucket.network ]
}

# Use a bucket policy to restrict access to the bucket to only come through the configured VPCe
resource "aws_s3_bucket_policy" "network" {
  bucket = aws_s3_bucket.network.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "VPCERestrictedAccess",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [
          "${aws_s3_bucket.network.arn}",  # bucket
          "${aws_s3_bucket.network.arn}/*"  # all bucket contents
        ],
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = "${var.s3_vpce_id}"  # explicit allow of requests coming from the VPC endpoint
          }
        }
      }
    ]
  })

  depends_on = [ aws_s3_object.index, aws_s3_object.logo ]
}

# Configure S3 bucket for stating web hosting
resource "aws_s3_bucket_website_configuration" "network-test" {
  bucket = aws_s3_bucket.network.id

  index_document {
    suffix = "index.html"
  }
}

# Block all public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "network-public-access-block" {
  bucket = aws_s3_bucket.network.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}
