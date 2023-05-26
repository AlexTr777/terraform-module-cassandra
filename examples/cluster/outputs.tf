################################################################################
# Cassandra endpoint
################################################################################
output "cassandra_endpoint" {
  description = "Data nodes cassandra Cluster outputs for created resources, can be used in other parts of infrastructure"
  value = module.cassandra.cluster_dns_endpoint

}

################################################################################
# Seed Nodes
################################################################################
output "cassandra_seed_node" {
  description = "Seed node cassandra cluster outputs for created resources, can be used in other parts of infrastructure"
  value = {
    id = module.cassandra.seed_node_id
    arn = module.cassandra.seed_node_arn
    private_dns = module.cassandra.seed_node_private_dns
    public_dns = module.cassandra.seed_node_public_dns
    public_ip = module.cassandra.seed_node_public_ip
    private_ip = module.cassandra.seed_node_private_ip
    tags_all = module.cassandra.seed_node_tags_all
    ami = module.cassandra.seed_node_ami
  }
}

################################################################################
# Data Nodes
################################################################################
output "cassandra_data_node" {
  description = "Data nodes cassandra cluster outputs for created resources, can be used in other parts of infrastructure"
  value = {
    id = module.cassandra.data_node_id
    arn = module.cassandra.data_node_arn
    private_dns = module.cassandra.data_node_private_dns
    public_dns = module.cassandra.data_node_public_dns
    public_ip = module.cassandra.data_node_public_ip
    private_ip = module.cassandra.data_node_private_ip
    tags_all = module.cassandra.data_node_tags_all
    ami = module.cassandra.data_node_ami
  }
}

################################################################################
# SSH key pair
################################################################################

output "ssh_key_pair_info" {
  description = "Data nodes cassandra Cluster outputs for created resources, can be used in other parts of infrastructure"
  value = {
    pair_name = aws_key_pair.ec2_key.key_name
    pair_id = aws_key_pair.ec2_key.key_pair_id
  }
}

# for print private key run command "terraform output -raw private_key" locally
output "ssh_private_key" {
  value     = tls_private_key.rsa.private_key_pem
  sensitive = true
}