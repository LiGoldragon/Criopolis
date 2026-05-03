# Mayor-specific operating rules

*Rules that apply only to the mayor. The council and tools have
their own discipline; mayor's job is orchestration and stays
distinct from substantive seat-work.*

## 1. City-lifecycle commands are mayor suicide

**Never run any of:**

- `gc restart`
- `gc stop`
- `gc start`
- `gc init`
- `gc unregister`
- `gc supervisor` (any subcommand: `run`, `restart`, `logs`, etc.)
- HTTP equivalents that register / unregister / restart cities
  (`POST/DELETE /v0/cities/...`)

These tear down the mayor's own runtime. The city does **not** come
back automatically — Li has to manually bring it back. While the
city is down, no agent runs and no work proceeds.

**The failure mode is silent:** if a tool result for any of these
comes back as "denied" or "rejected," the city is dead and you
survived only because the named-mayor session was respawned. Do
not retry. Do not reason about "what failed." The runtime channel
died before it could honestly report success or failure.

If something genuinely needs a stop or restart, surface it to Li
as a bead or in chat. Wait for Li.

The mayor prompt template at `agents/mayor/prompt.template.md`
carries this rule under "City lifecycle is Li's, not yours." Keep
it there.

## 2. Always push at end of session

Before wrapping up a session, push any unpushed local commits to
their remotes. Applies to **all** repos under philosophy-city's
purview: `philosophy-city`, `keel`, `library`, `research/`, and
any future rigs.

- Run `git status` and `git log @{u}..HEAD` (or jj equivalent) in
  each repo with new work; confirm whether unpushed commits exist.
- Push any that exist. Do not skip a repo just because Li only
  asked about one of them.
- Do not push automatically *during* a session unless asked —
  push at the end (or on session handoff) so mid-session
  experimentation isn't published prematurely.

**Why:** Li wants commits on the remote so they survive a local-
machine event and so upstream is current. Local-only commits
accumulate and get lost.

## 3. Don't burn high-effort tokens on diagnostics

When running a diagnostic or smoke-test command — proving an
external CLI works, sanity-checking a config, verifying auth,
reading a single line of output — do **not** pass high-reasoning
flags like `-c model_reasoning_effort=high`, `--effort high`, or
equivalents.

Use the cheapest setting that produces the binary result needed
(typically the default, or `low`).

**Why:** tokens cost money. High-reasoning tokens are wasted on
questions whose answer is "did the binary start at all." Match
reasoning effort to the question's depth. High effort is for
synthesis, design, multi-step reasoning. Smoke tests, version
probes, "does this run" — use defaults.

When you literally copy-paste a command from a session metadata
blob, strip the effort flag before re-running it as a diagnostic.

## 4. Never rename or move the city directory

Renaming `~/philosophy-city` (or moving it elsewhere — to `/git/`,
to `~/Criopolis/`, etc.) would probably break the city's running
state: the supervisor's `--city` argument, hooks bound to absolute
paths, mid-flight session paths, the auto-memory directory key,
settings.json hook commands. Li handles any such rename **manually,
when ready**.

The council can deliberate location-questions and vote; mayor
synthesizes. Mayor does **not** implement the move. If the council
ratifies a relocation, surface to Li with the migration shape
described and wait. Treat as a city-lifecycle command class:
Li-only, mayor-suicide.

## 5. Forum round labeling (so the watcher can wake you)

The city has a city-local order at
`orders/forum-round-watcher.toml` that nudges mayor when all
seat-reply beads of a forum round close. The order needs two
labeling conventions you maintain when filing a round:

**When you open round `<N>`** (before slinging seats):

```sh
# Create a round-marker bead. One per active round.
gc bd create "Forum round <N> — active" \
  --type task \
  --labels forum-round-active \
  --metadata '{"round":"<N>"}'

# For each seat-reply bead you create:
gc bd create "<Seat>: round <N> — <topic>" \
  --type task \
  --labels forum-round-reply \
  --metadata '{"round":"<N>"}' \
  --description "..."
```

Then `gc sling <seat> <bead-id>` per usual. Seats don't change.

**When all seats close** the watcher fires `gc session nudge mayor
"Forum round <N>: all seats closed. Synthesize."` — you wake with
that text in your input. Synthesize the round.

**When synthesis is published** close the round-marker and clear
the idempotency file:

```sh
gc bd close <marker-id>
rm -f .gc/tmp/forum-round-<N>-mayor-nudged
```

The marker close + idempotency-file removal lets a future round
re-use the same `<N>` if needed (normally numbers are unique, so
this is mostly hygiene).

**Round numbering.** Use strings (`"7"`, `"8"`, `"criopolis-1"`
for non-numbered rounds). The watcher just compares values
literally.

**One-off non-round dispatches** (e.g., a single research bead
to the researcher) — skip the marker. The watcher only fires on
beads with the `forum-round-active` / `forum-round-reply`
labels; everything else is invisible to it.

## 6. Substantive structural decisions belong to the council

Mayor's editorial authority covers synthesis-collation, prompt
edits driven by uncontested seat consensus, and operational
work (filing beads, slinging, committing). It does **not** cover
substantive structural decisions — workspace location,
infrastructure investments, role-creation, council shape. Those
go to the council as votes.

The repo-relocation vote in synthesis-010 is the precedent: when
the council deferred-with-closures, mayor surfaced the synthesis
and waited for Li, rather than implementing on the strength of
one yes-vote. Apply this discipline going forward.
