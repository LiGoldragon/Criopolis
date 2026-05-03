# pc-ttzm - criome ecosystem workspace brief

Date basis: `date +%Y-%m-%d` returned 2026-05-03. Active cutoff is
2026-04-26; no repo's latest commit was exactly 2026-04-26, so the
active list starts at 2026-04-27. Recent-but-not-active is 2026-04-03
through 2026-04-25.

Scope note: `ghq list -p` points at `/git`, but this bead asked for
`/home/li/git`. The counts and classifications below cover only
`/home/li/git`.

## Answer

- `/home/li/git` contains 86 git repos.
- Active in the last 7 days: 34 repos.
- Recent-but-not-active in the last 30 days: 22 repos.
- Abandoned/empty by this rule: 30 repos.
- The criome ecosystem is alive and split across many sibling repos.
  The canonical map is in `/home/li/git/workspace/docs/workspace-manifest.md`;
  project-wide architecture is in `/home/li/git/criome/ARCHITECTURE.md`.

## Active repositories

- `/home/li/git/AnaSeahawk-website` - personal/living-research website archive; latest 2026-04-27.
- `/home/li/git/CriomOS` - NixOS platform modules consumed through projected horizons and `lojix-cli`; latest 2026-05-03.
- `/home/li/git/CriomOS-emacs` - Emacs distribution for the CriomOS home profile, split from legacy CriomOS; latest 2026-05-01.
- `/home/li/git/CriomOS-home` - standalone Home Manager profile flake for CriomOS; latest 2026-05-03.
- `/home/li/git/CriomOS-lib` - shared constants, helpers, and data for CriomOS and CriomOS-home; latest 2026-05-03.
- `/home/li/git/CriomOS-pkgs` - CriomOS package/overlay axis, separated to preserve pkgs eval caching; latest 2026-05-03.
- `/home/li/git/TheBookOfSol` - Li's writing corpus around the solar framework and related health/esoteric essays; latest 2026-05-01.
- `/home/li/git/arca` - content-addressed filesystem plus privileged writer daemon for artifact storage; latest 2026-05-01.
- `/home/li/git/criome` - state engine around sema: validates signal, writes sema, forwards typed effects; latest 2026-05-01.
- `/home/li/git/criomos-archive` - legacy CriomOS archive still receiving cluster-module/package updates; latest 2026-04-27.
- `/home/li/git/forge` - executor daemon skeleton: links prism, runs nix, writes outputs to arca; latest 2026-05-01.
- `/home/li/git/gascity-nix` - Nix flake packaging Gas City tooling; latest 2026-05-02.
- `/home/li/git/goldragon` - LiGoldragon cluster proposal data for nodes, users, trust, and horizon projection; latest 2026-04-30.
- `/home/li/git/hexis` - managed mutable-config reconciliation tool with per-key lifecycle modes; latest 2026-05-01.
- `/home/li/git/horizon-rs` - horizon schema, type-checking, and projection library/CLI for CriomOS; latest 2026-05-01.
- `/home/li/git/lojix-cli` - current working CriomOS deploy orchestrator, transitional toward forge/signal; latest 2026-05-01.
- `/home/li/git/lojix-cli-v2` - rewrite workspace for Nota-native CriomOS deploys, home deploys, and request loading; latest 2026-05-03.
- `/home/li/git/lore` - curated operational docs and local rules for tools and the sema ecosystem; latest 2026-05-02.
- `/home/li/git/maisiliym` - Maisiliym node proposal data consumed by CriomOS/horizon; latest 2026-04-27.
- `/home/li/git/mentci-egui` - thin egui shell for the mentci criome introspection workbench; latest 2026-05-01.
- `/home/li/git/mentci-lib` - shared application logic for mentci GUI surfaces over criome/sema; latest 2026-05-01.
- `/home/li/git/mentci-tools` - Nix packaging/tools flake for local toolchain packages; latest 2026-04-27.
- `/home/li/git/nexus` - nexus text language spec plus translator daemon from text to signal; latest 2026-05-01.
- `/home/li/git/nexus-cli` - thin CLI client for the nexus daemon; latest 2026-05-01.
- `/home/li/git/nota` - spec for the nota data grammar, a subset of nexus; latest 2026-05-01.
- `/home/li/git/nota-codec` - typed encoder/decoder for nota and nexus dialects; latest 2026-05-01.
- `/home/li/git/nota-derive` - proc-macro derives used by nota-codec users; latest 2026-05-01.
- `/home/li/git/prism` - planned records-to-Rust source projector used by forge; latest 2026-05-01.
- `/home/li/git/sema` - redb-backed record database for typed program structure; latest 2026-05-01.
- `/home/li/git/signal` - base rkyv wire protocol, envelope, IR, and record kinds for criome; latest 2026-05-01.
- `/home/li/git/signal-derive` - schema-introspection proc macro for signal record kinds; latest 2026-05-01.
- `/home/li/git/signal-forge` - layered signal protocol for criome-to-forge effect-bearing verbs; latest 2026-05-01.
- `/home/li/git/substack-cli` - CLI for publishing and managing Substack posts; latest 2026-05-01.
- `/home/li/git/workspace` - meta-repo, devshell, manifest, reports, symlink farm, and integration checks; latest 2026-05-02.

