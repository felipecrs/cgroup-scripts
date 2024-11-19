# docker-scripts

Set of scripts to get useful information within docker containers.

## Usage

All `get_` scripts will print the requested information to `stdout`.

All `is_` scripts will return exit code `0` if the condition is met, and `1` otherwise.

Any unexpected behavior will be printed to `stderr`.

If the `VERBOSE` environment variable is set to `true`, the scripts will print additional information to `stderr`.

Additionally, you can set the `DEBUG` environment variable to `true` to print debug information to `stderr`.

## Installation

You can add the scripts to your images like this:

```Dockerfile
FROM alpine

ARG DOCKER_SCRIPTS_VERSION=0.2.0
ADD --chmod=755 https://github.com/felipecrs/docker-scripts/raw/v${DOCKER_SCRIPTS_VERSION}/get_cpus.sh /opt/docker-scripts/
ADD --chmod=755 https://github.com/felipecrs/docker-scripts/raw/v${DOCKER_SCRIPTS_VERSION}/get_memory.sh /opt/docker-scripts/
ADD --chmod=755 https://github.com/felipecrs/docker-scripts/raw/v${DOCKER_SCRIPTS_VERSION}/is_privileged.sh /opt/docker-scripts/
```

And then, you can invoke any script calling it from their path:

```console
❯ docker run --rm --cpus 2 my-image /opt/docker-scripts/get_cpus.sh
2
```

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

### `is_privileged.sh`

```console
❯ cat is_privileged.sh | docker run --rm -i -e VERBOSE=true alpine sh
VERBOSE(is_privileged.sh): Container is not running in privileged mode.
❯ echo $?
1

❯ cat is_privileged.sh | docker run --rm -i -e VERBOSE=true --privileged alpine sh
VERBOSE(is_privileged.sh): Container is running in privileged mode.
❯ echo $?
0
```
