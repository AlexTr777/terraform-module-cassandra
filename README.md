# Cassandra module

![Cassandra](./assets/images/apache-cassandra.png)

This directory contains a module to provision Cassandra cluster in AWS account on EC2 instances , using terraform provisioners. Configuration management don't require any configuration system as Ansible,etc. 

Cassandra module has dependency on public AMI in AWS MARKETPLACE. AMI product id:5789e359-f513-4969-980c-38a720041130 , Cassandra on Ubuntu 22.04 with support by Hanwei. Without this dependecie module wouldn't efficient. Dependency configured as data source.



# Important:
- ***FIRST APPLY SHOULD BE WITH DISABLED PROVISIONER (ONLY EC2 INSTANCES WILL BE DEPLOYED)***
<pre>enable_cluster_provisioner                = false<br>
enable_dedicated_node_provisioner         = false<br>
dedicated_node_provisioner_private_ip     = [""]</pre>

- ***AFTER SUCCESSFUL CLUSTER CONFIGURATION DON'T FORGET TO DISABLE PROVISIONERS (SET enable_cluster_provisioner = false AND APPLY IT.)***

- ***AFTER CLUSTER CONFIGURATION WHEN IT IS IN PRODUCTION ENVIRONMENT WITH PRODUCTION DATA, BE CAREFUL WITH "enable_cluster_provisioner = true". EVERY TIME YOU ENABLING AND APPLYING THIS PARAMETER WILL LEAD TO  NODES SYNCHRONOUS RESTART AND CLUSTER DOWNTIME***

- ***BASIC SETUP CONSIST OF 1 SEED NODE AND 2 DATA NODES. FOR EXAMPLE YOU WANT TO SETUP 3 SEED / 6 DATA. THE BEST WAY TO DO IT, IT'S TO DEPLOY BASIC SETUP AND THEN TO INCREASE CLUSTER SIZE NODE BY NODE USING "enable_cluster_provisioner=true". IT MEANS , THAT YOU HAVE TO ADD 1 SEED ,AFTER THAT ENABLE PROVISIONER, AFTER THAT DISABLE PROVISIONER. AND AGAIN ADD 1 SEED/DATA NODE -> ENABLE PROVISIONER -> DISABLE PROVISIONER, AND SO ON TO THE COUNT OF SEED AND DATA YOU NEED. YOU HAVE TO DO IT IN THIS WAY , BECAUSE IF YOU WILL DEPLOY A LOT OF DATA NODES, AS A RESULT, YOU MAY RECEIVE AN ERROR RELATED TO TOKENS:*** ```Nodes /10.47.226.147:7000 and /10.47.225.10:7000 have the same token 994207874086407945. Ignoring /10.47.226.147:7000``` 

- ***EBS_BLOCK_DEVICE IS REQUIRED. /VAR DIRECTORY WILL BE AUTOMATICALLY MOUNTED TO YOUR DEDICATED EBS DEVICE IN ORDER TO KEEP CASSANDRA DATA ON SEPARATE EBS VOLUME AND HAVE ABILITY TO GET ACCESS TO DATA IF EC2 INSTANCE WILL BE UNAVAILABLE***

- ***DO NOT REMOVE /etc/cassandra/cassandra-default.yaml. IT WOULD BE CREATED AFTER FIRST CLUSTER PROVISIONING. PROVISIONER WILL BE USING THIS FILE LIKE IDENTIFIER OF PREVIOUS PROVISIONING. IF YOU WILL REMOVE /etc/cassandra/cassandra-default.yaml, PROVISIONER WOULDN'T DETECT THAT THIS NODE HAVE BEEN ALREADY PROVISIONED. AND HARD STOP OF THE NODE WOULD BE MADE AND ALL OF THE DATA WOULD BE REMOVED FROM THE NODE.***

# Installation guide

**STAGE 1:**
On the first STAGE we have to deploy EC2 instances only (without any cassandra configuration). Cassandra would be installed too because module contains proper AMI with Cassandra.
First terraform apply should be with the following provisioners inputs:

<pre>enable_cluster_provisioner                = false<br>
enable_dedicated_node_provisioner         = false<br>
dedicated_node_provisioner_private_ip     = [""]</pre>

**STAGE 2:**
On the second STAGE we have to apply our config for each seed and data node. Config file have to be located in ./templates/cassandra-config.tmpl.
Second terraform apply should be with the following provisioners inputs:

