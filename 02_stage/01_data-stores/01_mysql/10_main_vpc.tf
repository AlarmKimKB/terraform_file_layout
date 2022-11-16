terraform {
  backend "s3" {
    bucket = "terraform-study-tfstate"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks-files"
  }
}

provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "scott_vpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-study"
  }
}

resource "aws_subnet" "scott_subnet3" {
  vpc_id     = aws_vpc.scott_vpc.id
  cidr_block = "10.10.3.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraform-subnet3"
  }
}

resource "aws_subnet" "scott_subnet4" {
  vpc_id     = aws_vpc.scott_vpc.id
  cidr_block = "10.10.4.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "terraform-subnet4"
  }
}

resource "aws_route_table" "scott_rt2" {
  vpc_id = aws_vpc.scott_vpc.id

  tags = {
    Name = "terraform-rt2"
  }
}

resource "aws_route_table_association" "scott_rt_association3" {
  subnet_id      = aws_subnet.scott_subnet3.id
  route_table_id = aws_route_table.scott_rt2.id
}

resource "aws_route_table_association" "scott_rt_association4" {
  subnet_id      = aws_subnet.scott_subnet4.id
  route_table_id = aws_route_table.scott_rt2.id
}

resource "aws_security_group" "scott_sg2" {
  vpc_id      = aws_vpc.scott_vpc.id
  name        = "terraform SG - RDS"
  description = "terraform Study SG - RDS"
}

resource "aws_security_group_rule" "rds_sg_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.scott_sg2.id
}

resource "aws_security_group_rule" "rds_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.scott_sg2.id
}
