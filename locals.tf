# ====== #
# Locals #
# ====== #
locals {
    cluster_seed_ips = join(",", (values(aws_instance.seed)[*].private_ip))
    cluster_nodes_ips = concat(values(aws_instance.seed)[*].private_ip, values(aws_instance.data)[*].private_ip)
    provisioning_nodes_ips = var.enable_dedicated_node_provisioner && length(var.dedicated_node_provisioner_private_ip) > 0 ? var.dedicated_node_provisioner_private_ip  : local.cluster_nodes_ips
}