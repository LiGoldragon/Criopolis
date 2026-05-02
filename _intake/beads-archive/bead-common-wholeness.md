== Background ==

The forum's previous synthesis lives at /home/li/philosophy-city/keel/.
The corpus said "beauty is the criterion of correctness" but never
enunciated what beauty IS, positively. Mayor's stance.md is operational
("beauty is the diagnostic that the model is incomplete somewhere
unseen") — useful as a stop test but not constitutive.

Li's framing for this round: **a system is not beautiful if it does not
compose into a coherent whole.** Wholeness is the constitutive property
of beauty. The output of this research is a usable JUDGMENT CRITERION
— a way an engineer at midnight can ask "is this design beautiful?"
and get a precise answer.

Apply to programming. Specifically Rust — the current most elegant +
efficient runtime we have. (Criome aims for better. Not yet.)
A system is not beautiful if it is not efficient.

== Sources ==

The library at /home/li/git/bibliography/ (soon `library`, soon a rig
of this city) holds:
- `en/ptolemy/tetrabiblos.pdf` (Loeb / Robbins, Ashmand) — read this
- Category-theoretic tier — Mazzola, Spivak, Zalamea (ancillary; useful
  for theorist seat for the formal-structure mapping)
- Tier 1 classical astrology + Tier 2 modern — adjacent traditions

The library does NOT yet hold:
- Dane Rudhyar (any work — *The Astrology of Personality*, *Person-
  Centered Astrology*, *The Lunation Cycle*, etc.)
- Plato / Socrates dialogues (*Symposium* on beauty, *Timaeus* on
  cosmos as whole, *Phaedrus*)
- Tao Te Ching (Laozi)

For these, invoke training knowledge with explicit citation: book name +
chapter / verse / Stephanus number / section. If your reading is
contested, say so. The librarian agent (forthcoming) will add these to
the library; flag the editions you would want.

Other writers in the same tradition you may invoke if salient: Plotinus
(*Enneads* on the One); Aristotle (*Metaphysics*, *Poetics* on
unity); Heraclitus (the Logos fragments); Pythagoras / harmonia /
musica universalis; Whitehead (*Process and Reality*); Christopher
Alexander (*The Nature of Order* — pattern + life + wholeness in
architecture); Heraclitus, Bohm (*Wholeness and the Implicate
Order*), Henri Bergson, Jung (synchronicity, archetypes), Goethe
(morphology). Cite specifically; do not gesture.

== Workspace boundary (hard rule) ==

Read anywhere on the filesystem. WRITE only inside
/home/li/philosophy-city/. The library rig (forthcoming) will become
writable; for now treat /home/li/git/bibliography/ as read-only.

== Common deliverables (apply through your seat's lens) ==

1. **Quote-anchored bones from the tradition.** 3–5 quotes total. Each
   with full citation (work / book / section / page). The shortest set
   of source claims your enunciation rests on. If a quote is from
   memory, mark it (paraphrase) and give edition+section.

2. **Your enunciation of beauty.** One paragraph. Specific enough to be
   wrong. Rooted in wholeness as the tradition above understands it.
   Not "beauty is in the eye of the beholder." Not "beauty matters."

3. **The criterion.** How does an engineer USE your enunciation to
   judge a piece of Rust code? Concrete — a checklist, a set of
   questions, a measurement procedure, a refactor heuristic. An
   engineer at midnight should be able to apply it without you
   present.

4. **Worked Rust example.** Pick ONE of:
   (a) A Rust idiom you find beautiful; cite + show how your criterion
       confirms it.
   (b) A Rust idiom you find ugly; cite + show how your criterion
       diagnoses it.
   (c) A boundary in keel/boundaries.md and whether wholeness is
       operating there.

5. **Tension with existing keel/.** Where does your enunciation cohere
   with stance.md / form.md / etc., and where does it threaten or
   replace something? Be specific (file + section).

== Cap ==

~1500 words. This is a deeper question than usual; depth is welcome,
padding is not. Sharp positions only.

== How to reply ==

Edit this bead's notes:

    bd update <this-id> --notes "$(cat <<'NOTES'
    <your reply>
    NOTES
    )"

Then `bd close <this-id>`. Mayor will mirror your reply to
`/home/li/philosophy-city/_intake/replies/wholeness/<seat>.md` and
synthesize.
