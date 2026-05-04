# Recommendation

Use a **Nix flake-check sandbox plus Gas City's existing isolated-supervisor pattern**: start `gc supervisor run` as a child process under `env -i` with a throwaway `HOME`, `GC_HOME`, `XDG_RUNTIME_DIR`, and `DOLT_ROOT_PATH`, then run all orchestrator commands with that same env and stop only that supervisor. Do **not** use the live user supervisor, `systemctl --user`, or `gc supervisor restart`. Add `bubblewrap` only as an optional local wrapper outside `nix flake check`; inside the check, Nix already provides the outer filesystem sandbox, while Gas City's own source shows the important inner contract is isolated `GC_HOME` plus private runtime dir.

## 1. Gas City Core Tests / CI

Gas City's normal integration path is **not Docker/Podman/firejail/systemd-nspawn**. It runs Go tests directly through an env scrubber. The Makefile defines `TEST_ENV = env -i` and says the point is to strip `GC_CITY`, `GC_HOME`, `GC_SESSION_ID`, etc. so tests cannot corrupt live cities (`/git/github.com/gastownhall/gascity/Makefile:127-145`). The integration targets call that wrapper directly: `test-integration` is `$(TEST_ENV) go test -tags integration -timeout 30m ./...`, and `test-integration-huma` is the same pattern for the Huma smoke test (`/git/github.com/gastownhall/gascity/Makefile:249-255`). CI runs those same shard scripts directly, not in a container wrapper (`/git/github.com/gastownhall/gascity/.github/workflows/ci.yml:405-514`).

The sharded integration runner duplicates the same shape: `run_go_test()` starts with `env -i`, allows only build/runtime basics, sets `GC_FAST_UNIT=0`, then invokes `go test` (`/git/github.com/gastownhall/gascity/scripts/test-integration-shard:23-52`). It selects package/test shards and calls that scrubbed runner (`/git/github.com/gastownhall/gascity/scripts/test-integration-shard:93-112`).

The integration harness isolates supervisor state explicitly. `testGCHome` is documented as isolating the supervisor registry/config/logs from real `~/.gc`, and `testRuntimeDir` isolates lock/socket state from the real XDG runtime dir (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:50-56`). `TestMain` creates a temp root, `gc-home`, `runtime`, and tool bin (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:94-112`), writes a supervisor config bound to `127.0.0.1` on a reserved port (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:168-175`), and after tests stops the isolated supervisor with `gc supervisor stop --wait` using `integrationEnv()` (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:183-190`).

The env builder is the critical part to borrow. It removes `GC_BEADS`, `GC_DOLT`, `PATH`, `GC_HOME`, `XDG_RUNTIME_DIR`, Dolt/beads connection env, integration binary overrides, and `BEADS_DOLT_AUTO_START`, then appends isolated `GC_HOME`, `XDG_RUNTIME_DIR`, `DOLT_ROOT_PATH`, an integration `PATH`, and `BEADS_DOLT_AUTO_START=0` (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:660-695`).

Per-test helpers use the same pattern. `newIsolatedEnvRoot()` creates a temp root, `gc-home`, runtime dir, isolated supervisor config on a reserved loopback port, Dolt identity, and returns `integrationEnvFor(...)` (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:738-768`). `newIsolatedCommandEnv()` adds `systemctl` and `launchctl` no-op shims before starting the isolated supervisor (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:716-735`). `startIsolatedSupervisor()` runs `gc supervisor run` in that isolated env, waits for `supervisor status`, registers cleanup that runs `gc supervisor stop --wait`, and kills the process only if it will not exit (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:974-1046`).

`setupCity()` is the front-door model for tests that need a real city: it gets an isolated command env, creates a city under `t.TempDir()`, runs `gc init --file`, registers the city env, and cleans up with `gc stop` plus `gc supervisor stop --wait` under that env (`/git/github.com/gastownhall/gascity/test/integration/helpers_test.go:46-86`).

Tmux tests isolate their own socket too. The `tmuxtest` package says it uses unique `gctest-*` names, pre/per/post cleanup, and an isolated tmux socket so tests never hit the user's tmux server (`/git/github.com/gastownhall/gascity/test/tmuxtest/guard.go:1-13`). Guards generate a unique city/socket and register cleanup (`/git/github.com/gastownhall/gascity/test/tmuxtest/guard.go:53-78`), and sweeps only list/kill `gctest-*` sockets (`/git/github.com/gastownhall/gascity/test/tmuxtest/guard.go:119-132`, `/git/github.com/gastownhall/gascity/test/tmuxtest/guard.go:151-167`).

