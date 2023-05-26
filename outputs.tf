# ################################################################################
# # Seed Nodes
# ################################################################################

output "seed_node_id" {
  description = "The ID of the instance"
  value       = try({for node, value in aws_instance.seed : node => value.id}, "")
}

output "seed_node_arn" {
  description = "The ARN of the instance"
  value       = try({for node, value in aws_instance.seed : node => value.arn}, "")
}

output "seed_node_private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = try({for node, value in aws_instance.seed : node => value.private_dns}, "")
}

output "seed_node_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = try({for node, value in aws_instance.seed : node => value.public_dns}, "")
}

output "seed_node_public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = try({for node, value in aws_instance.seed : node => value.public_ip}, "")
}

output "seed_node_private_ip" {
 description = "The private IP address assigned to the instance."
 value       = try({for node, value in aws_instance.seed : node => value.private_ip}, "")
}

output "seed_node_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = try({for node, value in aws_instance.seed : node => value.tags_all}, {})
}

output "seed_node_ami" {
  description = "AMI ID that was used to create the instance."
  value       = try({for node, value in aws_instance.seed : node => value.ami}, "")
}

# ################################################################################
# # Data Nodes 
# ################################################################################

output "data_node_id" {
  description = "The ID of the instance"
  value       = try({for node, value in aws_instance.data : node => value.id}, "")
}

output "data_node_arn" {
  description = "The ARN of the instance"
  value       = try({for node, value in aws_instance.data : node => value.arn}, "")
}

output "data_node_private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = try({for node, value in aws_instance.data : node => value.private_dns}, "")
}

output "data_node_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = try({for node, value in aws_instance.data : node => value.public_dns}, "")
}

output "data_node_public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = try({for node, value in aws_instance.data : node => value.public_ip}, "")
}

output "data_node_private_ip" {
 description = "The private IP address assigned to the instance."
 value       = try({for node, value in aws_instance.data : node => value.private_ip}, "")
}

output "data_node_ipv6_addresse" {
  description = "The IPv6 address assigned to the instance, if applicable."
  value       = try({for node, value in aws_instance.data : node => value.ipv6_addresses}, [])
}

output "data_node_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = try({for node, value in aws_instance.data : node => value.tags_all}, {})
}

output "data_node_ami" {
  description = "AMI ID that was used to create the instance."
  value       = try({for node, value in aws_instance.data : node => value.ami}, "")
}

# ################################################################################
# # Seed Nodes Block Devices
# ################################################################################

output "seed_node_root_block_device" {
  description = "Root block device information"
  value       = try({for node, value in aws_instance.seed : node => value.root_block_device}, null)
}

output "seed_node_ebs_block_device" {
  description = "EBS block device information"
  value       = try({for node, value in aws_instance.seed : node => value.ebs_block_device}, null)
}

output "seed_node_ephemeral_block_device" {
  description = "Ephemeral block device information"
  value       = try({for node, value in aws_instance.seed : node => value.ephemeral_block_device}, null)
}

################################################################################
# Data Nodes Block Devices
################################################################################
output "data_node_root_block_device" {
  description = "Root block device information"
  value       = try({for node, value in aws_instance.data : node => value.root_block_device}, null)
}

output "data_node_ebs_block_device" {
  description = "EBS block device information"
  value       = try({for node, value in aws_instance.data : node => value.ebs_block_device}, null)
}

output "data_node_ephemeral_block_device" {
  description = "Ephemeral block device information"
  value       = try({for node, value in aws_instance.data : node => value.ephemeral_block_device}, null)
}

# ################################################################################
# # Route53 endpoint
# ################################################################################

output "cluster_dns_endpoint" {
  description = "Cluster dns endpoint"
  value       = try(aws_route53_record.cluster_route53[0].fqdn, "")
}
