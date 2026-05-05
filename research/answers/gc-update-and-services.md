# gc update in flight + service-management primitive

## Direct answers

**Q1: clean in-flight gc binary replacement.** No true in-process binary replacement exists in the gc supervisor: the supervisor control socket supports `stop`, `ping`, and `reload`, and `reload` only queues reconciliation; SIGHUP also only queues reconciliation (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:328-386`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:221-232`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:785-801`). New gc source has a systemd "warm refresh" path in `gc supervisor install`, but it refuses to run against an active supervisor unless that process already has `GC_SUPERVISOR_PRESERVE_SESSIONS_ON_SIGNAL=1` (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1324-1334`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1371-1383`). The live unit file here still starts the old Nix-store gc and its env block does not include that preserve flag (`/home/li/.local/share/systemd/user/gascity-supervisor.service:4-18`). So the current cleanest procedure is intentionally disruptive:

```sh
~/.nix-profile/bin/gc supervisor stop --wait
~/.nix-profile/bin/gc supervisor install
~/.nix-profile/bin/gc supervisor status
```

`gc supervisor install` itself writes the unit, runs `systemctl --user daemon-reload`, enables the unit, and starts it when inactive, so no extra daemon-reload/restart command is required after the stopped-state install (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1384-1405`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1439-1462`).

**Q2: canonical gc service-management primitive.** gc's built-in primitive is `[[service]]` in city config or city-scoped packs, surfaced by `gc service list/doctor/restart`; the service runtime is explicitly for workspace-owned HTTP services mounted under `/svc/{name}` (`/git/github.com/LiGoldragon/gascity/internal/config/config.go:179-181`, `/git/github.com/LiGoldragon/gascity/internal/config/service.go:17-35`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_service.go:22-40`). For an external process, the canonical shape is `kind = "proxy_process"` with `[service.process].command`, but that process must listen on the `GC_SERVICE_SOCKET` Unix socket and optionally serve `health_path`; gc then supervises and restarts it (`/git/github.com/LiGoldragon/gascity/internal/config/service.go:148-156`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:199-215`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:271-297`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:137-154`). If the cascade orchestrator is only a generic city-watching daemon and does not speak HTTP on `GC_SERVICE_SOCKET`, gc has no generic "city_start daemon" declaration; use a systemd user unit unless the orchestrator is adapted/wrapped into a `proxy_process` workspace service.

## Q1 evidence

- `gc supervisor reload` is not a binary reload. The socket handler documents and implements only `stop`, `ping`, and `reload`; `reload` sends a `reconcileRequest` and replies `ok/busy/timeout` after reconciliation (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:328-386`). SIGHUP is treated the same way: the signal loop calls `requestReconcile()` for SIGHUP and only non-HUP signals request shutdown (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:221-232`).

- Only one supervisor is intended to run. `runSupervisor` refuses to start if an existing supervisor answers the socket, and the lock path uses an exclusive flock that returns "supervisor already running" (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:765-775`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:123-138`). That rules out a clean second-supervisor migration path in the gc code.

- `gc supervisor install` rewrites the platform service with the currently executing gc binary. `buildSupervisorServiceData` gets `os.Executable()` into `GCPath`, and the systemd template uses `ExecStart={{.GCPath}} supervisor run` (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:646-666`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:853-877`).

- The new unit template is designed for preserve-mode warm refresh: it sets `KillMode=process` so systemd does not SIGTERM tmux servers in the service cgroup, and it sets `GC_SUPERVISOR_PRESERVE_SESSIONS_ON_SIGNAL="1"` (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:858-872`). The supervisor maps SIGTERM plus that env var to `supervisorShutdownPreserveSessions`; otherwise shutdown is destructive (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:193-208`).

- The guarded systemd warm refresh path is inside `installSupervisorSystemd`: when content changed and the service is active, it checks the active supervisor env for preserve readiness, writes the new unit, daemon-reloads/enables it, sends SIGTERM only to the main PID, cleans up workspace service processes, and starts the service again (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1351-1383`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1384-1438`). This is a short supervisor restart, not an in-process exec.

- The current live unit is pre-preserve: it starts `/nix/store/wwn4c45zkqqxy3gjjljdlv1rf8fpqzfb-gascity-1.0.0-unstable-2026-05-02/bin/gc supervisor run` and has env lines for `GC_HOME`, `XDG_RUNTIME_DIR`, `PATH`, `HOME`, `LANG`, `LOGNAME`, `SHELL`, and `USER`, but no preserve flag (`/home/li/.local/share/systemd/user/gascity-supervisor.service:4-18`). Because the new installer refuses warm refresh without that active-process env, current-state `gc supervisor install` while active is not the safe path (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1373-1383`).

