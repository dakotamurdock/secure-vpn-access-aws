provider "aws" {
  region = "us-east-1"
}

# Variables to pass to the storage module
module "storage" {
  source               = "../../../modules/storage"
  environment          = "qa"
  bucket_name          = "dev-network-test"
  test_objects_src     = "/Users/dakotamurdock/Documents/Vanderbilt/CS5383-Networks/Project/course-project/03 - application/test-files"
  s3_vpce_id           = data.terraform_remote_state.network.outputs.s3_vpce_id
}
