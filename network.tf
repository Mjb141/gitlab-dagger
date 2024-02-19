resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/24"
}

// Public subnet stuff
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "Public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_rt_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public, aws_subnet.public]
}

// Private subnet stuff
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.128/25"


  tags = {
    Name = "Private"
  }
}

resource "aws_eip" "ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private"
  }
}

resource "aws_route_table_association" "private_subnet_rt_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table.private, aws_subnet.private]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
