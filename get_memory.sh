#!/bin/sh

set -eu

if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    echo "cgroup v2 detected." >&2
    if [ -f /sys/fs/cgroup/memory.max ]; then
        memory_bytes=$(cat /sys/fs/cgroup/memory.max)
        if [ "$memory_bytes" = "max" ]; then
            echo "No memory limits set." >&2
            unset memory_bytes
        fi
    else
        echo "/sys/fs/cgroup/memory.max not found." >&2
    fi
else
    echo "cgroup v1 detected." >&2

    if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
        memory_bytes=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
        memory_kb=$((memory_bytes / 1024))
        memory_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        if [ "$memory_kb" -ge "$memory_total_kb" ]; then
            echo "No memory limits set." >&2
            unset memory_bytes
        fi
        unset memory_kb memory_total_kb
    else
        echo "/sys/fs/cgroup/memory/memory.limit_in_bytes not found." >&2
    fi
fi

if [ -n "${memory_bytes:-}" ]; then
    memory_mb=$((memory_bytes / 1024 / 1024))
else
    memory_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    memory_mb=$((memory_kb / 1024))
    unset memory_kb
fi

echo "Memory: $memory_mb MB"