Gas City does have Docker tests, but for the **Docker session provider**, not for the core supervisor harness. CI's `docker-session` job is separate and gated by Docker-related changes, then runs `make test-docker` (`/git/github.com/gastownhall/gascity/.github/workflows/ci.yml:1043-1067`). `scripts/gc-session-docker` says each agent runs in its own Docker container with tmux inside (`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:1-19`), strips controller-only env vars (`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:42-50`), mounts work/city paths and optionally `$HOME` read-only (`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:242-282`), starts `docker run -d --init ... sleep infinity` (`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:297-313`), and starts the agent in tmux inside the container (`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:382-419`). Its test script builds throwaway Alpine images and cleans named Docker sessions (`/git/github.com/gastownhall/gascity/scripts/test-docker-session:1-16`, `/git/github.com/gastownhall/gascity/scripts/test-docker-session:54-76`, `/git/github.com/gastownhall/gascity/scripts/test-docker-session:82-134`).

One more source detail matters for an orchestrator harness: Gas City itself seeds an isolated supervisor config when `GC_HOME` is set to something other than the user's real `~/.gc`. `seedIsolatedSupervisorConfig()` reserves a loopback port and writes `[supervisor] port = ...` (`/git/github.com/gastownhall/gascity/internal/supervisor/config.go:212-238`), and `shouldSeedIsolatedSupervisorConfig()` returns true only when `GC_HOME` is set and is not the real `$HOME/.gc` (`/git/github.com/gastownhall/gascity/internal/supervisor/config.go:241-254`).

## 2. Kit And Gas City Operators

Kit (`bmt/gascity-explore`) is a PR-review operating model, not a containerized supervisor-test harness. Its README says the boundary is an unprivileged GitHub identity: agents can branch, implement, test, and push, but cannot land main without human review (`/git/github.com/bmt/gascity-explore/README.md:7-11`). The bot identity can push branches and create PRs but cannot merge or self-approve (`/git/github.com/bmt/gascity-explore/README.md:28-32`). The pipeline is Polecat -> Steward -> Reviewer -> Human (`/git/github.com/bmt/gascity-explore/README.md:34-44`).

The steward is a patrol agent, not a sandbox runner. Its agent config uses a rig-scoped worktree `.gc/worktrees/{{.Rig}}/steward`, `idle_timeout = "15m"`, one active session, and zero minimum active sessions (`/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/agent.toml:1-8`). Its prompt says it wakes, drains if no work, processes webhook beads, checks assigned PR beads, sleeps one minute, and loops while it owns PR beads (`/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/prompt.template.md:9-35`, `/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/prompt.template.md:76-91`, `/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/prompt.template.md:350-366`). Health monitoring detects stuck steward/reviewer beads, reclaims dead reviewer sessions, and mails the mayor (`/git/github.com/bmt/gascity-explore/packs/kit/scripts/pr-pipeline-health.sh:1-13`, `/git/github.com/bmt/gascity-explore/packs/kit/scripts/pr-pipeline-health.sh:62-107`).

The Gas City packs repo does show a Docker sidecar pattern for untrusted/long-context helper work. RLM says Docker is the default execution path and local mode has no hard security boundary (`/git/github.com/gastownhall/gascity-packs/rlm/README.md:71-77`). Its CLI defaults `gc rlm install --environment` to `docker` (`/git/github.com/gastownhall/gascity-packs/rlm/scripts/rlm_cli.py:66-70`), and `ask_runtime()` runs Docker with `--rm`, `--user uid:gid`, `--read-only`, `--cap-drop ALL`, `--security-opt no-new-privileges`, `--pids-limit 256`, `--memory 2g`, read-only corpus mount, writable output/log mounts, tmpfs `/tmp`, and optional `--network none` (`/git/github.com/gastownhall/gascity-packs/rlm/scripts/rlm_cli.py:285-359`). Its doctor checks Docker only when Docker execution is configured (`/git/github.com/gastownhall/gascity-packs/rlm/doctor/check-docker.sh:1-41`).

## 3. Codex `--sandbox`

Codex exposes `--sandbox` / `-s` as a CLI option (`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:36-40`). The dangerous bypass flag explicitly skips prompts and executes without sandboxing, and the comment says it is intended only for externally sandboxed environments (`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:41-48`).

