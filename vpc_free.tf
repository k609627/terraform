provider "aws" {
  region="ap-south-1"
  access_key ="XXXXXXXXXXXXXXXXXXXXXXXXXX"
  secret_key ="XXXXXXXXXXXXXXXXX"
}

resource "aws_vpc" "giones"{
  cidr_block = "192.168.1.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "mial"
  }
}

resource "aws_subnet" "mnjp" {
  cidr_block       = "192.168.1.0/25"
  availability_zone = "ap-south-1b"
  vpc_id           = aws_vpc.giones.id
  tags = {
    Name = "mnjp_subnet"
  }
}

resource "aws_subnet" "cngp" {
  cidr_block       = "192.168.1.128/25"
  availability_zone = "ap-south-1c"
  vpc_id           = aws_vpc.giones.id
  tags = {
    Name = "cngp_subnet"
  }
}

resource "aws_security_group" "sg"{
  name = "jiokl"
  vpc_id = aws_vpc.giones.id
  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
}

resource "aws_key_pair" "genz"{
  key_name = "GENZ"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChP4FUuVkbJBss2YT/6We9VhWU/66xYc2K0BZ7gg6oIMN000AIB8E7EZINdCJPg9jbv66lZ/L+gjMBCDU3YSisKEM81HYzo6lQ5lxDkTW3kRCGtij46Nl+F4BY748Ei8rckLYaDOmigKWh6S9k+i1m/nrrIetWrQAtkNslK0aq1f6AzFiFToNrp9RfC/mPBZDAaJGnAqnSMSEPHBxXJpqiLZ4YBi/VBrM6OnnALGNjjfrx9PT3eYviZKAL6naea9/YQpQlGuQWPieSBv/dX99jMq+PxtqlbymmGkTtqR7Edq5tKxCzpR6KVCPd97sNZODjWiGKXFsDBZgVX+RbiFYv rsa-key-20230802"
}

resource "aws_instance" "vpc_instances"{
  ami = "ami-0ded8326293d3201b"
  instance_type = "t2.micro"
  key_name = aws_key_pair.genz.key_name
  subnet_id = aws_subnet.mnjp.id
  vpc_security_group_ids = [aws_security_group.sg.id]
}
  