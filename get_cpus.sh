#!/bin/sh

set -eu

if [ "${DEBUG:-}" = true ]; then
  set -x
fi

verbose() {
  if [ "${VERBOSE:-}" = true ]; then
    echo "VERBOSE(get_cpus.sh):" "$@" >&2
  fi
}

warning() {
  echo "WARNING(get_cpus.sh):" "$@" >&2
}

if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
  verbose "cgroup v2 detected."
  if [ -f /sys/fs/cgroup/cpu.max ]; then
    read -r quota period </sys/fs/cgroup/cpu.max
    if [ "${quota}" = "max" ]; then
      verbose "No CPU limits set."
      unset quota period
    fi
  else
    warning "/sys/fs/cgroup/cpu.max not found. Falling back to /proc/cpuinfo."
  fi
else
  verbose "cgroup v1 detected."

  if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ] && [ -f /sys/fs/cgroup/cpu/cpu.cfs_period_us ]; then
    quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
    period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)

    if [ "${quota}" = "-1" ]; then
      verbose "No CPU limits set."
      unset quota period
    fi
  else
    warning "/sys/fs/cgroup/cpu/cpu.cfs_quota_us or /sys/fs/cgroup/cpu/cpu.cfs_period_us not found. Falling back to /proc/cpuinfo."
  fi
fi

# This is theoretically not possible, but:
# https://github.com/blakeblackshear/frigate/discussions/11755#discussioncomment-10304356
if [ -n "${period:-}" ] && [ "${period:-}" -eq 0 ]; then
  warning "CPU period is 0. Falling back to /proc/cpuinfo."
  unset quota period
fi

if [ -n "${quota:-}" ] && [ -n "${period:-}" ]; then
  cpus=$((quota / period))
  if [ "${cpus}" -eq 0 ]; then
    cpus=1
  fi
else
  cpus=$(grep -c ^processor /proc/cpuinfo)
fi

verbose "CPUs:"
printf '%s' "${cpus}"