## Recent-but-not-active

- `/home/li/git/annas-mcp` - 2026-04-24.
- `/home/li/git/arbor` - 2026-04-10.
- `/home/li/git/aski` - 2026-04-25.
- `/home/li/git/aski-cc` - 2026-04-03.
- `/home/li/git/aski-core` - 2026-04-20.
- `/home/li/git/askic` - 2026-04-20.
- `/home/li/git/askicc` - 2026-04-20.
- `/home/li/git/astro-aski` - 2026-04-03.
- `/home/li/git/beads` - 2026-04-15.
- `/home/li/git/brightness-ctl` - 2026-04-25.
- `/home/li/git/caraka-samhita` - 2026-04-25.
- `/home/li/git/clavifaber` - 2026-04-25.
- `/home/li/git/corec` - 2026-04-20.
- `/home/li/git/domainc` - 2026-04-19.
- `/home/li/git/nexus-spec-archive` - 2026-04-25.
- `/home/li/git/noesis` - 2026-04-06.
- `/home/li/git/pi-delegate` - 2026-04-03.
- `/home/li/git/semac` - 2026-04-20.
- `/home/li/git/synth-core` - 2026-04-20.
- `/home/li/git/veri-core` - 2026-04-20.
- `/home/li/git/veric` - 2026-04-20.
- `/home/li/git/vscode-aski` - 2026-04-16.

## Abandoned

- 30 abandoned/empty repos under `/home/li/git` by the 30-day rule.
  Three have no commits. Not enumerated here per bead instructions.

## Criome ecosystem map

- `/home/li/git/criome` - active, core. README is minimal, but Cargo
  metadata and `ARCHITECTURE.md` define it as the state engine around
  sema: it receives signal frames over UDS, validates, writes sema, and
  forwards effect-bearing verbs. It deliberately "runs nothing"; forge
  and arca own effects and artifact bytes.
- `/home/li/git/sema` - active, core. The records DB: redb-backed,
  currently pseudo-sema using rkyv-archived Rust values from `signal`.
  A graph record is the database-level compilation unit.
- `/home/li/git/signal` - active, core wire. Binary/rkyv request
  protocol and record-kind surface spoken by criome, nexus, mentci,
  and direct clients.
- `/home/li/git/signal-forge` - active, canonical but skeleton. Narrow
  layered protocol for criome to send build/deploy/store-entry verbs to
  forge.
- `/home/li/git/signal-derive` - active. Proc macro that emits
  compile-time schema descriptors for signal record kinds.
- `/home/li/git/nexus` and `/home/li/git/nexus-cli` - active. Nexus is
  the human-facing text request language and translator daemon; the CLI
  is its thin text client. Text stops at nexus; criome receives signal.
