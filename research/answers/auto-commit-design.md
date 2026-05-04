# cr-dmef91 (auto-commit design)

## Headline

Gas City does not currently have a `gc sling`-level write sandbox or a Beads-level
working-set ledger; sling routes work by metadata and session config sets a
`work_dir`, while Beads close hooks and Gas City `bead.closed` events carry bead
JSON snapshots, not git diffs or file attribution
(`/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:69-88`,
`/git/github.com/gastownhall/gascity/internal/config/config.go:1589-1592`,
`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:46-55`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:119-124`).
The practical near-term design is a committer worker that is passed one bead id
and one recorded `metadata.work_dir`, checks `git -C "$work_dir" status
--porcelain`, commits that worktree with `<bead-id>: <short-title>`, records the
commit, and refuses ambiguous shared-dirty-worktree cases; stronger isolation
should come from bead-scoped worktrees and Codex workspace-write settings rather
than from `gc sling` itself
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:50-71`,
`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:95-102`,
`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1053-1065`,
`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1200-1245`).

## 1. Sandbox spawning

### What `gc sling` does

`gc sling` is a routing command: its help text says it routes a bead, formula,
or text item to a session config or agent by the target's `sling_query`
(`/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:69-88`). Its flags are
formula/routing/workflow flags such as `--formula`, `--nudge`, `--merge`,
`--on`, `--dry-run`, `--no-formula`, and scope flags; there is no flag for a
writable root, path allowlist, path denylist, or file allowlist
(`/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:120-133`).

The typed sling request contains `BeadID`, `Target`, `Metadata`, `WorkDir`,
`Env`, and `Force`; it has no sandbox or path-policy field
(`/git/github.com/gastownhall/gascity/internal/sling/sling.go:90-98`). In the
core finalize path, Gas City computes a rig directory and passes it as
`WorkDir` to the router, or runs the shell `sling_query` there
(`/git/github.com/gastownhall/gascity/internal/sling/sling_core.go:327-356`).

For normal routing, the CLI router sets `gc.routed_to=<target>` on the bead; for
custom routing, it runs the agent's `sling_query`
(`/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:500-520`). The config
comments say the default `sling_query` is
`bd update {} --set-metadata gc.routed_to=<qualified-name>` and that routing is
metadata-based, with reconciler and `scale_check` deciding when sessions are
created
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1690-1700`,
`/git/github.com/gastownhall/gascity/internal/config/config.go:1970-1988`).

Conclusion: `gc sling` cannot currently say "code-writer may only write
`src/`" because the sling path does not carry a writable-path policy; it only
routes the bead to a target and maybe runs a custom `sling_query`
(`/git/github.com/gastownhall/gascity/cmd/gc/cmd_sling.go:120-133`,
`/git/github.com/gastownhall/gascity/internal/sling/sling.go:90-98`).

### What is configurable per agent

`pack.toml`/agent config can set an agent identity directory and a separate
session working directory; `work_dir` overrides the session working directory,
resolves relative paths against the city root, and supports the same template
placeholders as session setup
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1586-1592`).

