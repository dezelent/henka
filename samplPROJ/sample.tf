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



resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


}


resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-dzlntvpc-"
  image_id      = "ami-55ef662f"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.dezelent.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main_asg" {
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  name                 = "terraform-asg-dzlntvpc"
  min_size             = 0
  max_size             = 2
  availability_zones = ["us-east-1a","us-east-1b"]
  desired_capacity = 0
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_key_pair" "dezelent" {
  key_name = "dzlntkey-pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcAsohA/UfDMNc2DDABqdGZxy50jFhpCAEbTSYSwym5+PAIaB01f1mPBkwqTkwZJeWbdtEuFiwa7SAlIJtEORzIuHcnlHDp+UXCbR9nGAgS84XWOKFNdEHQlOuCVNUR054cYCJqN/b50bEQUiNy7LMPzo0DLstdHGjlqIiEw8aoNhWBl0DVCVjx+ghP6sjTtzHIrJ8UACBYp4pYMTQtyTqIP2uB281GPguzr+4QTBmn2gPUh94LYWUnc+lYuS3fiWQ2U8PPKUFD85LSPiOzVrvhChQXaj0ZQ1TfxbcUnwcjO1e4KzYWhBJZ+MLjWKmcnmGkTSdOT1y9E0EEljn+zT1 key@humgat.org"
}