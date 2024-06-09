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
VERBOSE(get_cpus.sh): cgroup v2 detected.
VERBOSE(get_cpus.sh): No CPU limits set.
VERBOSE(get_cpus.sh): CPUs:
16

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 2 alpine sh
VERBOSE(get_cpus.sh): cgroup v2 detected.
VERBOSE(get_cpus.sh): CPUs:
2

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 1.5 alpine sh
VERBOSE(get_cpus.sh): cgroup v2 detected.
VERBOSE(get_cpus.sh): CPUs:
1

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 0.5 alpine sh
VERBOSE(get_cpus.sh): cgroup v2 detected.
VERBOSE(get_cpus.sh): CPUs:
1
```

Another system with cgroup v1:

```console
❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true alpine sh
VERBOSE(get_cpus.sh): cgroup v1 detected.
VERBOSE(get_cpus.sh): No CPU limits set.
VERBOSE(get_cpus.sh): CPUs:
8

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 2 alpine sh
VERBOSE(get_cpus.sh): cgroup v1 detected.
VERBOSE(get_cpus.sh): CPUs:
2

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 1.5 alpine sh
VERBOSE(get_cpus.sh): cgroup v1 detected.
VERBOSE(get_cpus.sh): CPUs:
1

❯ cat get_cpus.sh | docker run --rm -i -e VERBOSE=true --cpus 0.5 alpine sh
VERBOSE(get_cpus.sh): cgroup v1 detected.
VERBOSE(get_cpus.sh): CPUs:
1
```

### `get_memory.sh`

In a system with cgroup v2:

```console
❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true alpine sh
VERBOSE(get_memory.sh): cgroup v2 detected.
VERBOSE(get_memory.sh): No memory limits set.
VERBOSE(get_memory.sh): Memory (MB):
15996

❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true --memory 1g alpine sh
VERBOSE(get_memory.sh): cgroup v2 detected.
VERBOSE(get_memory.sh): Memory (MB):
1024
```

Another system with cgroup v1:

```console
❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true alpine sh
VERBOSE(get_memory.sh): cgroup v1 detected.
VERBOSE(get_memory.sh): No memory limits set.
Memory (MB):
32092

❯ cat get_memory.sh | docker run --rm -i -e VERBOSE=true --memory 1g alpine sh
VERBOSE(get_memory.sh): cgroup v1 detected.
VERBOSE(get_memory.sh): Memory (MB):
1024
```
