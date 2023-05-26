################################################################################
#                     CASSANDRA SEED/MASTER NODE                               #
################################################################################
resource "aws_instance" "seed" {
  for_each = var.cassandra_cluster.instances.seed

  instance_type = each.value.instance_type
  cpu_core_count       = each.value.cpu_core_count
  cpu_threads_per_core = each.value.cpu_threads_per_core
  hibernation          = each.value.hibernation
  
  user_data                   = each.value.user_data
  user_data_base64            = each.value.user_data_base64
  user_data_replace_on_change = each.value.user_data_replace_on_change

  launch_template {
    id = aws_launch_template.lt_cassandra_cluster.id
    version = "$Latest"
  }

  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids == null ? var.vpc_security_group_ids : each.value.vpc_security_group_ids

  key_name             = each.value.key_name  == null ? var.ssh_key_name : each.value.key_name
  monitoring           = each.value.monitoring
  get_password_data    = each.value.get_password_data

  associate_public_ip_address = each.value.associate_public_ip_address
  private_ip                  = each.value.private_ip
  secondary_private_ips       = each.value.secondary_private_ips
  ipv6_address_count          = each.value.ipv6_address_count
  ipv6_addresses              = each.value.ipv6_addresses
  
  ebs_optimized = each.value.ebs_optimized
  
  dynamic "root_block_device" {
    for_each = var.cassandra_cluster.instances.seed[each.key].root_block_device
    content {
      delete_on_termination = each.value.root_block_device[0].delete_on_termination
      encrypted   = each.value.root_block_device[0].encrypted
      volume_type = each.value.root_block_device[0].volume_type
      iops        = each.value.root_block_device[0].iops
      kms_key_id  = each.value.root_block_device[0].kms_key_id == null ? var.kms_key_id  : each.value.root_block_device[0].kms_key_id
      throughput  = each.value.root_block_device[0].throughput
      volume_size = each.value.root_block_device[0].volume_size
    }
  }  
  dynamic "ebs_block_device" {
    for_each = var.cassandra_cluster.instances.seed[each.key].ebs_block_device
    content {
      delete_on_termination = each.value.ebs_block_device[0].delete_on_termination
      device_name           = each.value.ebs_block_device[0].device_name
      encrypted             = each.value.ebs_block_device[0].encrypted
      iops                  = each.value.ebs_block_device[0].iops
      kms_key_id            = each.value.ebs_block_device[0].kms_key_id == null ? var.kms_key_id  : each.value.ebs_block_device[0].kms_key_id
      snapshot_id           = each.value.ebs_block_device[0].snapshot_id
      volume_size           = each.value.ebs_block_device[0].volume_size
      volume_type           = each.value.ebs_block_device[0].volume_type
      throughput            = each.value.ebs_block_device[0].throughput
    }
  }
  dynamic "ephemeral_block_device" {
    for_each = var.cassandra_cluster.instances.seed[each.key].ephemeral_block_device
    content {
      device_name  = each.value.ephemeral_block_device[0].device_name
      no_device    = each.value.ephemeral_block_device[0].no_device
      virtual_name = each.value.ephemeral_block_device[0].virtual_name
    }
  }
  dynamic "metadata_options" {
    for_each = var.cassandra_cluster.instances.seed[each.key].metadata_options
    content {
      http_endpoint               = each.value.metadata_options[0].http_endpoint
      http_tokens                 = each.value.metadata_options[0].http_tokens
      http_put_response_hop_limit = each.value.metadata_options[0].http_put_response_hop_limit
      instance_metadata_tags      = each.value.metadata_options[0].instance_metadata_tags
    }
  }
  dynamic "network_interface" {
    for_each =  var.cassandra_cluster.instances.seed[each.key].network_interface
    content {
      device_index          = each.value.network_interface[0].device_index
      network_interface_id  = each.value.network_interface[0].network_interface_id
      network_card_index    = each.value.network_interface[0].network_card_index
      delete_on_termination = each.value.network_interface[0].delete_on_termination
    }
  }
  dynamic "maintenance_options" {
    for_each = var.cassandra_cluster.instances.seed[each.key].maintenance_options
    content {
      auto_recovery = each.value.maintenance_options[0].auto_recovery
    }
  }

  enclave_options {
    enabled =  each.value.enclave_options.enabled
  }

  credit_specification {
    cpu_credits = each.value.credit_specification.cpu_credits
  }

  timeouts {
      create = each.value.timeouts.create
      update = each.value.timeouts.update
      delete = each.value.timeouts.delete
    }

  tags = merge({"Name" = "${var.cassandra_cluster.cluster_name}-seed-${each.key}"}, each.value.tags)
  volume_tags = "${each.value.enable_volume_tags}" ? merge({ "Name" = "${var.cassandra_cluster.cluster_name}-seed-${each.key}" }, "${each.value.volume_tags}") : null
}

