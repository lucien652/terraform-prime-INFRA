resource "aws_vpc" "prime-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "prime-vpc"
  }
}

#creation of igw
resource "aws_internet_gateway" "prime-igw" {
  vpc_id = aws_vpc.prime-vpc.id

  tags = {
    Name = "prime-igw"
  }
}

#creation of pub-subnet
resource "aws_subnet" "subnet-pub" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1a"
}

#creating private-subnet1
resource "aws_subnet" "subnet-priv" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

#creating private-subnet2
resource "aws_subnet" "subnet-priv2" {
  vpc_id     = aws_vpc.prime-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

#creating a private rout
resource "aws_route_table" "priv-rout" {
  vpc_id = aws_vpc.prime-vpc.id

  route = []

  tags = {
    Name = "priv-rout"
  }
}

#creation of public rout
resource "aws_route_table" "pub-rout" {
  vpc_id = aws_vpc.prime-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prime-igw.id
  }
}

#rout table association
resource "aws_route_table_association" "priv-rout-association" {
  subnet_id      = aws_subnet.subnet-priv.id
  route_table_id = aws_route_table.priv-rout.id
}
#rout table association
resource "aws_route_table_association" "priv-rout-association2" {
  subnet_id      = aws_subnet.subnet-priv2.id
  route_table_id = aws_route_table.priv-rout.id
}
#associate rout table
resource "aws_route_table_association" "pub-rout-association" {
  subnet_id      = aws_subnet.subnet-pub.id
  route_table_id = aws_route_table.pub-rout.id
}