Per-agent config also covers provider selection, start command, args, env, and
provider option defaults
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1614-1638`).
It can run `pre_start`, `session_setup`, `session_setup_script`,
`session_live`, and copy an `overlay_dir` into the agent working directory
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1599-1602`,
`/git/github.com/gastownhall/gascity/internal/config/config.go:1728-1750`).
It can also set `work_query`, `sling_query`, idle behavior, and default sling
formula
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1677-1701`,
`/git/github.com/gastownhall/gascity/internal/config/config.go:1774-1777`).

Session creation persists `work_dir` into session metadata when present
(`/git/github.com/gastownhall/gascity/cmd/gc/session_beads.go:880-912`), and the
session manager later exposes that metadata as `Info.WorkDir`
(`/git/github.com/gastownhall/gascity/internal/session/manager.go:1242-1254`).
The resolved worker runtime also carries `WorkDir`
(`/git/github.com/gastownhall/gascity/cmd/gc/worker_handle.go:274-297`).

### What the Codex CLI exposes

Codex has a `--model` flag and a `--sandbox` flag in its shared CLI options
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:19-21`,
`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:36-39`).
It also has `--cd` to set the working root and `--add-dir` to grant additional
writable directories
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:50-56`).

Codex's simple CLI sandbox modes are `read-only`, `workspace-write`, and
`danger-full-access`; advanced workspace-write options are available through
`-c` overrides or `config.toml`
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/sandbox_mode_cli_arg.rs:1-7`,
`/git/github.com/openai/codex/codex-rs/utils/cli/src/sandbox_mode_cli_arg.rs:12-26`).
In the protocol, `workspace-write` is read-only plus write access to the current
working directory and configured extra writable roots
(`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1053-1065`).
Its writable-root computation includes explicitly configured roots, cwd, `/tmp`
unless excluded, and `$TMPDIR` unless excluded
(`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1200-1269`).

This means Codex can approximate "only edit `src/`" by starting with `--cd src`
and `--sandbox workspace-write`, accepting that cwd becomes `src` and temp dirs
are still writable unless excluded by advanced config
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:50-56`,
`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1200-1269`).
Codex does not provide a simple `--sandbox workspace-write --only src/` mode
while cwd remains the repo root in the cited CLI surface; extra writable roots
widen access rather than narrowing root access
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:50-56`,
`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1053-1065`).

Gas City's built-in Codex provider defaults to unrestricted mode, model
`gpt-5.5`, and effort `xhigh`
(`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:150-157`).
Its permission choices map `suggest` to read-only, `auto-edit` to `--full-auto`,
and `unrestricted` to bypass approvals and sandbox
(`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:168-183`).
Its exposed `sandbox` option choices are only blank/default, `read-only`, and
`network-off`; `workspace-write` and writable-root tuning are not in the built-in
Gas City option schema
(`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:196-204`).

### Closest thing today

The closest source-backed pattern today is: give each work bead its own git
worktree, record that path on the bead as `metadata.work_dir`, run the session
with that `work_dir`, and optionally launch the provider inside a container or
Codex workspace-write sandbox
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-scoped-work.toml:86-99`,
`/git/github.com/gastownhall/gascity/cmd/gc/session_beads.go:910-912`,
`/git/github.com/openai/codex/codex-rs/protocol/src/protocol.rs:1053-1065`).
The Docker session script mounts the configured `work_dir` into the container
and starts the container with `-w "$work_dir"`; that is an external containment
tool, not a `gc sling` writable-path policy
(`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:248-260`,
`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:297-313`).

## 2. Post-close change attribution

Beads close hooks run after a successful close mutation: `CloseIssue` calls the
inner close and then fires `EventClose`
(`/git/github.com/gastownhall/beads/internal/storage/hook_decorator.go:108-115`).
Hook execution is asynchronous and best-effort; hook failures do not block the
triggering operation
(`/git/github.com/gastownhall/beads/internal/hooks/hooks.go:47-71`).
On Unix, the hook process is invoked as `hookPath issue.ID event`, with the JSON
marshaled issue on stdin
(`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:46-55`).

The Beads issue JSON has id, title, description, notes, status, priority,
assignment, timestamps, external refs, arbitrary metadata, labels,
dependencies, comments, and messaging fields; the source type does not define a
git diff, file list, base commit, touched paths, or working-set field
(`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`). Metadata is
explicitly arbitrary JSON for extension points such as tool annotations and file
lists, so file data can be added by conventions, but Beads itself is not
tracking it as a built-in close payload field
(`/git/github.com/gastownhall/beads/internal/types/types.go:56-59`).

Gas City's installed `on_close` hook wraps the bead JSON as `{"bead": ...}` and
emits `bead.closed` with subject `$1` and message `title`
(`/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:34-55`). The generic event
envelope has `seq`, `type`, `ts`, `actor`, `subject`, `message`, and `payload`
(`/git/github.com/gastownhall/gascity/internal/events/events.go:99-108`). The
typed `bead.*` payload is a full bead snapshot
(`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:119-124`),
and its decoded fields are id, title, status, type, priority, created_at,
assignee, from, parent, ref, needs, description, labels, metadata, and
dependencies
(`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

