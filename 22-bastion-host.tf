# ###################### EC2 Section ###################################
# # Creating EC2 assume policy document for EC2 Role
data "aws_iam_policy_document" "ec2_assume_document" {
  version = "2012-10-17"
  statement {
    sid = "1"
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_document.json
  name = "${local.common_name}-${var.var_iam_ec2_role_name}"
  path = "/"
  tags = {
    Terraform = true
    Name = "${local.common_name}-${var.var_iam_ec2_role_name}"
    ENV = local.env
  }
}


#Creating ssm specific document to allow access to some system manager
# functionalities.
data "aws_iam_policy_document" "ec2_session_manager_ssm_document" {
  statement {
    sid = "2"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

}

# Creating policy based on the session manager document
# defined above. This is for EC2 as well
resource "aws_iam_policy" "ec2_session_manager_ssm_policy" {
  policy = data.aws_iam_policy_document.ec2_session_manager_ssm_document.json
  name = "${local.common_name}-${var.var_iam_ec2_ec2_session_manager_ssm_policy_name}"
  tags = {
    Terraform = true
    Name = "${local.common_name}-${var.var_iam_ec2_ec2_session_manager_ssm_policy_name}"
    ENV = local.env
  }
}

# Attaching session manager policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_iam_role_session_manager_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_session_manager_ssm_policy.arn
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.common_name}-${var.var_iam_ec2_profile_name}"
  role = aws_iam_role.ec2_iam_role.name
  tags = {
    Terraform = true
    Name = "${local.common_name}-${var.var_iam_ec2_profile_name}"
    ENV = local.env
  }
}


resource "aws_security_group" "bastion_host_secgroup" {
  name        = "${local.common_name}-ec2-bastion-secgroup"
  description = "Security Group for EKS NLB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #     cidr_blocks = ["41.155.68.45/32"]
    security_groups = [aws_security_group.forti_internal_secgroup.id]
    description = "Allow Access to Fortigate"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Allow access to only office IPs"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-ec2-bastion-secgroup"
    ENV = local.env
  }
}

resource "aws_instance" "ec2_instance" {
  ami = var.var_ec2instance_ami_id
  instance_type = var.var_ec2instance_instance_class
  key_name = var.var_ec2instance_ssh_key_name
  associate_public_ip_address = var.var_ec2instance_should_enable_public_ip
  subnet_id = element([aws_subnet.public_zone1.id,aws_subnet.public_zone2.id],count.index )
  private_ip = element(var.var_ec2instance_private_ips_list,count.index )
  count = var.var_ec2instance_count
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.bastion_host_secgroup.id]
  root_block_device {
    encrypted = var.var_ec2instance_should_root_block_encrypted
    tags = {
      Terraform = true
      Name = "${local.common_name}-${var.var_ec2instance_name}"
      ENV = local.env
    }
    volume_size = var.var_ec2instance_root_ebs_volume_size
    volume_type = var.var_ec2instance_root_ebs_volume_type
  }

  tags = {
    Terraform = true
    Name = "${local.common_name}-${var.var_ec2instance_name}"
    AName = "${local.common_name}-${var.var_ec2instance_name}-${element([local.zone1,local.zone2],count.index )}"
    ENV = local.env
  }
  user_data = file("${path.module}/config/cloudinit/cloud-init.sh")
}