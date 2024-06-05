# cgroup-scripts

Set of scripts to get cgroup limits information within containers.

## Examples

All scripts will print the requested information to `stdout`. Any unexpected behavior will be printed to `stderr`.

If the `VERBOSE` environment variable is set to `true`, the scripts will print additional information to `stderr`.

Additionally, you can set the `DEBUG` environment variable to `true` to print debug information to `stderr`.

### `get_cpus.sh`

In a system with cgroup v2:

```console
❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true alpine sh
cgroup v2 detected.
No CPU limits set.
CPUs:
16

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 2 alpine sh
cgroup v2 detected.
CPUs:
2

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 1.5 alpine sh
cgroup v2 detected.
CPUs:
1

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 0.5 alpine sh
cgroup v2 detected.
CPUs:
1
```

Another system with cgroup v1:

```console
❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true alpine sh
cgroup v1 detected.
No CPU limits set.
CPUs:
8

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 2 alpine sh
cgroup v1 detected.
CPUs:
2

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 1.5 alpine sh
cgroup v1 detected.
CPUs:
1

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 0.5 alpine sh
cgroup v1 detected.
CPUs:
1
```

### `get_memory.sh`

In a system with cgroup v2:

```console
❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true alpine sh
cgroup v2 detected.
No memory limits set.
Memory (MB):
15996

❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true --memory 1g alpine sh
cgroup v2 detected.
Memory (MB):
1024
```

Another system with cgroup v1:

```console
❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true alpine sh
cgroup v1 detected.
No memory limits set.
Memory (MB):
32092

❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true --memory 1g alpine sh
cgroup v1 detected.
Memory (MB):
1024
```
