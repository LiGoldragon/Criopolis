# cr-gadncn (gc cascade infrastructure research)

Source trees checked locally:

- `/git/github.com/gastownhall/gascity`
- `/git/github.com/gastownhall/beads`
- `/git/github.com/LiGoldragon/gascity-nix`

The local Nix layer packages `gastownhall/gascity` at `rev = "4be4d44be6df85b1c8b7f20c4afcc98fc1713dcc"` and builds `cmd/gc`; its only source rewrite shown in the package is a shell-shebang patch under `examples/`, so the trigger and prompt behavior below is coming from the Gas City source, not a Nix overlay feature. `/git/github.com/LiGoldragon/gascity-nix/flake.nix:15-29`, `/git/github.com/LiGoldragon/gascity-nix/flake.nix:31-42`.

## Q1: label-filtered event-triggered orders

Status: **not supported as an order trigger condition today.**

The parsed order schema has `Trigger` and `On` for event triggers, but no label/filter field. `Order` defines `Trigger` as one of `cooldown`, `cron`, `condition`, `event`, or `manual`, and defines `On` as the event type to match for event triggers. `/git/github.com/gastownhall/gascity/internal/orders/order.go:13-52`. The TOML decode struct accepts `description`, `formula`, `exec`, `trigger`, legacy `gate`, `interval`, `schedule`, `check`, `on`, `pool`, `timeout`, and `enabled`; it has no label/filter selector. `/git/github.com/gastownhall/gascity/internal/orders/order.go:63-76`. Validation only requires `on` for `trigger = "event"` and performs no label/filter validation. `/git/github.com/gastownhall/gascity/internal/orders/order.go:140-187`.

Runtime trigger evaluation also only filters by event type and cursor. `CheckTriggerWithOptions` dispatches event orders to `checkEvent`. `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:50-67`. `checkEvent` reads the order cursor with `cursorFn(a.ScopedName())`, then calls `ep.List(events.Filter{Type: a.On, AfterSeq: cursor})`; it returns due if any matching events exist and never inspects subject, payload, or bead labels. `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:175-196`.

The event filter type itself has only `Type`, `Actor`, `Since`, and `AfterSeq`, and `ReadFiltered` applies only those fields. `/git/github.com/gastownhall/gascity/internal/events/reader.go:13-19`, `/git/github.com/gastownhall/gascity/internal/events/reader.go:49-75`.

Bead labels do exist in the event payload, but not in the event-trigger filter path. `BeadEventPayload` carries a full bead snapshot; its decoder accepts `labels` and assigns them to `beads.Bead.Labels`, and `bead.created`, `bead.updated`, and `bead.closed` register that payload type. `/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:119-125`, `/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:156-200`, `/git/github.com/gastownhall/gascity/internal/api/event_payloads.go:235-238`. The `bd` close hook emits `bead.closed` with `--subject "$1"` and a wrapped bead JSON payload, but the order trigger path above does not decode that payload. `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:11-16`, `/git/github.com/gastownhall/gascity/cmd/gc/hooks.go:34-55`.

The label usage around event orders is for cursor tracking and duplicate suppression, not for deciding which incoming bead event qualifies. The dispatcher computes the event cursor for an event order before checking the trigger. `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:191-203`. Event-triggered wisps are stamped with `order:<scoped>` and `seq:<headSeq>` after dispatch; failed tracking beads get the same cursor labels. `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:387-391`, `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:457-465`, `/git/github.com/gastownhall/gascity/cmd/gc/order_dispatch.go:512-520`. The cursor reader lists beads by `order:<orderName>` and extracts the max `seq:<N>` label. `/git/github.com/gastownhall/gascity/cmd/gc/cmd_order.go:865-890`, `/git/github.com/gastownhall/gascity/internal/orders/triggers.go:198-212`.

Upstream issue: I found no source-local evidence of a feature issue or implementation for label-filtered event triggers in the checked-out Gas City tree. I am not citing an upstream ticket because I did not find one in local source, docs, or commit messages.