The CLI enum maps `read-only`, `workspace-write`, and `danger-full-access` into protocol `SandboxMode` (`/git/github.com/openai/codex/codex-rs/utils/cli/src/sandbox_mode_cli_arg.rs:1-27`). If `--dangerously-bypass-approvals-and-sandbox` is set, the CLI forces approval policy `Never` and sandbox mode `DangerFullAccess`; otherwise it uses the chosen `--sandbox` value (`/git/github.com/openai/codex/codex-rs/cli/src/main.rs:1351-1373`).

`danger-full-access` means no managed sandbox. The protocol comment says `DangerFullAccess` has "No restrictions whatsoever" (`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1028-1034`). It has full disk write and full network access (`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1178-1197`), and `SandboxEnforcement::from_legacy_sandbox_policy()` maps it to `Disabled` (`/git/github.com/openai/codex/codex-rs/protocol/src/models.rs:241-247`). A disabled permission profile becomes unrestricted filesystem and enabled network (`/git/github.com/openai/codex/codex-rs/protocol/src/models.rs:502-526`). On Linux, the bubblewrap wrapper returns the original command unchanged when filesystem and network are both full access (`/git/github.com/openai/codex/codex-rs/linux-sandbox/src/bwrap.rs:227-255`).

For managed sandboxing, Codex uses platform primitives: macOS Seatbelt via `/usr/bin/sandbox-exec`, Linux bubblewrap by default, and Windows restricted-token/elevated backends (`/git/github.com/openai/codex/codex-rs/cli/src/main.rs:328-340`, `/git/github.com/openai/codex/codex-rs/core/README.md:9-49`, `/git/github.com/openai/codex/codex-rs/core/README.md:51-78`). The Linux sandbox helper prefers system `bwrap`, falls back to vendored bubblewrap, warns when user namespaces fail, and rejects WSL1 for bwrap (`/git/github.com/openai/codex/codex-rs/linux-sandbox/README.md:1-22`). When bwrap is active, Codex applies no-new-privs/seccomp, read-only root with `--ro-bind / /`, writable roots with `--bind`, read-only protected subpaths, user/PID namespace isolation, optional network namespace isolation, and fresh `/proc` (`/git/github.com/openai/codex/codex-rs/linux-sandbox/README.md:49-95`; mount order is in `/git/github.com/openai/codex/codex-rs/linux-sandbox/src/bwrap.rs:351-367`).

## 4. Broader Agent / Container Convention

| Tool / project | URL | Rootless | NixOS fit | Network isolation | File isolation | Teardown | Mainstream |
|---|---|---:|---:|---|---|---|---|
| Nix build sandbox / flake check | https://github.com/NixOS/nix | yes | best | default no network in builds | chrooted store inputs + temp build dir | automatic | high on NixOS |
| bubblewrap | https://github.com/containers/bubblewrap | yes if user namespaces work | high | `--unshare-net` | bind/tmpfs mount graph | process-scoped | high |
| Docker / Moby | https://github.com/moby/moby | usually daemon-mediated | medium | yes | image + mounts | good with `--rm`, labels | very high |
| Podman | https://github.com/containers/podman | yes | high | yes | image + mounts | good | high |
| firejail | https://github.com/netblue30/firejail | yes/setuid variants | medium | yes | profiles/private dirs | process-scoped | medium |
| nsjail | https://github.com/google/nsjail | yes with namespaces | medium | yes | namespace/chroot/bind model | process-scoped | medium-security |
| systemd-nspawn | https://github.com/systemd/systemd | usually needs systemd privileges | medium | yes | container root | clean unit/machine teardown | medium |
| macOS sandbox-exec | Apple system tool; Codex source above | n/a | no | profile-dependent | Seatbelt profile | process-scoped | macOS-only |
| Dev Containers / Codespaces | https://github.com/devcontainers/spec | backend-dependent | medium | backend-dependent | container workspace | clean but heavier | very high |
| OpenHands | https://github.com/All-Hands-AI/OpenHands | Docker/K8s dependent | medium | Docker/K8s settings | runtime workspace mounts | sandbox service lifecycle | high in agent space |
| OpenAgents | https://github.com/xlang-ai/OpenAgents | Docker dependent | medium | Docker code interpreter | mounted backend data | compose/container lifecycle | lower/older |
| Claude Code examples | https://github.com/anthropics/claude-code | backend-dependent | medium | Bash sandbox settings | Bash-only sandbox or devcontainer | process/container | high |
| OpenClaw | https://github.com/openclaw/openclaw | Docker dependent | medium | default Docker network none | per-session workspace/container | labels + prune | real project |

