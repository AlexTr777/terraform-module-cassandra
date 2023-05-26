################################################################################
#                            CASSANDRA MODULE                                  #
################################################################################
module "cassandra" {
  source = "../../"

  # Cassandra cluster configuration
  cassandra_cluster = {
    cluster_name = "cassandra-c1"
    instances = {
      seed = {
        n1 = {
          subnet_id = "subnet-00f5afd694820dfs3"
          ebs_block_device  = [{
            delete_on_termination = true
            device_name = "/dev/sdf"
            encrypted   = false
            volume_type = "gp3"
            throughput  = 200
            volume_size = 100
        }]
        }
      }
      data = {
        n1 = {
          subnet_id = "subnet-00f5afd694820fsd8"
          ebs_block_device  = [{
            delete_on_termination = true
            device_name = "/dev/sdf"
            encrypted   = false
            volume_type = "gp3"
            throughput  = 200
            volume_size = 100
        }]
        }
        n2 = {
          subnet_id = "subnet-00f5afd694820fvd9"
          ebs_block_device  = [{
            delete_on_termination = true
            device_name = "/dev/sdf"
            encrypted   = false
            volume_type = "gp3"
            throughput  = 200
            volume_size = 100
        }]
        }
      }
    }
  }

  # Launch template configuration
  launch_template = {
    instance_type = "t3.large"
  }

  # Provisioners
  # Only one launch provisioner can be enabled. Also, after applying of configuration, both of them have to be disabled. Node IP required for provisioning dedicated node of the cluster.
  # !!!!!! If it's your first cluster deploy: first terraform apply has to be with enable_cluster_provisioner = false , in order to deploy EC2 instance. Second terraform apply enable_cluster_provisioner = true in order to apply config and run cassandra service. 3d terraform apply has to be enable_cluster_provisioner = false in order to remove provisioner.
  enable_cluster_provisioner                = false
  enable_dedicated_node_provisioner         = false
  dedicated_node_provisioner_private_ip     = [""]
  
  # DNS settings
  cluster_dns_endpoint_enabled = true    
  
  # Node exporter version to setup
  node_exporter_version = "1.3.1"
  
  # Security and networking
  route53_dns_zone_id       = "Z09339776T6SD9LJXFW2"
  vpc_security_group_ids    = [aws_security_group.cassandra_cluster.id]
  ssh_key_name              = aws_key_pair.ec2_key.key_name
  ssh_private_key           = tls_private_key.rsa.private_key_pem
}
