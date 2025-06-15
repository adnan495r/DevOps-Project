# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get list of subnets in the default VPC

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

# Public Subnets (ASG instances will be launched here(3 AZs))
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1" 
           Type = "public"
         }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-2" 
           Type = "public" 
		 }
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-3" 
           Type = "public"
         }
}




# Private subnets (3 AZs for RDS)
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false
  tags = { Name = "private-subnet-1" 
           Type = "private"
         }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false
  tags = { Name = "private-subnet-2" 
           Type = "private"
         }
}

resource "aws_subnet" "private_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.13.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false
  tags = { Name = "private-subnet-3"
           Type = "private"
         }
}

resource "aws_subnet" "private_metabase" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.14.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false
  tags = { Name = "private-subnet-metabase"
           Type = "private"
         }
}


resource "aws_subnet" "public_metabase" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-metabase"
           Type = "public"
         }
}


# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "public-rt" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "public_metabase" {
  subnet_id      = aws_subnet.public_metabase.id
  route_table_id = aws_route_table.public_rt.id
}