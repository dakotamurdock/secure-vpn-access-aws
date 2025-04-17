output "s3_website_endpoint" {
  description = "Endpoint to access the static S3 hosted website"
  value = aws_s3_bucket_website_configuration.network-test.website_endpoint
}
