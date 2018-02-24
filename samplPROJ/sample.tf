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
  enable_dns_support = true
  enable_dns_hostnames = true

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
  vpc_zone_identifier  = ["${aws_subnet.public.id}"]
availability_zones = ["us-east-1a"]
  desired_capacity = 1
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_key_pair" "dezelent" {
  key_name = "dzlntkey-pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcAsohA/UfDMNc2DDABqdGZxy50jFhpCAEbTSYSwym5+PAIaB01f1mPBkwqTkwZJeWbdtEuFiwa7SAlIJtEORzIuHcnlHDp+UXCbR9nGAgS84XWOKFNdEHQlOuCVNUR054cYCJqN/b50bEQUiNy7LMPzo0DLstdHGjlqIiEw8aoNhWBl0DVCVjx+ghP6sjTtzHIrJ8UACBYp4pYMTQtyTqIP2uB281GPguzr+4QTBmn2gPUh94LYWUnc+lYuS3fiWQ2U8PPKUFD85LSPiOzVrvhChQXaj0ZQ1TfxbcUnwcjO1e4KzYWhBJZ+MLjWKmcnmGkTSdOT1y9E0EEljn+zT1 key@humgat.org"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

