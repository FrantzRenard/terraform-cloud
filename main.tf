# create vpc
resource "aws_vpc" "my_vpc" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = {
    Name = "%your_name%-vpc"
  }
}


# create a random resource to allow shuffling of all avaialbility zones, to give room for more subnets
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available-zones.names
  result_count = var.max_subnets
}

# create private subnets
resource "aws_subnet" "private-subnets" {
  vpc_id                  = aws_vpc.my_vpc.id
  count                   = var.private_sn_count
  cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Private-Subnet"
  }

}

# create public subnets
resource "aws_subnet" "public-subnets" {
  vpc_id                  = aws_vpc.my_vpc.id
  count                   = var.public_sn_count
  cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Public-Subnet"
  }

}