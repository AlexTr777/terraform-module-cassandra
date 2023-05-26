#!/bin/bash
set -xue -o pipefail

function create_logfile() {
    exec > >(tee /var/log/ebs_configuration.log|logger -t user-data -s 2>/dev/console) 2>&1
}

function mount_ebs_volume() {
    local ebs_device="${ebs_device}"
    local mount_point="/var/lib/cassandra"
    local file_system="/dev/$ebs_device"
    local fstab_label="ebs_fs"
    local user_group="cassandra"

    # Check if the device is already mounted
    if grep -qs $mount_point /proc/mounts; then
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Device is already mounted"
    else
    # Check if the device exists
        if [ -n $ebs_device ]; then
            # Create the mount point directory if it does not exist
            if [ ! -d $mount_point ]; then
            sudo mkdir $mount_point
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Mount folder was created"
            fi
            
            # Create filesystem and mount it to the mount point
            mkfs -t ext4 -L $fstab_label $file_system
            sudo mount $file_system $mount_point
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Device was mounted successfully"
            chown $user_group:$user_group $mount_point
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Owner for $mount_point was set successfully"
            
            # Add the device to /etc/fstab to ensure it's mounted on boot
            echo "LABEL=$fstab_label    $mount_point    ext4    discard,errors=remount-ro 0 1" | tee -a /etc/fstab
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Device added to /etc/fstab"
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Reboot started"
            reboot now
        else
            echo "$(date +'%Y-%m-%d %H:%M:%S'): Device does not exist"
        fi
    fi
}

function main () {
    ebs_device="${ebs_device}"
    if [ -n "${ebs_device}" ] ; then
        create_logfile
        mount_ebs_volume "${ebs_device}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S'): Mandatory variables is not set"
    fi
}
main