- The disruptive stop path kills sessions by design. The supervisor socket `stop` command requests `supervisorShutdownDestructive` (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:341-345`), and the shutdown branch calls `stopManagedCity` unless preserve mode is set (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:963-975`). `CityRuntime.shutdown` lists running sessions and calls `gracefulStopAll`, whose documented two-pass behavior is interrupt, wait, then force-stop survivors (`/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:2020-2070`, `/git/github.com/LiGoldragon/gascity/cmd/gc/controller.go:950-954`). For tmux, `Stop` destroys the named session and kills its process tree (`/git/github.com/LiGoldragon/gascity/internal/runtime/tmux/adapter.go:184-190`).

- Beads and mail survive the disruptive procedure because they are stored in the bead store, not in supervisor memory. `BdStore` delegates persistence to bd's embedded Dolt database (`/git/github.com/LiGoldragon/gascity/internal/beads/bdstore.go:134-136`), and beadmail's default backend stores messages as `Type="message"` beads (`/git/github.com/LiGoldragon/gascity/internal/mail/beadmail/beadmail.go:1-3`, `/git/github.com/LiGoldragon/gascity/internal/mail/beadmail/beadmail.go:59-67`).

- Managed Dolt is stopped on destructive supervisor shutdown and restarted on next city initialization. `stopManagedCity` calls `shutdownBeadsProvider` after the city goroutine exits or after forced shutdown (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:672-717`); `shutdownBeadsProvider` runs the exec provider's `stop` operation and clears managed runtime state (`/git/github.com/LiGoldragon/gascity/cmd/gc/beads_provider_lifecycle.go:446-466`). Startup runs `startBeadsLifecycle`, which calls `ensureBeadsProvider` for local Dolt (`/git/github.com/LiGoldragon/gascity/cmd/gc/beads_provider_lifecycle.go:88-118`); managed Dolt launch is `dolt sql-server --config ...` (`/git/github.com/LiGoldragon/gascity/cmd/gc/dolt_start_managed.go:71-79`).

- Reconciler state is in-memory and re-derived. On supervisor start, `runSupervisor` creates a fresh city registry, does an initial reconcile, and then starts/runs city runtimes for registry entries (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:816-927`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:1148-1168`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:1333-1468`). Each city runtime has a startup adoption barrier that scans running sessions and creates/adopts beads for them when the runtime starts (`/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:358-378`).

- Future upgrades after this one can use the warm-refresh path if the running supervisor was installed from the new template. In preserve-mode shutdown, `stopManagedCityPreservingSessions` marks the runtime for preservation, cancels it, and does not call the destructive bead-provider shutdown path (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:720-758`). `CityRuntime.shutdown` then closes workspace services but returns before session stopping when preserve mode is set (`/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:2026-2044`).

## Q2 evidence

- Config shape: `City.Services []Service` is loaded from repeated `[[service]]` tables (`/git/github.com/LiGoldragon/gascity/internal/config/config.go:179-181`). A service has `name`, `kind`, `publish_mode`, `state_root`, `workflow`, and `process`; the comments define it as a workspace-owned HTTP service mounted under `/svc/{name}` (`/git/github.com/LiGoldragon/gascity/internal/config/service.go:17-35`).

- Process-service shape: `kind` is limited to `workflow` or `proxy_process`, and `proxy_process` requires a non-empty `process.command` (`/git/github.com/LiGoldragon/gascity/internal/config/service.go:178-187`, `/git/github.com/LiGoldragon/gascity/internal/config/service.go:224-232`). The parsed example in tests is:

```toml
[[service]]
name = "bridge"
kind = "proxy_process"

[service.process]
command = ["./scripts/start-bridge.sh"]
health_path = "/healthz"
```

(`/git/github.com/LiGoldragon/gascity/internal/config/service_test.go:172-200`)

- Pack support exists only for city-scoped packs. `packConfig` has `Services []Service`, city root pack services are merged into city services, and rig pack services are rejected with "`[[service]] is only allowed in city-scoped packs`" (`/git/github.com/LiGoldragon/gascity/internal/config/pack.go:25-36`, `/git/github.com/LiGoldragon/gascity/internal/config/compose.go:140-154`, `/git/github.com/LiGoldragon/gascity/internal/config/pack.go:100-107`).

- `gc service` is an inspection/restart CLI over this service registry. The command tree is `list`, `doctor`, and `restart` (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_service.go:22-40`); restart calls the controller API and reports "Service <name> restarted" on success (`/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_service.go:99-138`).

