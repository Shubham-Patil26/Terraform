provider "aws" {
   region = "ap-south-1" 
 }

#Create vpc
resource "aws_vpc" "my_vpc" {
  cidr = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#Create private_subnet
resource "aws_subnet" "private_subnet"{
vpc_id = aws_vpc.my_vpc.id
cidr_block = "10.0.0.0/20"
availability_zone = "ap-south-1a"
}

#Create public_subnet
resource "aws_subnet" "public_subnet"{
vpc_id =              aws_vpc.my_vpc.id
cidr_block =          "10.0.15.0/20"
availability_zone =   "ap-south-1a"
}

#Create Internet Gateway
resource "aws_internet_gateway" "my_igw"{
  vpc_id = aws_vpc.my_vpc.id
}

#Create route Table
resource "aws_route_table" "public_rt"{
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "10.0.15.0/24
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc"{
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security Group
resource "aws_security_group" "my_sg"{
  vpc_id = aws_vpc.my_vpc.id

  ingress {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
   }

   ingress {
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
   }

   ingress {
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic
   }

   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
   }
}

#Create Instance in Public Subnet
 resource "aws_instance" "myec2" {

   ami = "ami-0c50b6f7dc3701ddd"
   key_name = "Shubham"
   instance_type =  "t2.micro"
   vpc_security_group_ids = [ "aws_security_group.my_sg.id" ]
   tags = {
     Name = "spiderman instance"
   }
 }