Workaround: use a `condition` trigger or agent loop that asks `bd` for label-filtered ready/list results, then does the cascade work. `bd ready` reads `--label`, `--label-any`, and `--exclude-label`, normalizes them, and stores them in `types.WorkFilter`. `/git/github.com/gastownhall/beads/cmd/bd/ready.go:71-77`, `/git/github.com/gastownhall/beads/cmd/bd/ready.go:100-134`. The ready command registers those flags as AND/OR/exclude label filters. `/git/github.com/gastownhall/beads/cmd/bd/ready.go:712-720`. `bd list` has the same label flag family. `/git/github.com/gastownhall/beads/cmd/bd/list.go:359-363`, `/git/github.com/gastownhall/beads/cmd/bd/list.go:1070-1080`.

## Q2: prompt template include/shared-prefix at spawn

Status: **partially supported.** Gas City supports named Go template fragments and config-driven auto-append, but I found no arbitrary file-include directive such as `include "rules.md"` or a prompt function that reads a plain Markdown file.

Prompt rendering runs only for files ending in `.template.md` or legacy `.md.tmpl`; plain `.md` prompt files are returned raw. `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:19-22`, `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:56-68`.

Shared fragments are loaded before the main prompt template from each pack's `prompts/shared/` and `template-fragments/`, from a sibling `shared/` directory, and from a per-agent `template-fragments/` directory. `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:70-95`. `loadSharedTemplates` reads supported `.template.md` / `.md.tmpl` files from those directories and parses them into the same `text/template.Template`. `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:167-181`. The local PackV2 docs state the explicit in-body syntax as `{{ template "name" . }}` in the `.template.md` prompt. `/git/github.com/gastownhall/gascity/docs/packv2/doc-agent-v2.md:386-399`.

Config-driven append is supported. `[agent_defaults].append_fragments` lists named fragments to auto-append to `.template.md` prompts after rendering. `/git/github.com/gastownhall/gascity/internal/config/config.go:181-186`, `/git/github.com/gastownhall/gascity/internal/config/config.go:1497-1527`. Per-agent `inject_fragments` and `append_fragments` also list named templates to append, and the names must match `{{ define "name" }}` blocks. `/git/github.com/gastownhall/gascity/internal/config/config.go:1770-1790`. Runtime merging layers global/inject fragments, per-agent append fragments, inherited pack defaults, then city-level defaults before calling `renderPrompt`. `/git/github.com/gastownhall/gascity/cmd/gc/template_resolve.go:263-289`.

Auto-append placement is after the rendered prompt body. `renderPrompt` executes the main template, then for each injected fragment does `tmpl.Lookup(name)`, executes it, and writes it after two newlines. `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:96-126`. The architecture note also says `append_fragments` is append-only, does not control in-body placement, and duplicates content if the prompt explicitly references the same fragment. `/git/github.com/gastownhall/gascity/engdocs/architecture/prompt-templates.md:108-116`.

There is no prompt-level arbitrary include function in the renderer. The template function map only registers `cmd`, `session`, and `basename`; no `include`, `readFile`, or equivalent file-loading function is exposed. `/git/github.com/gastownhall/gascity/cmd/gc/prompt.go:259-275`.

This resolves at spawn before the provider runtime starts. Session template resolution renders the prompt and prepends the runtime beacon. `/git/github.com/gastownhall/gascity/cmd/gc/template_resolve.go:263-296`. `templateParamsToConfig` puts the rendered prompt into runtime delivery fields (`PromptSuffix`, `PromptFlag`, or nudge) for `Provider.Start`. `/git/github.com/gastownhall/gascity/cmd/gc/template_resolve.go:552-595`. The prepared start path converts template params to runtime config and calls `handle.StartResolved`; the runtime handle then calls `h.provider.Start(ctx, h.sessionName, startCfg)`. `/git/github.com/gastownhall/gascity/cmd/gc/session_lifecycle_parallel.go:466-474`, `/git/github.com/gastownhall/gascity/cmd/gc/session_lifecycle_parallel.go:1028-1056`, `/git/github.com/gastownhall/gascity/internal/worker/runtime_handle.go:78-95`.

Practical syntax:

```toml
[agent_defaults]
append_fragments = ["operating-rules"]
```

```markdown
{{ define "operating-rules" }}
...shared rules...
{{ end }}
```

Or place `{{ template "operating-rules" . }}` directly in the agent's `.template.md` when in-body placement matters. The loaded-fragment and append behavior is implemented in `renderPrompt` as cited above; arbitrary plain-file include is not.
