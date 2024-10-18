resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames =  true
  tags = {
#     Name = "${local.common_name}-vpc-act01"
    Name = "${local.common_name}-${var.var_vpc_name}"
  }
}