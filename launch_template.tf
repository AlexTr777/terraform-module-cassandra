################################################################################
#                           CASSANDRA LAUNCH TEMPLATE                          #
################################################################################
resource "aws_launch_template" "lt_cassandra_cluster" {
  name = "launch-tamplate-${var.cassandra_cluster.cluster_name}"

  image_id      = data.aws_ami.cassandra_ami.image_id
  instance_type = var.launch_template.instance_type
  user_data     = base64encode(templatefile("${path.module}/templates/ebs_configuration.sh", {
    ebs_device                         = "${var.ebs_device_name}"
  }))
  tags          = var.launch_template.tags
}
