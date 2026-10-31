resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "${var.name}-public-subnet-1"
  }
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = [
    for zone in data.aws_availability_zones.available.names : zone
    if zone != aws_subnet.subnet_public.availability_zone
  ][0]

  tags = {
    Name = "${var.name}-public-subnet-2"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.name}-private-subnet-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = [
    for zone in data.aws_availability_zones.available.names : zone
    if zone != aws_subnet.subnet_private.availability_zone
  ][0]

  tags = {
    Name = "${var.name}-private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public.id

  tags = {
    Name = "${var.name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.subnet_private_2.id
  route_table_id = aws_route_table.private_rt.id
}