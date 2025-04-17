variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "test_objects_src" {
  description = "Local path containing test objects to upload to the bucket"
  type        = string
}

variable "s3_vpce_id" {
  description = "The ID of the S3 VPC Endpoint from the network module"
  type        = string
}
