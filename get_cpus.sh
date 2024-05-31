#!/bin/sh

set -eu

calc_cpus() {
    cpus=$((quota / period))
    if [ "$cpus" -eq 0 ]; then
        cpus=1
    fi
}

cpus=""
if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    echo "cgroup v2 detected." >&2
    if [ -f /sys/fs/cgroup/cpu.max ]; then
        read -r quota period </sys/fs/cgroup/cpu.max
        if [ "$quota" = "max" ]; then
            echo "No CPU limits set." >&2
        else
            calc_cpus
        fi
    else
        echo "Cannot determine cgroup CPU path." >&2
    fi
else
    echo "cgroup v1 detected." >&2

    if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ] && [ -f /sys/fs/cgroup/cpu/cpu.cfs_period_us ]; then
        quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
        period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)

        if [ "$quota" = "-1" ]; then
            echo "No CPU limits set." >&2
        else
            calc_cpus
        fi
    else
        echo "Cannot determine cgroup CPU path." >&2
    fi
fi

if [ -z "$cpus" ]; then
    cpus=$(nproc --all)
fi

echo "CPUs: $cpus"