OpenHands uses sandbox runtimes, not just shell env scrub. Its template sets `runtime = "docker"` and sandbox workspace mount paths (`/git/github.com/All-Hands-AI/OpenHands/config.template.toml:58-71`), has a `[sandbox]` section with base/runtime container image, Docker kwargs, GPU, lifecycle, and volume mounts (`/git/github.com/All-Hands-AI/OpenHands/config.template.toml:147-223`), and also has Kubernetes runtime settings (`/git/github.com/All-Hands-AI/OpenHands/config.template.toml:302-342`). Its app server wires Docker, process, and remote sandbox services (`/git/github.com/All-Hands-AI/OpenHands/openhands/app_server/config.py:262-279`); Docker sandboxes are Docker containers with generated IDs, env/session keys, port mappings, volume mounts, optional host networking, and `containers.run(... detach=True, init=True)` (`/git/github.com/All-Hands-AI/OpenHands/openhands/app_server/sandbox/docker_sandbox_service.py:360-490`). Its process fallback starts separate agent-server processes in dedicated directories with unique ports and session API keys (`/git/github.com/All-Hands-AI/OpenHands/openhands/app_server/sandbox/process_sandbox_service.py:1-74`).

OpenAgents has an optional Docker code-execution sandbox. Its backend README says to use a sandbox Docker instead of local OS for safe Python execution and multi-user/kernel conflict avoidance (`/git/github.com/xlang-ai/OpenAgents/backend/README.md:171-193`). The compose file includes a commented `code_interpreter` service and says `CODE_EXECUTION_MODE=local` unless the code interpreter is running, then set Docker (`/git/github.com/xlang-ai/OpenAgents/docker-compose.yml:26-54`). Runtime code switches between `run_program_local` and `run_program_docker` based on `code_execution_mode` (`/git/github.com/xlang-ai/OpenAgents/real_agents/data_agent/evaluation/python_evaluator.py:303-324`), and the Docker path uses a remote Jupyter kernel (`/git/github.com/xlang-ai/OpenAgents/real_agents/data_agent/evaluation/python_evaluator.py:184-207`).

Claude Code examples show two patterns: an enterprise Bash sandbox and devcontainers. The settings README says the sandbox property only applies to the Bash tool, not Read/Write/Web/MCP/hooks/internal commands (`/git/github.com/anthropics/claude-code/examples/settings/README.md:23-28`). The sandbox example enables sandboxing, disallows unsandboxed commands, and denies network by default (`/git/github.com/anthropics/claude-code/examples/settings/settings-bash-sandbox.json:1-18`). Its devcontainer helper supports Docker or Podman and runs `devcontainer up --workspace-folder .`, then executes `claude` inside the container (`/git/github.com/anthropics/claude-code/Script/run_devcontainer_claude_code.ps1:1-19`, `/git/github.com/anthropics/claude-code/Script/run_devcontainer_claude_code.ps1:107-147`). The changelog says BashTool sandbox mode was released on Linux and Mac (`/git/github.com/anthropics/claude-code/CHANGELOG.md:2583-2588`).

OpenClaw is real: `/git/github.com/openclaw/openclaw` exists and implements Docker-based per-session sandboxes. Its README says non-main sessions can run inside per-session Docker sandboxes and Bash then runs in Docker (`/git/github.com/openclaw/openclaw/README.md:330-333`). Config defaults resolve Docker sandbox settings to read-only root, tmpfs `/tmp`/`/var/tmp`/`/run`, network `"none"`, and `capDrop ["ALL"]` (`/git/github.com/openclaw/openclaw/src/agents/sandbox/config.ts:54-96`). Container creation validates sandbox security, labels `openclaw.sandbox=1`, adds `--read-only`, tmpfs, network, env, `--cap-drop`, `no-new-privileges`, resource limits, binds, workspace mounts, and `sleep infinity` (`/git/github.com/openclaw/openclaw/src/agents/sandbox/docker.ts:238-363`). Its context resolver creates/ensures the sandbox workspace, container, optional browser bridge, and fs bridge for the session (`/git/github.com/openclaw/openclaw/src/agents/sandbox/context.ts:85-156`).

## 5. Concrete Orchestrator Test Shape

The implementation should copy Gas City's own harness, with a Nix check as the outer sandbox:

