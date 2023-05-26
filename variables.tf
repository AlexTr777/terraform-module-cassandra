# =================== #
# Mandatory variables #
# =================== #

variable "ssh_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key which will be used for node provisioning"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "launch_template" {
  description = "Launch template settings which will be used in order to launch EC2 instance"
  type = object({
    instance_type = optional(string)
    tags = optional(map(any))
  })
}

variable "cassandra_cluster" {
  description = "Available parameters for cluster/dedicated node configuration"
  type = object({
    cluster_name = string
    instances = object({
      seed = map(object({
        instance_type = optional(string, null)
        ami_id        = optional(string, null)
        cpu_core_count = optional(number, null)
        cpu_credits    = optional(string, null)
        hibernation    = optional(string, null)
        cpu_threads_per_core = optional(number, null)
        user_data                   = optional(string, null)
        user_data_base64            = optional(string, null)
        user_data_replace_on_change = optional(bool, null)
        availability_zone      = optional(string, null)
        subnet_id              = optional(string, null)
        vpc_security_group_ids = optional(list(string), null)
        key_name             = optional(string, null)
        monitoring           = optional(bool, null)
        get_password_data    = optional(bool, null)
        associate_public_ip_address = optional(bool, null)
        private_ip                  = optional(string, null)
        secondary_private_ips       = optional(list(string), null)
        ipv6_address_count          = optional(number, null)
        ipv6_addresses              = optional(list(string), null)
        ebs_optimized = optional(bool, true)
        enable_volume_tags = optional(bool, true)
        volume_tags = optional(map(any), {})
        root_block_device = optional(list(object({
            encrypted   = optional(bool, null)
            volume_type = optional(string, null)
            throughput  = optional(number, null)
            volume_size = optional(number, null)
            delete_on_termination = optional(bool, null)
            iops        = optional(number, null)
            kms_key_id  = optional(string, null)
        })), [{
          volume_type = "gp2"
          volume_size = 75
        }])
        ebs_block_device  = list(object({
            delete_on_termination = optional(bool, null)
            device_name = optional(string, null)
            encrypted   = optional(bool, false)
            iops        = optional(number, null)
            volume_type = optional(string, null)
            throughput  = optional(number, null)
            volume_size = optional(number, null)
            kms_key_id  = optional(string, null)
            snapshot_id = optional(string, null)
        }))
        ephemeral_block_device = optional(list(object({
            device_name  = optional(string, null)
            no_device    = optional(bool, null)
            virtual_name = optional(string, null)
        })), [])
        metadata_options = optional(list(object({
            http_endpoint                = optional(bool, null)
            http_tokens                  = optional(string, null)
            http_put_response_hop_limit  = optional(number, null)
            http_truncate_headers        = optional(bool, null)
            instance_metadata_tags       = optional(map(any), {})
        })), [])
        network_interface = optional(list(object({
            device_index          = optional(number, null)
            network_interface_id  = optional(string, null)
            delete_on_termination = optional(bool, null)
            network_card_index    = optional(number, null)
        })), []) 
        maintenance_options = optional(list(object({
            auto_recovery  = optional(string, null)
        })), []) 
        enclave_options = optional(object({
            enabled  = optional(bool, null)
        }), {}) 
        credit_specification = optional(object({
            cpu_credits  = optional(number, null)
        }), {}) 
        timeouts = optional(object({
            create = optional(string, null)
            update = optional(string, null)
            delete = optional(string, null)
        }), {})  
        tags = optional(map(any), {}) 
      }))
      data = map(object({
        instance_type = optional(string, null)
        ami_id        = optional(string, null)
        cpu_core_count = optional(number, null)
        cpu_credits    = optional(string, null)
        hibernation    = optional(string, null)
        cpu_threads_per_core = optional(number, null)
        user_data                   = optional(string, null)
        user_data_base64            = optional(string, null)
        user_data_replace_on_change = optional(bool, null)
        availability_zone      = optional(string, null)
        subnet_id              = optional(string, null)
        vpc_security_group_ids = optional(list(string), null)
        key_name             = optional(string, null)
        monitoring           = optional(bool, null)
        get_password_data    = optional(bool, null)
        associate_public_ip_address = optional(bool, null)
        private_ip                  = optional(string, null)
        secondary_private_ips       = optional(list(string), null)
        ipv6_address_count          = optional(number, null)
        ipv6_addresses              = optional(list(string), null)
        ebs_optimized = optional(bool, true)
        enable_volume_tags = optional(bool, true)
        volume_tags = optional(map(string), {})
        root_block_device = optional(list(object({
            encrypted   = optional(bool, null)
            volume_type = optional(string, null)
            throughput  = optional(number, null)
            volume_size = optional(number, null)
            delete_on_termination = optional(bool, null)
            iops        = optional(number, null)
            kms_key_id  = optional(string, null)
        })), [{
          volume_type = "gp2"
          volume_size = 75
        }])
        ebs_block_device  = list(object({
            delete_on_termination = optional(bool, null)
            device_name = optional(string, null)
            encrypted   = optional(bool, false)
            iops        = optional(number, null)
            volume_type = optional(string, null)
            throughput  = optional(number, null)
            volume_size = optional(number, null)
            kms_key_id  = optional(string, null)
            snapshot_id = optional(string, null)
        }))
        ephemeral_block_device = optional(list(object({
            device_name  = optional(string, null)
            no_device    = optional(bool, null)
            virtual_name = optional(string, null)
        })), [])
        metadata_options = optional(list(object({
            http_endpoint                = optional(bool, null)
            http_tokens                  = optional(string, null)
            http_put_response_hop_limit  = optional(number, null)
            http_truncate_headers        = optional(bool, null)
            instance_metadata_tags       = optional(map(any), {})
        })), [])
        network_interface = optional(list(object({
            device_index          = optional(number, null)
            network_interface_id  = optional(string, null)
            delete_on_termination = optional(bool, null)
            network_card_index    = optional(number, null)
        })), []) 
        maintenance_options = optional(list(object({
            auto_recovery  = optional(string, null)
        })), []) 
        enclave_options = optional(object({
            enabled  = optional(bool, null)
        }), {}) 
        credit_specification = optional(object({
            cpu_credits  = optional(number, null)
        }), {}) 
        timeouts = optional(object({
            create = optional(string, null)
            update = optional(string, null)
            delete = optional(string, null)
        }), {})  
        tags = optional(map(any), {}) 
      }))
      })
  }) 
}

