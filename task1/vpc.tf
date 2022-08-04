# Create VPC 
resource "aws_vpc" "projectname_vpc" {
  cidr_block           = var.cidr_blocks[0]
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name        = "${var.projectName}-vpc"
  }
}

# Create Internet Gateways and attached to VPC.
resource "aws_internet_gateway" "projectname_ig" {
  vpc_id = aws_vpc.projectname_vpc.id

  tags = {
    Name        = "${var.projectName}-igw"
  }
}

# Create public subnet-1 
resource "aws_subnet" "projectname_pub_sub_1" {
  vpc_id            = aws_vpc.projectname_vpc.id 
  availability_zone = var.availablity_zones[0]
  cidr_block        = var.cidr_blocks[1]

  tags = {
    Name        = "${var.projectName}-pub-sub1"
  }
}

# Create public subnet-2
resource "aws_subnet" "projectname_pub_sub_2" {
  vpc_id            = aws_vpc.projectname_vpc.id
  availability_zone = var.availablity_zones[1]
  cidr_block        = var.cidr_blocks[2]

  tags = {
    Name        = "${var.projectName}-pub-sub2"
  }
}

# Create private subnet-1
resource "aws_subnet" "projectname_pri_sub_1" {
  vpc_id            = aws_vpc.projectname_vpc.id
  availability_zone = var.availablity_zones[0]
  cidr_block        = var.cidr_blocks[3]

  tags = {
    Name        = "${var.projectName}-pri-sub1"
  }
}

# Create private subnet-2
resource "aws_subnet" "projectname_pri_sub_2" {
  vpc_id            = aws_vpc.projectname_vpc.id
  availability_zone = var.availablity_zones[1]
  cidr_block        = var.cidr_blocks[4]

  tags = {
    Name        = "${var.projectName}-pri-sub2"
  }
}

# Subnet association between a route table and a subnet1
resource "aws_route_table_association" "projectname_pri_sub_a" {
  subnet_id      = aws_subnet.projectname_pri_sub_1.id
  route_table_id = aws_route_table.projectname_private_rt.id
}

# Subnet association between a route table and a subnet2
resource "aws_route_table_association" "projectname_pri_sub_b" {
  subnet_id      = aws_subnet.projectname_pri_sub_2.id
  route_table_id = aws_route_table.projectname_private_rt.id
}

# Subnet association between a route table and a subnet1
resource "aws_route_table_association" "projectname_pub_sub_a" {
  subnet_id      = aws_subnet.projectname_pub_sub_1.id
  route_table_id = aws_default_route_table.projectname_default_rt.id
}

# Subnet association between a route table and a subnet2
resource "aws_route_table_association" "projectname_pub_sub_b" {
  subnet_id      = aws_subnet.projectname_pub_sub_2.id
  route_table_id = aws_default_route_table.projectname_default_rt.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "projectname_elastic-ip" {
  vpc                       = true
  associate_with_private_ip = var.elastic-private-ip-range

  tags = {
    Name        = "${var.projectName}-ngw-elastic-ip"
    Description = "Elastic IP for NAT Gateway"
  }
}
