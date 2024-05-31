#!/bin/bash

set -euo pipefail

get_cpu_quota_and_period() {
    local cgroup_base_path="/sys/fs/cgroup"
    local cgroup_cpu_path=""
    local cgroup_version=""

    # Detect if we're using cgroup v2
    if [ -f "${cgroup_base_path}/cgroup.controllers" ]; then
        cgroup_cpu_path="${cgroup_base_path}/cpu.max"
        cgroup_version="v2"
    else
        # Fallback to cgroup v1 paths
        while IFS= read -r line; do
            if [[ "$line" == *":cpu:"* ]]; then
                cgroup_cpu_path="${cgroup_base_path}/cpu$(echo "$line" | awk -F: '{print $3}')/cpu.cfs_quota_us"
                cgroup_version="v1"
                break
            fi
        done < /proc/self/cgroup
    fi

    if [ -z "$cgroup_cpu_path" ] || [ ! -f "$cgroup_cpu_path" ]; then
        echo "Cannot determine cgroup CPU path." >&2
        exit 1
    fi

    if [[ "$cgroup_cpu_path" == *"cpu.max" ]]; then
        # cgroup v2
        read -r quota period < "$cgroup_cpu_path"
        if [ "$quota" == "max" ]; then
            quota=-1
        fi
    else
        # cgroup v1
        quota=$(cat "$cgroup_cpu_path")
        local cgroup_period_path="${cgroup_cpu_path/cpu.cfs_quota_us/cpu.cfs_period_us}"
        period=$(cat "$cgroup_period_path")
    fi

    echo "$cgroup_version $quota $period"
}

calculate_cpu_count() {
    local quota=$1
    local period=$2

    if [ "$quota" -eq -1 ]; then
        nproc
    else
        awk -v q="$quota" -v p="$period" 'BEGIN { print q / p }'
    fi
}

main() {
    read -r cgroup_version quota period < <(get_cpu_quota_and_period)
    echo "Detected cgroups $cgroup_version"

    if [ "$quota" -eq -1 ]; then
        echo "No CPU limits set."
        cpu_count=$(nproc)
    else
        cpu_count=$(calculate_cpu_count "$quota" "$period")
        echo "nproc: $(nproc)"
    fi

    echo "Allocated CPUs: $cpu_count"
}

main
