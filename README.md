# cgroup-scripts

Set of scripts to get cgroup limits information within containers.

## Examples

### `get_cpus.sh`

In a system with cgroup v2:

```console
❯ cat get_cpus.sh | docker run --rm -i ubuntu sh
cgroup v2 detected.
No CPU limits set.
CPUs: 16

❯ cat get_cpus.sh | docker run --rm -i --cpus 2 ubuntu sh
cgroup v2 detected.
CPUs: 2

❯ cat get_cpus.sh | docker run --rm -i --cpus 1.5 ubuntu sh
cgroup v2 detected.
CPUs: 1

❯ cat get_cpus.sh | docker run --rm -i --cpus 0.5 ubuntu sh
cgroup v2 detected.
CPUs: 1
```

Another system with cgroup v1:

```console
❯ cat get_cpus.sh | docker run --rm -i ubuntu sh
cgroup v1 detected.
No CPU limits set.
CPUs: 8

❯ cat get_cpus.sh | docker run --rm -i --cpus 2 ubuntu sh
cgroup v1 detected.
CPUs: 2

❯ cat get_cpus.sh | docker run --rm -i --cpus 1.5 ubuntu sh
cgroup v1 detected.
CPUs: 1

❯ cat get_cpus.sh | docker run --rm -i --cpus 0.5 ubuntu sh
cgroup v1 detected.
CPUs: 1
```

### `get_memory.sh`

In a system with cgroup v2:

```console
❯ cat get_memory.sh | docker run --rm -i ubuntu sh
cgroup v2 detected.
No memory limits set.
Memory: 15996 MB

❯ cat get_memory.sh | docker run --rm -i --memory 1g ubuntu sh
cgroup v2 detected.
Memory: 1024 MB
```

Another system with cgroup v1:

```console
❯ cat get_memory.sh | docker run --rm -i ubuntu sh
cgroup v1 detected.
No memory limits set.
Memory: 32092 MB

❯ cat get_memory.sh | docker run --rm -i --memory 1g ubuntu sh
cgroup v1 detected.
Memory: 1024 MB
```