- `/home/li/git/nota`, `/home/li/git/nota-codec`, `/home/li/git/nota-derive`
  - active. Nota is the data grammar and a subset of nexus; codec and
  derives are the runtime/macro implementation used by the ecosystem.
- `/home/li/git/forge` - active, skeleton-as-design. Executor daemon:
  receives effect-bearing signal verbs, links prism, runs nix, and
  deposits outputs through arca.
- `/home/li/git/arca` - active. Content-addressed file/tree store with
  reader library and privileged writer daemon; general artifact storage
  for data that does not fit sema's record shape.
- `/home/li/git/prism` - active, transitional/stub. Records-to-Rust
  projector used by forge's runtime-creation pipeline.
- `/home/li/git/mentci-lib` and `/home/li/git/mentci-egui` - active.
  Human-facing introspection workbench: shared app logic plus thin egui
  shell over criome/sema.
- `/home/li/git/workspace` - active. Meta-repo for devshell, manifest,
  reports, integration checks, and composing daemons into deployable
  NixOS services.
- `/home/li/git/lore` - active. Shared operational docs and local
  conventions used by agents across the sema ecosystem.
- `/home/li/git/CriomOS` - active. NixOS platform for the ecosystem.
  It consumes projected horizons and delegates deployment orchestration
  to lojix.
- `/home/li/git/horizon-rs` - active. The "horizon" component found on
  disk: typed schema and projection from cluster proposal plus viewpoint
  to per-node horizon.
- `/home/li/git/CriomOS-home` - active. The "home" component found on
  disk: Home Manager profile consumed by CriomOS.
- `/home/li/git/CriomOS-lib` - active. Shared CriomOS constants,
  helper functions, and cross-repo data consumed by CriomOS and
  CriomOS-home.
- `/home/li/git/CriomOS-pkgs` - active. Separate pkgs/overlay axis for
  CriomOS eval caching; not a sema core repo but part of the live
  CriomOS deploy axis.
- `/home/li/git/CriomOS-emacs` - active. Emacs profile module split
  out of the old CriomOS home tree.
- `/home/li/git/lojix-cli` - active, transitional. Current working
  deploy orchestrator: projects `goldragon` through horizon-rs and
  invokes CriomOS builds/deploys.
- `/home/li/git/lojix-cli-v2` - active. Rewrite workspace for a
  Nota-native request interface, direct home deploys, and the next
  deployment shape.
- `/home/li/git/goldragon` and `/home/li/git/maisiliym` - active.
  Cluster/node proposal data consumed by horizon/CriomOS/lojix.
- `/home/li/git/criomos-archive` - active despite being an archive.
  Legacy CriomOS tree still receiving support updates for cluster
  modules and packaged tools.
- `/home/li/git/arbor` - recent-but-not-active and marked SHELVED in
  the workspace manifest: prolly-tree versioning over records,
  post-MVP.

## Contradictions / naming notes

- I found no exact `/home/li/git/logix*` repo. The live spelling on
  disk is `lojix-cli` and `lojix-cli-v2`.
- I found no exact `library` repo. There is abandoned `/home/li/git/lib`
  (last commit 2025-06-01; small nixpkgs-lib extension flake), and
  active library repos named by role: `CriomOS-lib`, `mentci-lib`, and
  `arca`'s reader library.
- I found no plain `home` repo. The matching live component is
  `/home/li/git/CriomOS-home`.
- I found no plain `horizon` repo. The matching live component is
  `/home/li/git/horizon-rs`.
- `/home/li/git/criomeWebsite` exists but is abandoned by this rule
  (latest 2026-03-24); it is not part of the active core map.
- Major active repos not in Li's named component list: `workspace`,
  `lore`, `signal*`, `nota*`, `nexus*`, `forge`, `arca`, `prism`,
  `mentci-*`, `CriomOS-*`, `goldragon`, `maisiliym`, `gascity-nix`,
  `hexis`, `substack-cli`, `TheBookOfSol`, and `AnaSeahawk-website`.
