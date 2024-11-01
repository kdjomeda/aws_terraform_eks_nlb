resource "aws_subnet" "private_zone1" {
  vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.0.0/19"
  cidr_block = var.var_private_zone1_cidr
  availability_zone = local.zone1

  tags = {
    "Name" = "${local.common_name}-private-${local.zone1}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.common_name}-${local.eks_name}" ="owned"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.32.0/19"
  cidr_block = var.var_private_zone2_cidr
  availability_zone = local.zone2

  tags = {
    "Name" = "${local.common_name}-private-${local.zone2}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.common_name}-${local.eks_name}" ="owned"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.64.0/19"
  cidr_block = var.var_public_zone1_cidr
  availability_zone = local.zone1
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${local.common_name}-public-${local.zone1}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.common_name}-${local.eks_name}" ="owned"
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.96.0/19"
  cidr_block = var.var_public_zone2_cidr
  availability_zone = local.zone2
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${local.common_name}-public-${local.zone2}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.common_name}-${local.eks_name}" ="owned"
  }
}