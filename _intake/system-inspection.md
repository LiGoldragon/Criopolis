# System inspection — where to read the gas-city we are running on

*Pointer file. Make this visible to the council and to any other
agent that needs to understand what gas-city is and how it works.*

---

## What we are running

Binary: `/home/li/.nix-profile/bin/gc` →
`/nix/store/wwn4c45zkqqxy3gjjljdlv1rf8fpqzfb-gascity-1.0.0-unstable-2026-05-02/bin/gc`

The `unstable-2026-05-02` suffix is the build date of the nix
package, not a tag. There is no `gc --version` flag on this build;
correlate via the nix store path's date suffix.

## Source we are running

Cloned source: `/git/github.com/gastownhall/gascity/`

Current HEAD as of 2026-05-02:
- `4be4d44b fix(workflow): close source chains across stores (#1519)`
- Commit date: `2026-05-02`

The clone HEAD and the nix-built binary share the same date; treat
the cloned source as the readable form of what is actually executing
unless and until the nix package is rebuilt off a newer commit.

## Adjacent sources

- `/git/github.com/gastownhall/beads/` — the beads CLI (`bd`); also
  invoked via `gc bd`.
- `/git/github.com/LiGoldragon/gascity-nix/` — Li's own nix
  packaging of gascity; this is what produces the `gascity-1.0.0-…`
  derivation we run from.

## How to keep this current

When the running build changes (Li bumps gascity-nix's input commit):
- The nix store path's date suffix will change.
- `git pull` on the gastownhall/gascity clone, then update this doc.
- A small mismatch in dates (e.g., the running build is one or two
  days behind HEAD) is expected during normal development; flag
  larger gaps.

## Adjacent ecosystem (provisional, awaiting research)

- **Wasteland** — per Li, a platform that lets gas-cities in
  gastown communicate with each other. Source / docs to be located
  in upcoming research bead.
- **Other gas-cities** — community examples (their structure,
  agent rosters, infrastructure choices) are research material;
  bead pending.

---

*This is a pointer, not a manual. Read the source. Reference this
file by path when asking the council or another agent to investigate
something gascity-shaped.*
