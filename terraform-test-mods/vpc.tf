resource "aws_vpc" "my_vpc" {
  cidr_block = var.ipblock


  tags = {
    Name = "Development"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "rt" {
 vpc_id = aws_vpc.my_vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
  tags = {
      
  }
}