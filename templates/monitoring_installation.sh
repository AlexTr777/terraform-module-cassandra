#!/bin/bash

set -xue -o pipefail

function create_logfile() {
    exec > >(tee /var/log/monitoring_installation.log|logger -t user-data -s 2>/dev/console) 2>&1
}
# This function using to install node exporter from binaries
function install_node_exporter() {
    local node_exporter_version="${node_exporter_version}"
    if [ -n "${node_exporter_version}" ]; then
        wget https://github.com/prometheus/node_exporter/releases/download/v"${node_exporter_version}"/node_exporter-"${node_exporter_version}".linux-amd64.tar.gz
        tar xvf node_exporter-"${node_exporter_version}".linux-amd64.tar.gz
        cd node_exporter-"${node_exporter_version}".linux-amd64
        cp node_exporter /usr/local/bin
        cd ..
        rm -rf ./node_exporter-"${node_exporter_version}".linux-amd64
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Value for variable 'node_exporter_version' is not set"
    fi
}
# This function using to configure node exporter systemd file
function node_exporter_configuration() {
    if [ -f "/usr/local/bin/node_exporter" ]; then
        useradd --no-create-home --shell /bin/false node_exporter
        chown node_exporter:node_exporter  /usr/local/bin/node_exporter
        cd /etc/systemd/system/
        touch node_exporter.service
        cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Bin file /usr/local/bin/node_exporter was not found"
    fi
}
# This function using to start node exporter process
function start_node_exporter () {
    if [ -f "/etc/systemd/system/node_exporter.service" ] ; then 
        systemctl daemon-reload
        systemctl start node_exporter
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): File /etc/systemd/system/node_exporter.service was not found"
    fi
}
# This function using to check node exporter status after the installation
function check_node_exporter_status () {
    if [ "$(systemctl is-active node_exporter)" == "active" ] ; then
        echo "$(date +'%Y-%m-%d %H:%M:%S'): The 'node_exporter' service is running"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): The 'node_exporter' service failed to start and will be restarted"
        systemctl restart node_exporter
        sleep 30
        if [ "$(systemctl is-active node_exporter)" == "active" ] ; then
            echo "$(date +'%Y-%m-%d %H:%M:%S'): The 'node_exporter' service was successfully restarted. Currently running"
        else
            echo "$(date +'%Y-%m-%d %H:%M:%S'): The 'node_exporter' failed to start"
        fi
    fi
}

function main () {
    node_exporter_version="${node_exporter_version}"
    if [ -n "${node_exporter_version}" ] ; then
        if [ -f "/etc/systemd/system/node_exporter.service" ] ; then
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Node exporter already installed. Skipped"
        else
            create_logfile
            install_node_exporter "${node_exporter_version}"
            node_exporter_configuration
            start_node_exporter
            check_node_exporter_status
        fi
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Mandatory variables is not set"
    fi
}
main
