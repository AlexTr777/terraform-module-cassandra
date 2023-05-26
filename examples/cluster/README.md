# Cassandra cluster with 1 seed and 2 data nodes configuration example

Configuration in this directory creates Cassandra cluster which demos such capabilities:
- 1 seed node
- 2 data node

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

 
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="terraform_provider_tls"></a> [terraform\_provider\_tls](#requirement\_terraform\_provider\_tls) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cassandra"></a> [cassandra](#module\_cassandra) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.cassandra_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cassandra_cluster_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cassandra_cluster_ingress_self_internode_communication_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cassandra_cluster_ingress_self_allow_http_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cassandra_cluster_ingress_self_allow_https_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cassandra_cluster_ingress_self_allow_thrift_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cassandra_cluster_ingress_external_networks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_key_pair.ec2_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [tls_private_key.rsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |


## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="cluster_dns_endpoint"></a> [cluster\_dns\_endpoint](#output\_cluster\_dns\_endpoint) | Cluster dns endpoint |
| <a name="cassandra_seed_node.id"></a> [cassandra\_seed\_node\.id](#output\cassandra\_seed\_node\.id) | The ID of the instance |
| <a name="cassandra_seed_node.arn"></a> [cassandra\_seed\_node\.arn](#output\_cassandra\_seed\_node\.arn) | The ARN of the instance |
| <a name="cassandra_seed_node.private_dns"></a> [cassandra\_seed\_node\.private\_dns](#output\_cassandra\_seed\_node\.private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="cassandra_seed_node.public_dns"></a> [cassandra\_seed\_node\.public\_dns](#output\_cassandra\_seed\_node\.public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="cassandra_seed_node.public_ip"></a> [cassandra\_seed\_node\.public\_ip](#output\_cassandra\_seed\_node\.public\_ip) | The public IP address assigned to the instance, if applicable |
| <a name="cassandra_seed_node.private_ip"></a> [cassandra\_seed\_node\.private\_ip](#output\_cassandra\_seed\_node\.private\_ip) | The private IP address assigned to the instance |
| <a name="cassandra_seed_node.tags_all"></a> [cassandra\_seed\_node\.tags\_all](#output\_cassandra\_seed\_node\.tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| <a name="cassandra_data_node.id"></a> [cassandra\_data\_node\.id](#output\_cassandra\_data\_node\.id) | The ID of the instance |
| <a name="cassandra_data_node.arn"></a> [cassandra\_data\_node\.arn](#output\_cassandra\_data\_node\.arn) | The ARN of the instance |
| <a name="cassandra_data_node.private_dns"></a> [cassandra\_data\_node\.private\_dns](#output\_cassandra\_data\_node\.private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="cassandra_data_node.public_dns"></a> [cassandra\_data\_node\.public\_dns](#output\_cassandra\_data\_node\.public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="cassandra_data_node.public_ip"></a> [cassandra\_data\_node\.public\_ip](#output\_cassandra\_data\_node\.public\_ip) | The public IP address assigned to the instance, if applicable |
| <a name="cassandra_data_node.private_ip"></a> [cassandra\_data\_node\.private\_ip](#output\_cassandra\_data\_node\.private\_ip) | The private IP address assigned to the instance |
| <a name="cassandra_data_node.tags_all"></a> [cassandra\_data\_node\.tags\_all](#output\_cassandra\_data\_node\.tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| <a name="ssh_key_pair_info.pair_name"></a> [ssh\_key\_pair\_info\.pair\_name](#output\_ssh\_key\_pair\_info\.pair\_name) | SSH key pair name |
| <a name="ssh_key_pair_info.pair_id"></a> [ssh\_key\_pair\_info\.pair\_name](#output\_ssh\_key\_pair\_info\.pair\_name) | SSH key pair id |
| <a name="ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | SSH key private key. Can be displayed locally, otherwise would be displayed as sensitive data. For display private key run command "terraform output -raw private_key" locally |


<!-- END_TF_DOCS -->
