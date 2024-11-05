output "output_vpc_id" {
  value = aws_vpc.main.id
}

output "output_security_group_nlb_id" {
  value = aws_security_group.aws_eks_nlb_secgroup.id
}
output "output_security_group_nlb_name" {
  value = aws_security_group.aws_eks_nlb_secgroup.name
}

# output "output_vpc_private_subnets" {
#   value = [aws_subnet.private_zone1,aws_subnet.private_zone2]
# }
#
# output "output_vpc_public_subnets" {
#   value = [aws_subnet.public_zone1,aws_subnet.public_zone2]
# }

# output "output_vpc_subnets" {
#   value = [
#     aws_subnet.public_zone1,
#     aws_subnet.public_zone2,
#     aws_subnet.private_zone1,
#     aws_subnet.private_zone2
#   ]
# }

output "output_vpc_private_subnets_ids" {
  value = [aws_subnet.private_zone1.id,aws_subnet.private_zone2.id]
}

output "output_vpc_public_subnets_ids" {
  value = [aws_subnet.public_zone1.id,aws_subnet.public_zone2.id]
}

output "output_vpc_subnets_ids" {
  value = [
    aws_subnet.public_zone1.id,
    aws_subnet.public_zone2.id,
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]
}

output "output_secgroup_bastion_host_id" {
  value = aws_security_group.bastion_host_secgroup.id
}

output "output_secgroup_forti_internal_id" {
  value = aws_security_group.forti_internal_secgroup.id
}