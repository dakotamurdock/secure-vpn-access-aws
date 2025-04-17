output "bucket_website_url" {
  description = "The URL for the S3 hosted static website"
  value       = "http://${module.storage.s3_website_endpoint}/index.html"
}
