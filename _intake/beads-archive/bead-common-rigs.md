== Background ==

The city wants to grow. Concrete trigger: ~/git/bibliography (~100
authors of source texts; classical astrology + category theory +
related) is to be renamed `library` and integrated as a place we can
also WRITE to (e.g., to add books fetched via the `annas` CLI).

The current workspace boundary rule (now in every prompt template)
says: **write only inside /home/li/philosophy-city/.** Rigs are the
Gas City construct for managed-writable areas; this rule needs to
extend to "city + registered rigs."

You are answering THREE small architectural questions. This is a
short bead — sharp positions, no philosophy.

== Specific deliverables ==

**A. Where does library live?** (~100 words)

Two options (or propose a third):
1. Move ~/git/bibliography → ~/philosophy-city/library/, register
   as rig at that path.
2. Leave at ~/git/bibliography (or rename in place to ~/git/library),
   register as rig at that path.

Trade: option 1 keeps everything inside one tree (visual clarity,
single boundary); option 2 keeps repo at canonical ~/git/* alongside
sibling repos (matches existing conventions; no checkout move).

**B. Pack or single agent for rig management?** (~100 words)

Options:
1. Single `librarian` agent. Knows the library; adds books via
   `annas`; maintains catalog; keeps things organized.
2. Pack: e.g., `curator` (proposes additions), `fetcher` (uses
   `annas`), `cataloger` (maintains index).
3. Both: a generic `rig-manager` for any-rig integration plus a
   `librarian` for library-specific work.

Trade: single is cheap, focused, and small; pack lets specialization
form when patterns warrant; "both" hedges complexity.

**C. How does the workspace-boundary rule extend?** (~100 words)

The current single-line rule: "write only inside
/home/li/philosophy-city/." With rigs registered, options:

1. Each prompt template lists every writable rig path explicitly.
2. The rule references "the city + any registered rig" abstractly,
   trusting the agent to query `gc rig list`.
3. A shared config file (e.g., agents/_workspace-boundary.md) is
   sourced into each prompt at materialize time.

Pick one; if you propose option 4, define it.

== Workspace boundary (hard rule) ==

Read anywhere on the filesystem. Write only inside
/home/li/philosophy-city/.

== Cap ==

~400 words.

== How to reply ==

Edit this bead's notes:

    bd update <this-id> --notes "$(cat <<'NOTES'
    A. <answer>
    B. <answer>
    C. <answer>
    NOTES
    )"

Then `bd close <this-id>`. Mayor will mirror to
`/home/li/philosophy-city/_intake/replies/rigs/<seat>.md` and
synthesize.