- Runtime behavior: a city runtime constructs a `workspacesvc.Manager` and reloads it during construction; each tick calls `cr.svc.Tick` (`/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:248-251`, `/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:768-770`). `Manager.Reload` creates workflow or proxy-process instances for configured services (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/manager.go:75-97`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/manager.go:143-173`).

- `proxy_process` is not just "run any daemon"; it is a reverse-proxied HTTP process. The process is started with `exec.Command`, a service-specific process group, and env vars including `GC_SERVICE_SOCKET`, `GC_SERVICE_STATE_ROOT`, `GC_SERVICE_RUN_ROOT`, and URL/publication vars (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:199-215`). Startup waits until the process listens on `GC_SERVICE_SOCKET` and, if configured, returns a 2xx health response on `health_path` (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:271-337`). HTTP requests are reverse-proxied to that Unix socket (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:108-133`).

- Restart-on-crash exists for `proxy_process`: the wait goroutine sets `cmd = nil`, degraded status, and a next-restart timestamp when the process exits; `Tick` starts it again after the backoff (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:232-250`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:137-154`). Closing a service stops its process group with SIGTERM, then SIGKILL after a short wait (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:169-189`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:407-420`).

- Built-in workflow services are currently contract-registered Go implementations; the built-in one in this package is `gc.healthz.v1` (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/workflow_healthz.go:12-18`). Unsupported workflow contracts are rejected by runtime validation (`/git/github.com/LiGoldragon/gascity/internal/workspacesvc/validate.go:9-24`).

- Dolt sql-server is not a `[[service]]` workspace service. It is managed through the bead-provider lifecycle: `startBeadsLifecycle` ensures the bead provider, `ensureBeadsProvider` runs exec provider `start`, and the managed implementation starts `dolt sql-server --config ...` (`/git/github.com/LiGoldragon/gascity/cmd/gc/beads_provider_lifecycle.go:88-118`, `/git/github.com/LiGoldragon/gascity/cmd/gc/beads_provider_lifecycle.go:415-443`, `/git/github.com/LiGoldragon/gascity/cmd/gc/dolt_start_managed.go:71-79`).

- Orders are not daemon declarations. An order chooses either `formula` or `exec`, and `exec` is "run directly by the controller"; triggers are limited to `cooldown`, `cron`, `condition`, `event`, and `manual` (`/git/github.com/LiGoldragon/gascity/internal/orders/order.go:19-28`, `/git/github.com/LiGoldragon/gascity/internal/orders/order.go:140-185`). `city_start` is not an accepted trigger in the validator (`/git/github.com/LiGoldragon/gascity/internal/orders/order.go:159-185`).

## Recommendation table

| Action | Mechanism | Disruption | Cite |
|---|---|---|---|
| Update gc now | `~/.nix-profile/bin/gc supervisor stop --wait && ~/.nix-profile/bin/gc supervisor install` | Supervisor down during stop/install; active sessions interrupted/stopped/killed; managed Dolt stops and restarts; beads/mail persist | `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:341-345`, `/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:2020-2070`, `/git/github.com/LiGoldragon/gascity/cmd/gc/beads_provider_lifecycle.go:446-466`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1439-1462` |
| Update gc after new unit is installed | `~/.nix-profile/bin/gc supervisor install` warm refresh | Short supervisor/API restart; agent sessions preserved/re-adopted; workspace proxy services close/restart | `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor_lifecycle.go:1351-1438`, `/git/github.com/LiGoldragon/gascity/cmd/gc/cmd_supervisor.go:720-758`, `/git/github.com/LiGoldragon/gascity/cmd/gc/city_runtime.go:2026-2044` |
| Run orchestrator via gc | `[[service]] kind="proxy_process"` only if orchestrator listens on `GC_SERVICE_SOCKET` and is an HTTP service | gc owns process lifecycle; restart after crash on service tick; exposed privately under `/svc/orchestrator` unless publication says otherwise | `/git/github.com/LiGoldragon/gascity/internal/config/service.go:148-156`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:199-215`, `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:137-154` |
| Run orchestrator as generic daemon | systemd user unit | External lifecycle owner; not visible to `gc service`; appropriate when no HTTP Unix-socket service contract exists | `/git/github.com/LiGoldragon/gascity/internal/workspacesvc/proxy_process.go:271-337`, `/git/github.com/LiGoldragon/gascity/internal/orders/order.go:159-185` |
