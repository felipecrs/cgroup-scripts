#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname "$0")
readonly script_dir

cd "$script_dir/.."

machine_cpus=$(grep -c ^processor /proc/cpuinfo)

docker_cmd=(docker run --rm -v "${PWD}:${PWD}" -w "${PWD}" -e VERBOSE -e DEBUG)

function expect() {
  local expected="$1"
  local input
  input=$(cat /dev/stdin)

  if [ "$input" == "$expected" ]; then
    echo "Test passed" >&2
  else
    echo "Test failed" >&2
    echo "Expected: $expected" >&2
    echo "Got: $input" >&2
    exit 1
  fi
}

"${docker_cmd[@]}" alpine ./get_cpus.sh | expect "$machine_cpus"

"${docker_cmd[@]}" ubuntu ./get_cpus.sh | expect "$machine_cpus"

"${docker_cmd[@]}" --cpus 2 alpine ./get_cpus.sh | expect 2

"${docker_cmd[@]}" --cpus 0.5 ubuntu ./get_cpus.sh | expect 1

"${docker_cmd[@]}" --cpus 1.5 alpine ./get_cpus.sh | expect 1

machine_memory=$(grep MemTotal /proc/meminfo | awk '{print $2}')
machine_memory=$((machine_memory / 1024))

"${docker_cmd[@]}" alpine ./get_memory.sh | expect "$machine_memory"

"${docker_cmd[@]}" ubuntu ./get_memory.sh | expect "$machine_memory"

"${docker_cmd[@]}" --memory 500mb alpine ./get_memory.sh | expect 500

"${docker_cmd[@]}" --memory 500mb ubuntu ./get_memory.sh | expect 500

"${docker_cmd[@]}" --memory 1g alpine ./get_memory.sh | expect 1024
