provider "aws" {
  profile = "root"
  region = "ap-southeast-2"
}

resource "aws_vpc" "derma_vpc"{
  cidr_block = "192.168.1.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "derma_vpc"
  }
}

resource "aws_subnet" "derma_subnet"{
  vpc_id = aws_vpc.derma_vpc.id
  cidr_block = "192.168.1.0/25"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "derma_subnet"
  }
}

resource "aws_subnet" "excamp"{
  vpc_id = aws_vpc.derma_vpc.id
  cidr_block = "192.168.1.128/25"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "excamp"
  }
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.derma_vpc.id
  tags = {
    Name = "derma_igw"
  }
}

resource "aws_route_table" "rtb"{
  vpc_id = aws_vpc.derma_vpc.id
  
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rtb_ass"{
  subnet_id = aws_subnet.excamp.id
  route_table_id = aws_route_table.rtb.id
}


resource "aws_security_group" "sg"{
  vpc_id = aws_vpc.derma_vpc.id
  name_prefix = "sgw"
  tags = {
    Name = "sega"
  }
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "derma_instance"{
  ami = "ami-0310483fb2b488153"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.excamp.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = "SSH"
  associate_public_ip_address = true
  tags = {
    Name = "jenks_instance"
  }
  depends_on = [aws_subnet.excamp,aws_security_group.sg]
}