Therefore `gc events bead.closed` can identify which bead closed and can carry
`metadata.work_dir` if it was set before close, but it cannot by itself identify
which files changed or which diff belongs to that bead
(`/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:45-50`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

`mol-polecat-commit.toml` is the direct-commit reference. It checks
`metadata.work_dir`, creates `worktrees/{{issue}}` when absent, and records
`work_dir` immediately on the bead
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:50-71`).
Before exit, it runs `git status --porcelain`, commits any remaining work with a
message containing the issue id, pushes with rebase retry, removes the worktree,
unsets `work_dir`, writes notes, and closes the bead
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:95-138`).

The worktree-per-bead pattern means a committer should run git commands inside
the recorded worktree, for example `git -C "$work_dir" add -A`, rather than
trying to `git add work_dir/` from the parent checkout; the formulas create the
worktree with `git worktree add` and then `cd "$WORKTREE_PATH"`
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-scoped-work.toml:86-99`,
`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:62-71`).

## 3. Multi-bead separation

If two beads write to the same checkout and then close close together, the
source I read has no durable per-bead file ledger that can split a shared dirty
worktree after the fact; Beads emits issue JSON, Gas City wraps bead snapshots,
and neither payload has diff/file fields
(`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

The source-backed separation pattern is one worktree per bead. The Gastown
feature-branch formula checks `metadata.work_dir`, creates
`worktrees/{{issue}}`, and records it on the work bead
(`/git/github.com/gastownhall/gascity/examples/gastown/packs/gastown/formulas/mol-polecat-work.toml:59-82`).
It explicitly says worktrees are scoped to the work bead, old worktrees can be
recovered independently, multiple orphaned worktrees can coexist, and cleanup is
per bead
(`/git/github.com/gastownhall/gascity/examples/gastown/packs/gastown/formulas/mol-polecat-work.toml:84-87`).

Kit's PR-per-bead variant also carries a metadata contract for worktree, branch,
target, PR URL, PR number, and rejection reason
(`/git/github.com/bmt/gascity-explore/packs/kit/formulas/mol-polecat-pr.toml:8-18`).
It requires a final `git status --porcelain`, commits leftover work, pushes the
branch, creates a PR with `Resolves {{issue}}`, records metadata, assigns the
bead to the steward, and nudges the steward
(`/git/github.com/bmt/gascity-explore/packs/kit/formulas/mol-polecat-pr.toml:50-122`).

Overlapping edits are therefore best handled as normal git branch/worktree
conflicts: separate worktrees produce separate commits or PR branches, and
conflicts are resolved by rebase/merge/review flows rather than by guessing
which shared uncommitted file belongs to which bead
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:104-123`,
`/git/github.com/gastownhall/gascity/examples/gastown/packs/gastown/formulas/mol-polecat-work.toml:205-218`).

Recommendation: a post-close committer should refuse to auto-commit a shared
dirty checkout when more than one active/recent bead points at the same
`work_dir` or when `work_dir` is missing, because the cited payloads do not
contain enough source data to attribute files safely
(`/git/github.com/gastownhall/beads/internal/types/types.go:56-59`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

## 4. Near-term committer-agent shape

Minimum input: bead id, rig root, and a trustworthy work directory. The bead id
comes from the hook argv or event subject
(`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:52-55`,
`/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:45-50`), and the work
directory should come from `metadata.work_dir`, the convention used by the core
and Gastown formulas
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-scoped-work.toml:90-95`,
`/git/github.com/gastownhall/gascity/examples/gastown/packs/gastown/formulas/mol-polecat-work.toml:61-82`).

Algorithm:

