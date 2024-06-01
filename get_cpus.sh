#!/bin/sh

set -eu

if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    echo "cgroup v2 detected." >&2
    if [ -f /sys/fs/cgroup/cpu.max ]; then
        read -r quota period </sys/fs/cgroup/cpu.max
        if [ "$quota" = "max" ]; then
            echo "No CPU limits set." >&2
            unset quota period
        fi
    else
        echo "/sys/fs/cgroup/cpu.max not found." >&2
    fi
else
    echo "cgroup v1 detected." >&2

    if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ] && [ -f /sys/fs/cgroup/cpu/cpu.cfs_period_us ]; then
        quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
        period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)

        if [ "$quota" = "-1" ]; then
            echo "No CPU limits set." >&2
            unset quota period
        fi
    else
        echo "/sys/fs/cgroup/cpu/cpu.cfs_quota_us or /sys/fs/cgroup/cpu/cpu.cfs_period_us not found." >&2
    fi
fi

if [ -n "${quota:-}" ] && [ -n "${period:-}" ]; then
    cpus=$((quota / period))
    if [ "$cpus" -eq 0 ]; then
        cpus=1
    fi
else
    cpus=$(grep -c processor /proc/cpuinfo)
fi

echo "CPUs: $cpus"
