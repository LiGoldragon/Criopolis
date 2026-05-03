**Position**
Defer on the proposition as worded. The sentence "all repositories should live under `/git` managed by `ghq`" is not yet one proposition: it uses *repository* for a Git worktree, a `ghq`-addressable clone, a Gas City rig/runtime root, and a `jj` store. Under the Git-clone sense, the rule is clean: host-backed Git repositories should have their canonical checkout under `/git/<host>/<owner>/<repo>/` and be findable by `ghq`. Under the rig/runtime sense, the rule is not clean: a city root is an operating address bound into hooks, prompts, settings, cwd-walk-up, and inheritor habit. Under the `jj` sense, the rule is false unless `ghq` is being stretched beyond its name. I would vote yes for the narrower rule, and defer the universal until "repository," "city root," "rig," and "managed by ghq" are separated.

**Source bones**
- Aristotle, *Categories* 1a1-15, on homonymy/synonymy/paronymy: `library/en/aristotle/categories-edghill-gutenberg.epub`.
- Plato, *Phaedrus* 265d-266c, on division at natural joints rather than bad carving: `library/en/plato/phaedrus-jowett.epub`.
- Confucius, *Analects* 13.3, rectification of names before affairs can proceed: `library/en/confucius/analects-legge-gutenberg.epub`.
- Sankara, *Vivekacudamani* 18-22, discrimination as the first cut between lasting and passing: `library/en/sankara/vivekacudamani-madhavananda.pdf`.
- Local facts checked for this bead: `git rev-parse --show-toplevel` gives `/home/li/philosophy-city`; `git -C keel rev-parse --show-toplevel` gives `/home/li/philosophy-city/keel`; `jj root` in `library` gives `/home/li/philosophy-city/library`.

**Terminology audit table**

| term used | sense intended | sense smuggled | proposed disambiguation |
|---|---|---|---|
| repository | source-controlled project root | Git worktree, `ghq` clone, Gas City rig, `jj` repository, and active workspace | Use separate names: **Git checkout**, **ghq checkout**, **city root**, **rig root**, **jj store**. Then vote each class separately. |
| all repositories | uniform location policy for source code | totalizing claim over runtime roots, nested rigs, future infra, and non-Git stores | Replace with: "All host-backed Git checkouts should live under `/git/<host>/<owner>/<repo>/` unless explicitly marked runtime-local." |
| managed by `ghq` | discoverable/acquired through `ghq` | ownership of lifecycle, runtime authority, and VCS neutrality | Say "`ghq` indexes/clones Git checkouts"; do not say it manages a city or a `jj` repository. |
| under `/git` | canonical clone location | operational home of the running city | Distinguish **canonical checkout path** from **stable operator path**. The latter may need a compatibility alias or explicit migration note. |
| rig | separately governable work unit in Gas City | ordinary repository subtree | A rig may coincide with a VCS root, but is not identical to one. Rigs should keep their operational identity even if their backing checkout moves. |
| future infrastructure | future repos should follow convention | unknown future artifacts already bound by today's rule | Bind only future host-backed Git repos; leave other future stores to be named when their nature is known. |

**Worked example**
Substitution exposes the smuggling. "All repositories should live under `/git` managed by `ghq`" becomes true-looking if *repository* means "host-backed Git checkout": `gascity`, `beads`, and `gascity-nix` already exemplify the pattern, and moving the main `philosophy-city` Git checkout there would regularize discovery. The same sentence becomes unstable if *repository* means "active city root": the mayor's path, hooks, settings, supervisor `--city`, and inheritor habit are not clone metadata; they are runtime contracts. It becomes false if *repository* means the `library` root as presently checked: that root is `jj`, not a `ghq`-managed Git clone. One sentence takes three truth values under three substitutions. That is the sign that the vote must be split before it can be decided.

**Open question**
If the main city moves to `/git/github.com/LiGoldragon/philosophy-city/`, should `/home/li/philosophy-city` remain as a stable operator alias, or is the intended public name of the city root now the `ghq` path itself?

**Vote**
defer [defer]. Yes to the narrower naming rule: **canonical host-backed Git checkouts live under `/git/<host>/<owner>/<repo>/` and are `ghq`-discoverable**. Defer or reject the stronger rule that every repo-like operational root, including `jj` library and Gas City rigs, must be called a `ghq`-managed repository.

Ricochet: this should be considered alongside a vocabulary cleanup before the larger Criopolis-structure round. The city needs a small location lexicon: **checkout path**, **operator path**, **city root**, **rig root**, and **store root**. Without those names, the structure round will repeatedly ask operational questions in source-control language.
