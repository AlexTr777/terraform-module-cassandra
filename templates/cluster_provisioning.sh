#!/bin/bash
set -xue -o pipefail

# Create log function using to create a script log file
function create_logfile() {
    local logfile_path="${1}"
    if [ -f "${logfile_path}" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Log file already exists. Path: ${logfile_path}" >> "${logfile_path}"
    else
        touch "${logfile_path}"
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Log file was created. Path: ${logfile_path}" >> "${logfile_path}"
    fi
}
# Node drain function using to remove node from the cluster without data loss
function node_drain() {
    local logfile_path="${1}"
    local cassandra_default_config_path="${2}"
    if [ -f "${cassandra_default_config_path}" ]; then
        nodetool drain
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Node draining was started" >> "${logfile_path}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Node draining was skipped" >> "${logfile_path}"
    fi
}
# Delay in order to wait for something , as node restart.
function delay() {
    local logfile_path="${1}"
    local cassandra_default_config_path="${2}"
    if [ -f "${cassandra_default_config_path}" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Sleeping for 60 seconds" >> "${logfile_path}"
        sleep 60
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Sleeping was skipped" >> "${logfile_path}"
    fi
}
# This function using to stop cassandra cluster
function stop_cassandra() {
    local logfile_path="${1}"
        systemctl stop cassandra
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Cassandra was stopped" >> "${logfile_path}"
}
# This function using to start cassandra cluster
function start_cassandra() {
    local logfile_path="${1}"
        systemctl start cassandra;
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Cassandra was started" >> "${logfile_path}"
}
# This function using to restart cassandra cluster
function restart_cassandra() {
    local logfile_path="${1}"
        systemctl restart cassandra;
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Cassandra was restarted" >> "${logfile_path}"
}
# This function using to delete previous cassandra cache and data files before full cluster configuration.
function first_boot_configuration() {
    local logfile_path="${1}"
    local cassandra_default_config_path="${2}"
    if [ -f "${cassandra_default_config_path}" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Removing of the folders in /var/lib/cassandra was skipped" >> "${logfile_path}"
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Default config backup was skipped" >> "${logfile_path}"
    else
        rm -rf /var/lib/cassandra/*;
        echo "$(date +'%Y-%m-%d %H:%M:%S'): /var/lib/cassandra was removed" >> "${logfile_path}"
        mv /etc/cassandra/cassandra.yaml "${cassandra_default_config_path}"
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Default config backup was created" >> "${logfile_path}"
    fi
}
# This function using to generate cassandra config file 
function cluster_provisioning() {
    local logfile_path="${1}"
    local cassandra_config_path="${2}"
    local cassandra_tf_generated_config_path="${3}"
    if [ -f "${cassandra_tf_generated_config_path}" ]; then
        mv "${cassandra_tf_generated_config_path}" "${cassandra_config_path}"
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Generated config replacement started" >> "${logfile_path}"
        sed -i "s/host_ip/$(hostname -i)/g" "${cassandra_config_path}"
        echo "$(date +'%Y-%m-%d %H:%M:%S'): localhost IP was replaced" >> "${logfile_path}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Generated config wasn't found" >> "${logfile_path}"
    fi
}

function main() {
    logfile_path="/var/log/cluster_provisioner_remote_exec.log"
    cassandra_config_path="/etc/cassandra/cassandra.yaml"
    cassandra_default_config_path="/etc/cassandra/cassandra-default.yaml"
    cassandra_tf_generated_config_path="/tmp/cassandra.yaml"
    if [ -f "${cassandra_default_config_path}" ]; then
        create_logfile "${logfile_path}"
        node_drain "${logfile_path}" "${cassandra_default_config_path}"
        delay "${logfile_path}" "${cassandra_default_config_path}"
        stop_cassandra "${logfile_path}"
        cluster_provisioning "${logfile_path}" "${cassandra_config_path}" "${cassandra_tf_generated_config_path}"
        start_cassandra "${logfile_path}"
    else
        create_logfile "${logfile_path}"
        stop_cassandra "${logfile_path}"
        first_boot_configuration "${logfile_path}" "${cassandra_default_config_path}"
        cluster_provisioning "${logfile_path}" "${cassandra_config_path}" "${cassandra_tf_generated_config_path}"
        start_cassandra "${logfile_path}"
        delay "${logfile_path}" "${cassandra_default_config_path}"
        restart_cassandra "${logfile_path}"
    fi
}
main