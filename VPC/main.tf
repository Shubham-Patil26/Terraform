resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.project
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az1 

  tags = {
    Name = "${var.project}_subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project}_InternetGateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.project}_RouteTable"
  }
}

resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}