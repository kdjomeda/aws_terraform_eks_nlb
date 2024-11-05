resource "aws_security_group" "forti_admin_secgroup" {
  name        = "${local.common_name}-forti-admin-secgroup"
  description = "Admin security group for managing Fortigate"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
#     cidr_blocks = ["41.155.68.45/32"]
    cidr_blocks = var.var_office_ips
    description = "ssh access through Office Ips"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Web access through Office Vodafone IP 1"
  }


  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-forti-admin-secgroup"
  }
}

resource "aws_security_group" "forti_partner_secgroup" {
  name        = "${local.common_name}-forti-partner-secgroup"
  description = "Partner security group for Fortigate VPN or accessing services"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-forti-partner-secgroup"
  }
}

resource "aws_security_group" "forti_internal_secgroup" {
  name        = "${local.common_name}-forti-internal-secgroup"
  description = "Allow all for internal use"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-forti-internal-secgroup"
  }
}

