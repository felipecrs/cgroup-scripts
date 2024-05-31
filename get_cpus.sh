#!/bin/sh

set -eu

if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    echo "cgroup v2 detected." >&2
    if [ -f /sys/fs/cgroup/cpu.max ]; then
        read -r quota period </sys/fs/cgroup/cpu.max
        if [ "$quota" = "max" ]; then
            echo "No CPU limits set." >&2
            cpus=$(nproc --all)
        else
            cpus=$(awk -v q="$quota" -v p="$period" 'BEGIN { print q / p }')
        fi
    else
        echo "Cannot determine cgroup CPU path." >&2
        cpus=$(nproc --all)
    fi
else
    echo "cgroup v1 detected." >&2

    if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ] && [ -f /sys/fs/cgroup/cpu/cpu.cfs_period_us ]; then
        quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
        period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)

        if [ "$quota" = "-1" ]; then
            echo "No CPU limits set." >&2
            cpus=$(nproc --all)
        else
            cpus=$(awk -v q="$quota" -v p="$period" 'BEGIN { print q / p }')
        fi
    else
        echo "Cannot determine cgroup CPU path." >&2
        cpus=$(nproc --all)
    fi
fi

echo "CPUs: $cpus"
