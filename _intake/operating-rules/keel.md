# Keel — engineering rules contract

*The shape of the keel rewrite, ratified by the council in round 7
(synthesis-011). Keel content does not yet exist; the rewrite begins
when Li authorizes (after the staging city stands up). This file is
the contract every keel section must satisfy when it lands.*

## Three labels

Each section of keel carries one of three labels indicating its
binding force:

| label | force | who can change it |
|---|---|---|
| **keel rule** | binding engineering norm; review can block on it | high council vote or explicit Li decision |
| **keel guideline** | strong default; reviewer flags violations, but justified exceptions pass | high council ratifies; mayor / scribe can clarify wording without changing force |
| **keel practice note** | descriptive convention, example, or current local habit | scribe / mayor may maintain with source note |

The labels mean what they say. A *rule* blocks; a *guideline*
flags; a *practice note* describes. A reviewer who blocks on a
guideline has confused force; a reviewer who only flags a rule has
done the same in the other direction.

## Required shape per keel rule

Every keel rule names six fields. A rule that omits any of these is
not yet a rule; it is decoration.

- **scope** — where this rule applies and where it does not.
- **decision test** — what a reviewer does differently because this
  rule exists. (A rule whose decision test cannot be operationalized
  on a PR is decoration; *Analects* 13.3 — *zhèng míng*.)
- **failure mode** — what the rule prevents and what new burden it
  creates by existing.
- **example** — one accepted case and one rejected case.
- **exception path** — who may waive the rule and what evidence is
  required. (No rule is exception-free; the path is what makes the
  rule honest.)
- **deletion / review condition** — when the rule is reconsidered.
  (No rule is forever; *Patañjali II.31*'s great-vow clause is the
  only kind of rule that holds across all jurisdictions, and even
  that is named, not assumed.)

## Enforcement contract

The high council deliberates substantive engineering decisions
topic-by-topic; mayor synthesizes per established rounds-1-6
discipline; the council ratifies *categories and substantive
changes*. Mayor's editorial authority covers *within-category prose
work*. The boundary between *substantive* and *editorial* is the
upstream cut — likely the round-8 council question (Viveka's
diairesis).

The **code-reviewer role** enforces ratified keel by reading code
against rules cited by line. Reviewer does not invent keel by
enforcement. When review surfaces a repeated issue not covered by
keel, the reviewer opens a rule-question bead — does not adjudicate
inline.

The **code-reviewer role is created concurrently with the first
keel section.** It is the operator-test for keel: a rule the
reviewer cannot operationalize on a PR is decoration, not a rule.
The reviewer's first job is to *refuse* rules whose decision test
cannot be matched to PR-detectable shape.

## Anti-pattern: every-change-voted

Demanding council votes on every keel edit is *over-ceremony*: it
either chokepoints keel (it stops growing) or routes growth through
informal channels (it grows poorly). The council is a *deliberative
body* that ratifies *structure*, not a parliament that votes on
prose. The *substantive vs editorial* cut is what protects against
both this anti-pattern and its inverse (mayor changing rule force
under "editorial" cover).

## Status

Keel is currently empty (`keel 492143d (wipe — fresh start)`). The
first section will be drafted after the staging city is up and the
code-reviewer role has been bead-tested. The first section's *content*
is a Li + council decision — likely a topic with low blast radius
where the discipline can be tested before being applied to deploy
or core infrastructure.
