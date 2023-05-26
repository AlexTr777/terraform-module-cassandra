################################################################################
#                     NULL RESOURCE FOR CLUSTER PROVISIONING                   #
################################################################################
resource "null_resource" "cluster_provisioning" {
  for_each = var.enable_cluster_provisioner || (var.enable_dedicated_node_provisioner && length(var.dedicated_node_provisioner_private_ip) > 0) ? toset(local.provisioning_nodes_ips) : []
  
  triggers = {
    cluster_seed_ips = local.cluster_seed_ips
  }
  # Node exporter installation 
  provisioner "file" {
    content     = templatefile("${path.module}/templates/monitoring_installation.sh", {node_exporter_version = "${var.node_exporter_version}"})
    destination = "/tmp/monitoring_installation.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user_name
      private_key = var.ssh_private_key
      host        = each.value
    }
  }
  # Cassandra config generating
  provisioner "file" {
    content     = templatefile("./templates/cassandra-config.tmpl", {tf_var_cluster_name = "${var.cassandra_cluster.cluster_name}", tf_var_seed_ips = "${local.cluster_seed_ips}"})
    destination = "/tmp/cassandra.yaml"
    connection {
      type        = "ssh"
      user        = var.ssh_user_name
      private_key = var.ssh_private_key
      host        = each.value
    }
  }
  # Cluster provisioning script
  provisioner "file" {
    source      = "${path.module}/templates/cluster_provisioning.sh"
    destination = "/tmp/cluster_provisioning.sh"   
    connection {
      type        = "ssh"
      user        = var.ssh_user_name
      private_key = var.ssh_private_key
      host        = each.value
    }
  } 
  # Provisioning scripts executing
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/monitoring_installation.sh",
      "chmod +x /tmp/cluster_provisioning.sh",
      "sudo bash /tmp/monitoring_installation.sh",
      "sudo bash /tmp/cluster_provisioning.sh",
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_user_name
      private_key = var.ssh_private_key
      host        = each.value
    } 
  }
}

