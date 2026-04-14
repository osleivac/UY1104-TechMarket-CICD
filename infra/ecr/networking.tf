# =============================================================
# INFRAESTRUCTURA: VPC y Networking para ECS
# =============================================================

resource "aws_vpc" "techmarket" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "techmarket-vpc"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.techmarket.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name      = "techmarket-public-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "techmarket" {
  vpc_id = aws_vpc.techmarket.id

  tags = {
    Name      = "techmarket-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.techmarket.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techmarket.id
  }

  tags = {
    Name      = "techmarket-public-rt"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs" {
  name        = "techmarket-ecs-sg"
  description = "Security group para ECS TechMarket"
  vpc_id      = aws_vpc.techmarket.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "techmarket-ecs-sg"
    ManagedBy = "Terraform"
  }
}