1. Load `bd show <bead-id> --json` and read title plus `metadata.work_dir`; the
   same source pattern is used by existing formulas
   (`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:50-53`).
2. Refuse if `metadata.work_dir` is empty unless the mayor explicitly asks for a
   shared-checkout commit, because Beads and Gas City close payloads do not carry
   file attribution
   (`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`,
   `/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).
3. Run `git -C "$work_dir" status --porcelain`; this is the same final
   clean-state primitive used by direct-commit and PR formulas
   (`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:95-102`,
   `/git/github.com/bmt/gascity-explore/packs/kit/formulas/mol-polecat-pr.toml:50-57`).
4. If clean, update notes with "no changes to commit" and exit; existing formula
   exit criteria also require clean state before close/exit
   (`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-base.toml:238-247`).
5. If dirty, acquire a lock keyed by canonical `work_dir`, run `git -C
   "$work_dir" add -A`, commit with `<bead-id>: <short-title>`, and record the
   resulting commit SHA in notes or metadata; existing formulas already commit
   all leftover dirty work and include the issue id in commit messages
   (`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-base.toml:173-177`,
   `/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:95-102`).
6. Do not remove the worktree in the generic committer unless the caller chose a
   direct-commit lifecycle; the direct-commit formula removes the worktree and
   unsets `work_dir` only as part of its own complete lifecycle
   (`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:126-138`).

Trigger choice:

The most exact automatic trigger is Beads `on_close`, because it receives the
issue id and issue JSON directly
(`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:46-55`), but it
is asynchronous and best-effort
(`/git/github.com/gastownhall/beads/internal/hooks/hooks.go:47-71`), so failures
must leave a visible note/reopen/escalation bead rather than assuming the close
was blocked.

Gas City `bead.closed` events are useful for controller-level wakeups, but the
order event trigger only checks that matching events exist after a cursor and
returns a count/reason
(`/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-195`).
The exec order environment includes store/rig/pack variables, not the matched
event payload or bead id
(`/git/github.com/gastownhall/gascity/cmd/gc/order_store.go:91-128`), and the
exec dispatcher runs the configured shell command at the scope root
(`/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:339-369`).
Therefore an event-order committer would need to poll events/beads and maintain
its own cursor to avoid races.

Mayor-explicit triggering remains valuable as a recovery and review path because
it can name the bead id and work_dir directly; that requirement follows from the
fact that neither Beads nor Gas City event payloads include file attribution
(`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

Failure recovery:

If the committer commits the wrong files, recovery is normal git recovery:
create a revert/fix commit or reset before push if still local. The committer
should store `commit_sha` and dirty-status output on the bead because the Beads
metadata field is explicitly for extension-point data
(`/git/github.com/gastownhall/beads/internal/types/types.go:56-59`) and existing
formulas already use metadata to persist work state
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:68-71`).

## 5. `pack.toml` model config

Yes: per-agent `[agent.option_defaults]` can set `model` when the provider's
options schema declares a `model` option. The `Agent` struct documents
`option_defaults` as provider schema default overrides and gives an example with
`model`
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1634-1638`).
Defaults are validated against the schema: unknown keys and values outside the
declared choices are errors
(`/git/github.com/gastownhall/gascity/internal/config/options.go:21-34`).

Defaults are merged schema default -> provider default -> agent default
(`/git/github.com/gastownhall/gascity/internal/config/options.go:37-64`), and
agent defaults are merged on top of the resolved provider's effective defaults
(`/git/github.com/gastownhall/gascity/internal/config/resolve.go:648-655`).
Session launch starts with the resolved provider command, merges effective
defaults plus explicit overrides, resolves those options to flag args, strips
schema-managed old flags, and appends the selected flags
(`/git/github.com/gastownhall/gascity/internal/config/launch_command.go:21-55`,
`/git/github.com/gastownhall/gascity/internal/config/options.go:111-155`).

