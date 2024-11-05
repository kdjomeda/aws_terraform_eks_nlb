resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
#     Name= "${local.common_name}-${local.region_name}-${local.env}-igw"
    Name= "${local.common_name}-${var.var_igw_name}"
  }
}