# ================== #
# Optional variables #
# ================== #

variable "ssh_user_name" {
  description = "User name which will be used for node provisioning through SSH. Default value was set according to cassandra AMI available user"
  type        = string
  default     = "ubuntu"
}

variable "kms_key_id" {
  description = "KMS key which can be applied for all of the instances and used for encrypting EBS volume"
  type        = string
  default     = null
}

variable "node_exporter_version" {
  description = "Node Exporter version which will be installed on cluster nodes for monitoring"
  type        = string
  default     = "1.3.1"
}

variable "ebs_device_name" {
  description = "EBS device name which will be mounted to /var directory"
  type        = string
  default     = "nvme1n1"
}

variable "enable_cluster_provisioner" {
  description = "If this parameter enabled, then cassandra configuration which described in cassandra-config.tmpl file will be applied to all of the cluster node. Recommended to use for 1st cluster launch, other provisioning would be better to do through enable_dedicated_node_provisioner feature. If it would applied for production cluster with data, you must take into account that there will be downtime. Because when you are provisioning all of the cluster nodes , they will be automatically rebooted."
  type        = bool
  default     = false
}

variable "enable_dedicated_node_provisioner" {
  description = "If this parameter enabled, then cassandra configuration which described in cassandra-config.tmpl file will be applied to the one dedicated node specified in \"dedicated_node_provisioner_private_ip variable\". Can be used in case, when you need to add one more data or seed node. But don't forget to update configs files on other nodes manually(add new node IP to config of other earlier deployed nodes). Using this parameter it`s the best way to update config or add new nodes to the cluster, because you can control which node will be drained and rebooted, without full cluster downtime."
  type        = bool
  default     = false
}

variable "dedicated_node_provisioner_private_ip" {
  description = "If this parameter enabled, then cassandra configuration which described in cassandra-config.tmpl file will be applied to the one dedicated node specified in this variable."
  type        = tuple([string])
  default     = [""]
}

variable "cluster_dns_endpoint_enabled" {
  description = "Create Route53 record which include private IPs of all of the cluster nodes"
  type        = bool
  default     = false
}

variable "route53_dns_zone_id" {
  description = "The id of Route53 DNS zone. Should be set if cluster_dns_endpoint_enabled is enabled."
  type        = string
  default     = null
}