For the built-in Codex provider, the `model` choices currently exposed by Gas
City are blank/default, `gpt-5.5`, `o3`, and `o4-mini`; those choices map to
`--model` flag args where nonblank
(`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:185-194`).
That means `option_defaults = { model = "o4-mini" }` is accepted by current Gas
City built-in Codex schema, while `model = "gpt-5.4-mini"` is not accepted
unless the Codex provider schema is extended or replaced
(`/git/github.com/gastownhall/gascity/internal/config/options.go:24-34`,
`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:185-194`).

Important caveat: `agent.start_command` is an escape hatch; provider resolution
returns a `ResolvedProvider` built from the raw start command and bypasses normal
provider option machinery
(`/git/github.com/gastownhall/gascity/internal/config/resolve.go:22-43`).
If a city uses `start_command` to call Codex directly, it should pass raw Codex
CLI flags such as `--model` and `--sandbox` itself
(`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:19-21`,
`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:36-56`).

Current Codex source contains a bundled model catalog and remote-refresh path.
If a model is explicitly provided, the models manager returns it directly;
otherwise it selects a default from available models
(`/git/github.com/openai/codex/codex-rs/models-manager/src/manager.rs:134-149`).
The manager can fetch remote models, apply them over bundled models, and persist
cache
(`/git/github.com/openai/codex/codex-rs/models-manager/src/manager.rs:301-334`).
The bundled model file is the fallback loaded from source
(`/git/github.com/openai/codex/codex-rs/models-manager/src/manager.rs:390-400`).

Cheap/current Codex model evidence from the bundled catalog:

1. `gpt-5.4-mini` is explicitly described as "Small, fast, and cost-efficient
   model for simpler coding tasks" and supports low/medium/high/xhigh reasoning
   efforts
   (`/git/github.com/openai/codex/codex-rs/models-manager/models.json:193-221`).
2. `gpt-5.4` is "Strong model for everyday coding" and is listed above
   `gpt-5.4-mini` by priority
   (`/git/github.com/openai/codex/codex-rs/models-manager/models.json:111-139`).
3. `gpt-5.3-codex` is "Coding-optimized" and its bundled `upgrade` points to
   `gpt-5.4`
   (`/git/github.com/openai/codex/codex-rs/models-manager/models.json:276-307`).
4. Codex config tracks acknowledged model migrations as old-to-new slug mappings
   (`/git/github.com/openai/codex/codex-rs/config/src/types.rs:711-718`), and
   tests include migration UI examples involving `gpt-5.1-codex-mini`,
   `gpt-5.1-codex-max`, `gpt-5.2-codex`, and an older
   `gpt-5-codex-mini -> gpt-5.1-codex-mini` path; I did not find the exact
   `gpt-5.1-codex-mini -> gpt-5.3-codex` mapping in the inspected source
   (`/git/github.com/openai/codex/codex-rs/tui/src/model_migration.rs:430-442`,
   `/git/github.com/openai/codex/codex-rs/tui/src/model_migration.rs:516-526`).

Lowest-cost recommendation for "echo task + close bead" tests: use Codex
`gpt-5.4-mini` at low effort when invoking Codex directly, because the Codex
catalog labels it cost-efficient and supports low effort
(`/git/github.com/openai/codex/codex-rs/models-manager/models.json:193-221`).
Inside current Gas City's built-in Codex provider schema, either use the older
available `o4-mini` choice or extend/override the provider schema to include
`gpt-5.4-mini`; the validation code will reject undeclared option-default
values
(`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:185-194`,
`/git/github.com/gastownhall/gascity/internal/config/options.go:24-34`).

## 6. Reference patterns

