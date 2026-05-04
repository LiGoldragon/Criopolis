# cr-ccwj6f (gc model support)

## Answer

Partially supported, but only on development `main`: upstream Gas City added
`gpt-5.3-codex-spark` to the built-in Codex model schema after the locally
installed `gc` pin. Upstream still does not include `gpt-5.4`,
`gpt-5.4-mini`, or `gpt-5.4-nano` as built-in Codex `option_defaults.model`
choices.

## 1. Latest released/development version

- Latest release: `v1.0.0`, published 2026-04-21:
  https://github.com/gastownhall/gascity/releases/tag/v1.0.0
- Current development head checked remotely: `main` at
  `dfe314b3eec06f545dd5ccb0b1d9d42c18698b5f`, authored
  2026-05-04T08:46:37Z, `fix: protect active test dolt cleanup roots (#1660)`.
- Local `gc`: `1.0.0-unstable-2026-05-02` from
  `/nix/store/wwn4c45zkqqxy3gjjljdlv1rf8fpqzfb-gascity-1.0.0-unstable-2026-05-02/bin/gc`.
- Local Nix package pin: `/git/github.com/LiGoldragon/gascity-nix/flake.nix:15-16`
  pins version `1.0.0-unstable-2026-05-02` and Gas City rev
  `4be4d44be6df85b1c8b7f20c4afcc98fc1713dcc`.
- Remote `main` is 77 commits ahead of that local pin. Recent examples after
  2026-05-02 include `a4ccb533` (provider defaults cleanup, PR #1515),
  `2fc813ef` (OpenCode/Gemini worker conformance, PR #1628), and
  `dfe314b3` (Dolt cleanup roots, PR #1660).
- The main changelog has an `[Unreleased]` section, but the visible model note
  there is Claude `opus` alias movement, not Codex Spark:
  https://github.com/gastownhall/gascity/blob/main/CHANGELOG.md#L8-L47

## 2. Codex provider schema

- Per-agent `option_defaults` is still the right surface:
  remote `internal/config/config.go:1691-1695` says agent
  `OptionDefaults` override provider effective defaults and gives
  `model = "sonnet"` as the example shape.
- Values are schema-checked: remote `internal/config/options.go:21-31`
  rejects option_defaults values that are not declared choices; remote
  `internal/config/options.go:66-104` turns the selected choice into CLI args.
- Local source at the installed pin has built-in Codex defaults
  `model = "gpt-5.5"` and `effort = "xhigh"`, with model choices:
  `""`, `gpt-5.5`, `o3`, `o4-mini`
  (`/git/github.com/gastownhall/gascity/internal/worker/builtin/profiles.go:150-194`).
- Remote `main` adds exactly one model choice:
  `gpt-5.3-codex-spark`.
  Current remote choices are `""`, `gpt-5.5`, `gpt-5.3-codex-spark`, `o3`,
  and `o4-mini`:
  https://github.com/gastownhall/gascity/blob/dfe314b3eec06f545dd5ccb0b1d9d42c18698b5f/internal/worker/builtin/profiles.go#L150-L195
- The adding commit is `a4ccb533` / PR #1515, merged 2026-05-03. Its patch
  adds `gpt-5.3-codex-spark` to the Codex model choices:
  https://github.com/gastownhall/gascity/pull/1515
- `gpt-5.4` appears in provider-inheritance docs/tests as a custom-provider
  args example, not as a built-in Codex schema choice:
  https://github.com/gastownhall/gascity/blob/dfe314b3eec06f545dd5ccb0b1d9d42c18698b5f/engdocs/design/provider-inheritance.md#L94-L99
- Exact code search for `gpt-5.4-mini` in `gastownhall/gascity` returned no
  hits.

## 3. PRs/issues/roadmap

- Merged PR #1171 made `gpt-5.5` the built-in Codex default and added it as a
  schema choice: https://github.com/gastownhall/gascity/pull/1171
- Merged PR #1515 added Codex Spark and cleaned up provider defaults:
  https://github.com/gastownhall/gascity/pull/1515
- Open issue #1474 proposes `gc sling --model` for one-off dispatch overrides,
  but it does not propose adding `gpt-5.4-mini`/`gpt-5.4` to the built-in Codex
  schema: https://github.com/gastownhall/gascity/issues/1474
- I did not find an open PR or issue specifically adding built-in
  `gpt-5.4-mini`, `gpt-5.4`, or `gpt-5.4-nano` to the Codex schema.

## 4. Recommendation

- If the target is the newer mini-class Codex option that upstream Gas City
  already supports, upgrade to a development commit at or after
  `a4ccb533` (minimum) or current `main` `dfe314b3` (latest checked). There is
  no newer stable release than `v1.0.0`, so this is a Nix pin bump rather than a
  release upgrade.
- Local upgrade path is the `gascity-nix` flake: bump
  `/git/github.com/LiGoldragon/gascity-nix/flake.nix:15-29` from rev
  `4be4d44...` to `dfe314b3...` or at least `a4ccb533...`, update the
  `fetchFromGitHub` hash and `vendorHash`, rebuild, and reinstall the profile.
- If staying on the current installed binary, the built-in schema model choices
  are `gpt-5.5`, `o3`, and `o4-mini`; for cheap echo-style tests the schema
  answer is still `o4-mini` via `[agent.option_defaults] model = "o4-mini"`.
  Note that OpenAI's current public model catalog marks `o4-mini` deprecated:
  https://developers.openai.com/api/docs/models/all
- Official OpenAI docs currently position `gpt-5.4-mini`/`gpt-5.4-nano` as the
  lower-cost current family, and the Codex rate card prices `GPT-5.4-Mini`
  while listing `GPT-5.3-Codex-Spark` as research preview with non-final rates:
  https://developers.openai.com/api/docs/models and
  https://help.openai.com/en/articles/20001106-codex-rate-card
- Therefore: use upstream Gas City `main` if `gpt-5.3-codex-spark` is acceptable;
  if the requirement is specifically stable-priced `gpt-5.4-mini`, Gas City
  still needs a schema update.