################################################################################
#                            CASSANDRA DATA NODE                               #
################################################################################
resource "aws_instance" "data" {
  for_each = var.cassandra_cluster.instances.data

  instance_type = each.value.instance_type
  cpu_core_count       = each.value.cpu_core_count
  cpu_threads_per_core = each.value.cpu_threads_per_core
  hibernation          = each.value.hibernation
  
  user_data                   = each.value.user_data
  user_data_base64            = each.value.user_data_base64
  user_data_replace_on_change = each.value.user_data_replace_on_change

  launch_template {
    id = aws_launch_template.lt_cassandra_cluster.id
    version = "$Latest"
  }

  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids == null ? var.vpc_security_group_ids : each.value.vpc_security_group_ids

  key_name             = each.value.key_name  == null ? var.ssh_key_name : each.value.key_name
  monitoring           = each.value.monitoring
  get_password_data    = each.value.get_password_data

  associate_public_ip_address = each.value.associate_public_ip_address
  private_ip                  = each.value.private_ip
  secondary_private_ips       = each.value.secondary_private_ips
  ipv6_address_count          = each.value.ipv6_address_count
  ipv6_addresses              = each.value.ipv6_addresses
  
  ebs_optimized = each.value.ebs_optimized
  
  dynamic "root_block_device" {
    for_each = var.cassandra_cluster.instances.data[each.key].root_block_device
    content {
      delete_on_termination = each.value.root_block_device[0].delete_on_termination
      encrypted   = each.value.root_block_device[0].encrypted
      volume_type = each.value.root_block_device[0].volume_type
      iops        = each.value.root_block_device[0].iops
      kms_key_id  = each.value.ebs_block_device[0].kms_key_id == null ? var.kms_key_id  : each.value.ebs_block_device[0].kms_key_id
      throughput  = each.value.root_block_device[0].throughput
      volume_size = each.value.root_block_device[0].volume_size
    }
  }  
  dynamic "ebs_block_device" {
    for_each = var.cassandra_cluster.instances.data[each.key].ebs_block_device
    content {
      delete_on_termination = each.value.ebs_block_device[0].delete_on_termination
      device_name           = each.value.ebs_block_device[0].device_name
      encrypted             = each.value.ebs_block_device[0].encrypted
      iops                  = each.value.ebs_block_device[0].iops
      kms_key_id            = each.value.ebs_block_device[0].kms_key_id == null ? var.kms_key_id  : each.value.ebs_block_device[0].kms_key_id
      snapshot_id           = each.value.ebs_block_device[0].snapshot_id
      volume_size           = each.value.ebs_block_device[0].volume_size
      volume_type           = each.value.ebs_block_device[0].volume_type
      throughput            = each.value.ebs_block_device[0].throughput
    }
  }
  dynamic "ephemeral_block_device" {
    for_each = var.cassandra_cluster.instances.data[each.key].ephemeral_block_device
    content {
      device_name  = each.value.ephemeral_block_device[0].device_name
      no_device    = each.value.ephemeral_block_device[0].no_device
      virtual_name = each.value.ephemeral_block_device[0].virtual_name
    }
  }
  dynamic "metadata_options" {
    for_each = var.cassandra_cluster.instances.data[each.key].metadata_options
    content {
      http_endpoint               = each.value.metadata_options[0].http_endpoint
      http_tokens                 = each.value.metadata_options[0].http_tokens
      http_put_response_hop_limit = each.value.metadata_options[0].http_put_response_hop_limit
      instance_metadata_tags      = each.value.metadata_options[0].instance_metadata_tags
    }
  }
  dynamic "network_interface" {
    for_each =  var.cassandra_cluster.instances.data[each.key].network_interface
    content {
      device_index          = each.value.network_interface[0].device_index
      network_interface_id  = each.value.network_interface[0].network_interface_id
      network_card_index    = each.value.network_interface[0].network_card_index
      delete_on_termination = each.value.network_interface[0].delete_on_termination
    }
  }
  dynamic "maintenance_options" {
    for_each = var.cassandra_cluster.instances.data[each.key].maintenance_options
    content {
      auto_recovery = each.value.maintenance_options[0].auto_recovery
    }
  }

  enclave_options {
    enabled =  each.value.enclave_options.enabled
  }

  credit_specification {
    cpu_credits = each.value.credit_specification.cpu_credits
  }

  timeouts {
      create = each.value.timeouts.create
      update = each.value.timeouts.update
      delete = each.value.timeouts.delete
    }

  tags = merge({"Name" = "${var.cassandra_cluster.cluster_name}-data-${each.key}"}, each.value.tags)
  volume_tags = "${each.value.enable_volume_tags}" ? merge({ "Name" = "${var.cassandra_cluster.cluster_name}-data-${each.key}" }, "${each.value.volume_tags}") : null
}