`mol-polecat-commit.toml`: direct-commit, commit-before-close. It creates or
reuses a bead-scoped worktree, records `metadata.work_dir`, verifies dirty state
with `git status --porcelain`, commits remaining work, pushes with retry, cleans
the worktree, unsets `work_dir`, updates notes, closes the bead, and exits
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:32-85`,
`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:87-151`).

`mol-polecat-pr.toml`: PR-per-bead. It requires test/quality gate, final
`git status --porcelain`, branch push, PR creation, metadata update, steward
assignment, steward nudge, wisp burn, and exit
(`/git/github.com/bmt/gascity-explore/packs/kit/formulas/mol-polecat-pr.toml:1-29`,
`/git/github.com/bmt/gascity-explore/packs/kit/formulas/mol-polecat-pr.toml:31-122`).

Beads `on_close`: exact bead id plus issue JSON on stdin, but async and
best-effort, with no built-in diff/file fields in the issue type
(`/git/github.com/gastownhall/beads/internal/hooks/hooks.go:47-71`,
`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:46-55`,
`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`).

Kit steward: the steward is an on-demand patrol/router for PR lifecycle, not a
code fixer or merger; it checks assigned/routed work, routes PRs based on state,
and hands clean PRs toward human review
(`/git/github.com/bmt/gascity-explore/docs/steward-role.md:1-31`,
`/git/github.com/bmt/gascity-explore/docs/steward-role.md:38-78`). The Kit
steward agent itself uses a rig-scoped worktree work_dir and a pre-start
worktree setup command
(`/git/github.com/bmt/gascity-explore/packs/kit/agents/steward/agent.toml:1-8`).
The steward prompt fragment says the patrol loop checks assigned work, checks
routed work, processes work, sleeps, and drains/exits when empty
(`/git/github.com/bmt/gascity-explore/packs/kit/template-fragments/propulsion-steward.template.md:11-26`).

## Near-term recommendation

Build the first committer as an explicit or hook-invoked worker, not as a new
general sandbox system. It should accept one bead id, load the bead JSON, require
`metadata.work_dir`, lock that worktree, run `git -C "$work_dir" status
--porcelain`, and if dirty run `git -C "$work_dir" add -A && git -C "$work_dir"
commit -m "<bead-id>: <short-title>"`; then record `commit_sha` and the status
summary on the bead. This design follows the existing worktree/metadata/status
pattern in the core formulas
(`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-scoped-work.toml:86-99`,
`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:50-71`,
`/git/github.com/gastownhall/gascity/internal/bootstrap/packs/core/formulas/mol-polecat-commit.toml:95-138`).

Use two triggers: explicit mayor/orchestrator command for the minimum viable
path, and optional Beads `on_close` for automatic capture once failure handling
is in place. The exact hook has the bead id and JSON
(`/git/github.com/gastownhall/beads/internal/hooks/hooks_unix.go:46-55`), but it
is async best-effort
(`/git/github.com/gastownhall/beads/internal/hooks/hooks.go:47-71`), so automatic
mode must write visible failure notes or reopen/escalate. Avoid relying on
`gc order on=bead.closed` alone for exact attribution unless the committer also
polls the event log and tracks its own cursor, because the order trigger source
only reports that matching events exist and the exec env does not include the
matched event payload
(`/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-195`,
`/git/github.com/gastownhall/gascity/cmd/gc/order_store.go:91-128`).

Refuse ambiguous cases. If `metadata.work_dir` is missing, if two candidate
beads share the same dirty worktree, or if the worktree is not a git worktree,
the committer should leave notes and require mayor review. The source does not
provide a hidden Beads/Gas City working-set ledger that could split shared dirty
files after close
(`/git/github.com/gastownhall/beads/internal/types/types.go:14-80`,
`/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`).

For sandbox hardening after the committer lands, keep the worktree-per-bead
pattern and add provider/session configuration: `work_dir` per agent/session in
Gas City, Codex `--sandbox workspace-write` plus `--cd <work_dir>` when using
Codex directly, and optional container session scripts where external isolation
is desired
(`/git/github.com/gastownhall/gascity/internal/config/config.go:1589-1592`,
`/git/github.com/openai/codex/codex-rs/utils/cli/src/sandbox_mode_cli_arg.rs:12-26`,
`/git/github.com/openai/codex/codex-rs/utils/cli/src/shared_options.rs:50-56`,
`/git/github.com/gastownhall/gascity/scripts/gc-session-docker:248-313`).
