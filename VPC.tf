provider "aws" {
    region = "eu-west-2"
}

resource "aws_vpc" "VPC1" {
    cidr_block = "12.168.0.0/24"
    tags = {
        Name = "TerraformVPC"
    }
}