<pre>enable_cluster_provisioner                = true<br>
enable_dedicated_node_provisioner         = false<br>
dedicated_node_provisioner_private_ip     = [""]</pre>

**STAGE 3:**
On the 3rd STAGE you already have running cluster/single node with applied configuration. This step needed to remove provisioners from AWS account.
Third terraform apply should be with the following provisioners inputs:

<pre>enable_cluster_provisioner                = false<br>
enable_dedicated_node_provisioner         = false<br>
dedicated_node_provisioner_private_ip     = [""]</pre>

# Provisioning in production environment

If you need to add nodes to the cluster or make some changes for cluster configuration you can use enable_dedicated_node_provisioner ; dedicated_node_provisioner_private_ip parameters. If you enable enable_dedicated_node_provisioner you have to set the value (private IP of the provisioning node) for dedicated_node_provisioner_private_ip parameter.
In this case only 1 node of the cluster will be drained and restarted. After node restart it will be automatically returned into the cluster. It's a very useful feature for production cluster provisioning without downtime.


# Useful links

**Confluence cassandra documentation**
https://confluence.pm.tech/display/PLATFORM/Apache+Cassandra

**Cassandra documentation**
https://cassandra.apache.org/doc/latest/cassandra/getting_started/configuring.html


# Cassandra commands
<pre>cqlsh {host_ip} 9042</pre>

<pre>CREATE KEYSPACE cycling<br>
  WITH REPLICATION = {<br>
   'class' : 'SimpleStrategy',<br> 
   'replication_factor' : 1<br> 
  };</pre>


<pre>CREATE TABLE cycling.cyclist_name (<br> 
   id UUID PRIMARY KEY,<br> 
   lastname text,<br> 
   firstname text );</pre>


<pre>INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES (5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'putin','khuylo');</pre>


<pre>SELECT lastname<br> 
FROM cycling.cyclist_name<br> 
LIMIT 50000;</pre>


## Example

Check [examples](./examples) directory for examples.

<!-- BEGIN_TF_DOCS -->
## Requirements


| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="aws_cassandra_ami"></a> [aws\_ami](#aws\_ami) | AMI product id: 5789e359-f513-4969-980c-38a720041130 , Cassandra on Ubuntu 22.04 with support by Hanwei |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [null_resource.cluster_provisioning](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.cassandra_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_launch_template.lt_cassandra_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route53_record.cluster_route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Key name of the Key Pair to use for the instance | `string` | `null` | yes |
| <a name="ssh_private_key"></a> [ssh\_key\_name](#input\_ssh\_private\_key) | Private SSH key which will be used for node provisioning | `string` | `null` | yes |
| <a name="vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `null` | yes |
| <a name="cassandra_cluster"></a> [cassandra\_cluster](#input\_cassandra\_cluster) | Available parameters for cluster/dedicated node configuration | <pre> object({<br>  cluster_name = string<br>  instances = object({<br>    seed = map(object({<br>      instance_type = string<br>      ami_id = string<br>      cpu_core_count = number<br>      cpu_credits = string<br>      hibernation = string<br>      cpu_threads_per_core = number<br>      user_data = string<br>      user_data_base64 = string<br>      user_data_replace_on_change = bool<br>      availability_zone = string<br>      subnet_id = string<br>      vpc_security_group_ids = list(string)<br>      key_name = string<br>      monitoring = bool<br>      get_password_data = bool<br>      associate_public_ip_address = bool<br>      private_ip = string<br>      secondary_private_ips = list(string)<br>      ipv6_address_count = number<br>      ipv6_addresses = list(string)<br>      ebs_optimized = bool<br>      enable_volume_tags = bool<br>      volume_tags = map(any)<br>        root_block_device = list(object({<br>        encrypted = bool<br>        volume_type = string<br>        throughput = number<br>        volume_size = number<br>        delete_on_termination = bool<br>        iops = number<br>        kms_key_id = string<br>      }))<br>      ebs_block_device = list(object({<br>        delete_on_termination = bool<br>        device_name = string<br>        encrypted = bool<br>        iops = number<br>        volume_type = string<br>        throughput = number<br>        volume_size = number<br>        kms_key_id = string<br>        snapshot_id = string<br>      }))<br>      ephemeral_block_device = list(object({<br>        device_name = string<br>        no_device = bool<br>        virtual_name = string<br>      }))<br>      metadata_options = list(object({<br>        http_endpoint = bool<br>        http_tokens = string<br>        http_put_response_hop_limit = number<br>        http_truncate_headers = bool<br>        instance_metadata_tags = map(any)<br>      }))<br>      network_interface = list(object({<br>        device_index = number<br>        network_interface_id = string<br>        delete_on_termination = bool<br>        network_card_index = number<br>      })) <br>      maintenance_options = list(object({<br>        auto_recovery = string<br>      })) <br>      enclave_options = object({<br>        enabled = bool<br>      }) <br>      credit_specification = object({<br>        cpu_credits = number<br>      }) <br>      timeouts = object({<br>        create = string<br>        update = string<br>        delete = string<br>      }) <br>      tags = map(any) <br>    }))<br>    seed = map(object({<br>      instance_type = string<br>      ami_id = string<br>      cpu_core_count = number<br>      cpu_credits = string<br>      hibernation = string<br>      cpu_threads_per_core = number<br>      user_data = string<br>      user_data_base64 = string<br>      user_data_replace_on_change = bool<br>      availability_zone = string<br>      subnet_id = string<br>      vpc_security_group_ids = list(string)<br>      key_name = string<br>      monitoring = bool<br>      get_password_data = bool<br>      associate_public_ip_address = bool<br>      private_ip = string<br>      secondary_private_ips = list(string)<br>      ipv6_address_count = number<br>      ipv6_addresses = list(string)<br>      ebs_optimized = bool<br>      enable_volume_tags = bool<br>      volume_tags = map(any)<br>        root_block_device = list(object({<br>        encrypted = bool<br>        volume_type = string<br>        throughput = number<br>        volume_size = number<br>        delete_on_termination = bool<br>        iops = number<br>        kms_key_id = string<br>      }))<br>      ebs_block_device = list(object({<br>        delete_on_termination = bool<br>        device_name = string<br>        encrypted = bool<br>        iops = number<br>        volume_type = string<br>        throughput = number<br>        volume_size = number<br>        kms_key_id = string<br>        snapshot_id = string<br>      }))<br>      ephemeral_block_device = list(object({<br>        device_name = string<br>        no_device = bool<br>        virtual_name = string<br>      }))<br>      metadata_options = list(object({<br>        http_endpoint = bool<br>        http_tokens = string<br>        http_put_response_hop_limit = number<br>        http_truncate_headers = bool<br>        instance_metadata_tags = map(any)<br>      }))<br>      network_interface = list(object({<br>        device_index = number<br>        network_interface_id = string<br>        delete_on_termination = bool<br>        network_card_index = number<br>      })) <br>      maintenance_options = list(object({<br>        auto_recovery = string<br>      })) <br>      enclave_options = object({<br>        enabled = bool<br>      }) <br>      credit_specification = object({<br>        cpu_credits = number<br>      }) <br>      timeouts = object({<br>        create = string<br>        update = string<br>        delete = string<br>      }) <br>      tags = map(any) <br>    }))<br>  })<br> })<br> </pre> | `n/a` | yes |
<a name="ebs_block_device"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | EBS block paramateres for dedicated EBS volume where cassandra data will be stored | `list(object)` | `""` | YES |
| <a name="ssh_user_name"></a> [ssh\_user\_name](#input\_ssh\_user\_name) | User name which will be used for node provisioning through SSH. Default value was set according to cassandra AMI available user | `string` | `"ubuntu"` | no |
<a name="ebs_device_name"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | EBS device name which will be used in order for mounting cassandra data folder | `string` | `""` | no |
<a name="launch_template"></a> [launch\_template](#input\_launch\_template) | Launch template settings which will be used in order to launch EC2 instance | `object` | `""` | no |
<a name="kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key which can be applied for all of the instances and used for encrypting EBS volume | `string` | `""` | no |
<a name="node_exporter_version"></a> [node\_exporter\_version](#input\_node\_exporter\_version) | Node Exporter version which will be installed on cluster nodes for monitoring | `string` | `1.3.1` | no |
<a name="enable_cluster_provisioner"></a> [enable\_cluster\_provisioner](#input\_enable\_cluster\_provisioner) | If this parameter enabled, then cassandra configuration which described in cassandra-config.tmpl file will be applied to all of the cluster node. Recommended to use for 1st cluster launch, other provisioning would be better to do through enable_dedicated_node_provisioner feature. If it would applied for production cluster with data, you must take into account that there will be downtime. Because when you are provisioning all of the cluster nodes , they will be automatically rebooted. | `bool` | `false` | no |
| <a name="enable_dedicated_node_provisioner"></a> [enable\_dedicated\_node\_first\_launch\_provisioner](#input\_enable\_dedicated\_node\_first\_launch\_provisioner) | If this parameter enabled, then cassandra configuration which described in cassandra-config.tmpl file will be applied to the one dedicated node specified in \"dedicated_node_provisioner_private_ip variable\". Can be used in case, when you need to add one more data or seed node. But don't forget to update configs files on other nodes manually. Using this parameter it`s the best way to update config or add new nodes to the cluster, because you can control which node will be drained and rebooted, without full cluster downtime. | `bool` | `false` | no |
| <a name="dedicated_node_provisioner_private_ip"></a> [dedicated\_node\_first\_launch\_provisioner\_private\_ip](#input\_dedicated\_node\_first\_launch\_provisioner\_private\_ip) | If this parameter enabled, then cassandra configuration which described in cassandra.tmpl file will be applied to the one dedicated node specified in this variable. | `tuple([string])` | `[""]` | no |
| <a name="cluster_dns_endpoint_enabled"></a> [cluster\_dns\_endpoint\_enabled](#input\_cluster\_dns\_endpoint\_enabled) | Route53 record which include private IPs of all of the cluster nodes | `bool` | `false` | no |
| <a name="route53_dns_zone_id"></a> [route53\_dns\_zone\_id](#input\_route53\_dns\_zone\_id) | The id of Route53 DNS zone. Should be set if cluster_dns_endpoint_enabled is enabled | `string` | `""` | no |




## Outputs

| Name | Description |
|------|-------------|
| <a name="cluster_dns_endpoint"></a> [cluster\_dns\_endpoint](#output\_cluster\_dns\_endpoint) | Cluster dns endpoint |
| <a name="seed_node_id"></a> [seed\_node\_id](#output\_seed\_node\_id) | The ID of the instance |
| <a name="seed_node_arn"></a> [seed\_node\_arn](#output\_seed\_node\_arn) | The ARN of the instance |
| <a name="seed_node_private_dns"></a> [seed\_node\_private\_dns](#output\_seed\_node\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="seed_node_public_dns"></a> [seed\_node\_public\_dns](#output\_seed\_node\_public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="seed_node_public_ip"></a> [seed\_node\_public\_ip](#output\_seed\_node\_public\_ip) | The public IP address assigned to the instance, if applicable |
| <a name="seed_node_private_ip"></a> [seed\_node\_private\_ip](#output\_seed\_node\_private\_ip) | The private IP address assigned to the instance |
| <a name="seed_node_tags_all"></a> [seed\_node\_tags\_all](#output\_seed\_node\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| <a name="data_node_id"></a> [data\_node\_id](#output\_data\_node\_id) | The ID of the instance |
| <a name="data_node_arn"></a> [data\_node\_arn](#output\_data\_node\_arn) | The ARN of the instance |
| <a name="data_node_private_dns"></a> [data\_node\_private\_dns](#output\_data\_node\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="data_node_public_dns"></a> [data\_node\_public\_dns](#output\_data\_node\_public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="data_node_public_ip"></a> [data\_node\_public\_ip](#output\_data\_node\_public\_ip) | The public IP address assigned to the instance, if applicable |
| <a name="data_node_private_ip"></a> [data\_node\_private\_ip](#output\_data\_node\_private\_ip) | The private IP address assigned to the instance |
| <a name="data_node_tags_all"></a> [data\_node\_tags\_all](#output\_data\_node\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| <a name="seed\_node\_root\_block\_device"></a> [seed\_node\_root\_block\_device](#output\_seed\_node\_root\_block\_device) | Root block device information |
| <a name="seed\_node\_ebs\_block\_device"></a> [seed\_node\_ebs\_block\_device](#output\_seed\_node\_ebs\_block\_device) | EBS block device information |
| <a name="seed\_node\_ephemeral\_block\_device"></a> [seed\_node\_ephemeral\_block\_device](#output\_seed\_node\_ephemeral\_block\_device) | Ephemeral block device information |
| <a name="data\_node\_root\_block\_device"></a> [data\_node\_root\_block\_device](#output\_data\_node\_root\_block\_device) | Root block device information |
| <a name="data\_node\_ebs\_block\_device"></a> [data\_node\_ebs\_block\_device](#output\_data\_node\_ebs\_block\_device) | EBS block device information |
| <a name="data\_node\_ephemeral\_block\_device"></a> [data\_node\_ephemeral\_block\_device](#output\_data\_node\_ephemeral\_block\_device) | Ephemeral block device information |


<!-- END_TF_DOCS -->
