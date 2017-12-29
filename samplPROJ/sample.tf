# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "dezelentbkt"

    key    = "demoterraformbackend"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "firstdemobucket" {
  bucket = "dezelent_first_demo_bucket"
  acl    = "private"

//  tags {
//  Name        = "My bucket"
//    Environment = "Dev"
//  }
}