1. `nix flake check` runs a derivation with no live `$HOME` mounted and no network unless explicitly allowed.
2. The test script sets `HOME=$TMPDIR/home`, `GC_HOME=$TMPDIR/gc-home`, `XDG_RUNTIME_DIR=$TMPDIR/runtime`, `DOLT_ROOT_PATH=$GC_HOME`, `BEADS_DOLT_AUTO_START=0`, and either `GC_DOLT=skip` or a fully isolated Dolt setup.
3. Start `gc supervisor run` directly as a child process. Do not use `systemctl --user`, `gc supervisor restart`, or any command without the isolated env.
4. Register/init the test city using the isolated env.
5. Run the orchestrator binary with the same isolated env.
6. Cleanup runs `gc supervisor stop --wait` with the isolated env, then kills the saved supervisor PID if it remains, then deletes `$TMPDIR`.

Shell skeleton:

```bash
#!/usr/bin/env bash
set -euo pipefail

root="$(mktemp -d "${TMPDIR:-/tmp}/gc-orch-it.XXXXXX")"
sup_pid=""
cleanup() {
  set +e
  if [ -n "$sup_pid" ]; then
    run_gc supervisor stop --wait >/dev/null 2>&1
    kill "$sup_pid" >/dev/null 2>&1
    wait "$sup_pid" >/dev/null 2>&1
  fi
  rm -rf "$root"
}
trap cleanup EXIT

mkdir -p "$root/home" "$root/gc-home" "$root/runtime" "$root/city"

run_gc() {
  env -i \
    PATH="$PATH" \
    HOME="$root/home" \
    USER="${USER:-nixbld}" \
    LOGNAME="${LOGNAME:-nixbld}" \
    SHELL="${SHELL:-/bin/sh}" \
    LANG="${LANG:-C.UTF-8}" \
    TMPDIR="$root/tmp" \
    GC_HOME="$root/gc-home" \
    XDG_RUNTIME_DIR="$root/runtime" \
    DOLT_ROOT_PATH="$root/gc-home" \
    GC_DOLT=skip \
    BEADS_DOLT_AUTO_START=0 \
    "$@"
}

mkdir -p "$root/tmp"
run_gc gc supervisor run >"$root/supervisor.log" 2>&1 &
sup_pid="$!"

deadline=$((SECONDS + 20))
until run_gc gc supervisor status | grep -q "Supervisor is running"; do
  if [ "$SECONDS" -ge "$deadline" ]; then
    cat "$root/supervisor.log" >&2
    exit 1
  fi
  sleep 0.2
done

run_gc gc init --skip-provider-readiness --file "$ORCH_TEST_CITY_TOML" "$root/city"
run_gc "$ORCHESTRATOR_BIN" --city "$root/city" --integration-test
```

Flake-check sketch:

```nix
checks.${system}.orchestrator-integration =
  pkgs.runCommand "orchestrator-integration"
    {
      nativeBuildInputs = [
        pkgs.bash
        pkgs.coreutils
        pkgs.gnugrep
        gascityPackage
        bdPackage
        doltPackage
        orchestratorPackage
      ];
    } ''
      export TMPDIR="$PWD/tmp"
      mkdir -p "$TMPDIR"
      export ORCHESTRATOR_BIN="${orchestratorPackage}/bin/orchestrator"
      export ORCH_TEST_CITY_TOML="${./testdata/city.toml}"
      bash ${./scripts/orchestrator-isolated-gc-test.sh}
      touch "$out"
    '';
```

If a developer wants to run the same script outside `nix flake check`, wrap it in `bubblewrap` to hide live home state:

```bash
BASH_BIN="$(command -v bash)"
bwrap --die-with-parent --unshare-pid --unshare-net \
  --ro-bind /nix /nix --ro-bind-try /run/current-system /run/current-system \
  --ro-bind "$PWD" "$PWD" --chdir "$PWD" --dev /dev --proc /proc \
  --tmpfs /tmp --setenv HOME /tmp/home \
  --setenv GC_HOME /tmp/gc-home \
  --setenv XDG_RUNTIME_DIR /tmp/runtime \
  --setenv PATH "$PATH" \
  "$BASH_BIN" scripts/orchestrator-isolated-gc-test.sh
```

That wrapper is optional for the flake check, but useful for manual runs because Codex's Linux source shows bubblewrap is the managed Linux primitive for filesystem/network isolation (`/git/github.com/openai/codex/codex-rs/core/README.md:23-49`; `/git/github.com/openai/codex/codex-rs/linux-sandbox/README.md:49-95`). The non-optional part is the Gas City harness contract: every `gc` and orchestrator invocation must receive the isolated env, matching Gas City's own `integrationEnvFor()` and `startIsolatedSupervisor()` patterns (`/git/github.com/gastownhall/gascity/test/integration/integration_test.go:660-695`, `/git/github.com/gastownhall/gascity/test/integration/integration_test.go:974-1046`).
