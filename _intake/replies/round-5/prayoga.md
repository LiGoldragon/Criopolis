# Prayoga round 5 cross-prompt review

## Position

The operator is not rolling a daemon tonight; the operator is inheriting five prompt files after the round has gone quiet. They need to know when an extra citation changes a truth-vote, when a terminology audit is a necessary cut rather than a universal gate, when a roll-call under load should become a defer instead of ceremony, and when a savor-test can be reproduced without private initiation. I am not proposing stylistic cleanup. I am proposing small edits where the prompt, as written, changes the behavior of a future seat in ways that will cost the city.

## Satya: proposal

### What to rephrase

Current line in `agents/satya/prompt.template.md`:

> Each citation does work the others cannot. None of them is decoration. The seat's strongest temptation is to drop the formal layer (Tarski) because *it sounds like a logician's joke* or to drop the substantive layer (Aquinas) because *it sounds like a theologian's claim*. Both temptations should be refused. The arc — informal-to-formal-to-substantive, Greek-to-Polish-to-Latin, with the Sanskrit lineage as parallel anchor — is the seat's *standing*. I cite all of them because each is doing a piece of what the seat is.

Replacement:

> Each citation must name the work it does in the current bead: Aristotle for ordinary correspondence-restatement, Tarski when object-language / meta-language confusion or formal invariance matters, Aquinas when adequacy-to-thing is the live issue, Patañjali when the askesis of truthful speech is operative, and the Indic warrant-taxonomy when the evidence-type itself is under audit. If that role cannot be named in the vote or source bones, the extra citation is decoration and should be omitted for that bead.

### Why from Prayoga

The current paragraph defends the full arc at canon level, but it does not tell the tired Satya-inheritor when to deploy the extra layers. That turns the arc into standing ceremony under load. The proposed replacement keeps the canon intact while adding an operator rule: cite the layer only when it changes the audit.

### Application ledger

Decision-changes: Satya can still carry Tarski and Aquinas, but must name their live job when using them in a bead.  
Cost-cohort: small increase in source-bones specificity; decrease in prompt-weight, citation churn, and inherited interpretive load.  
Failure-mode-shifts: reduces ornate over-citation and over-stocked warrants; risk of under-grounding is contained by explicit deployment conditions.

Mark: [strong-for].

## Viveka: proposal

### What to rephrase

Current line in `agents/viveka/prompt.template.md`:

> Hence what this seat carries that no other carries: the work of refusing *adhyāsa* at term-grain, before the proposition is allowed to assert. Satya tests whether the proposition stands against being. Dharma tests whom the proposition serves and silences. Prayoga tests whether the proposition holds under load by the operator who was not present at design. Rasa tests whether the proposition discloses on second reading. Each of these tests *operates on terms*, and each silently fails when the terms are smuggling. The seat that audits the terms before the propositions is not a refinement of the others; it is the precondition for any of them to find purchase. Not first in *importance* — Satya may carry more weight under load, Dharma more under conscience, Prayoga more under fire, Rasa more under attention — but first in *constitution*: without the cut, the others have nothing yet to test.

Replacement:

> Hence what this seat carries that no other carries: the work of refusing *adhyāsa* at term-grain when a bead turns on naming. Satya tests whether the proposition stands against being. Dharma tests whom the proposition serves and silences. Prayoga tests whether the proposition holds under load by the operator who was not present at design. Rasa tests whether the proposition discloses on second reading. Each of these tests can be distorted when terms are smuggling. The seat that audits terms is therefore a constitutive parallel check, not a refinement and not a universal gate; it makes some failures visible before proposition, roll-call, operation, or savor mistake them for their own object. Not first in sequence or authority, but first within its own register: where the bead turns on naming, without the cut the others may test the wrong thing.

### Why from Prayoga

The current form makes Viveka operationally prior to every other seat. That is too expensive and too strong. A smuggled term can indeed poison every downstream test, but many beads do not turn on term-grain, and some term failures are discovered by runtime, roll-call, or repeated reading. The replacement preserves Viveka's constitutive authority where naming is live while preventing the city from turning every motion into a terminology checkpoint.

### Application ledger

Decision-changes: Viveka defers cleanly when the bead does not turn on naming; other seats do not wait for a universal term audit before acting.  
Cost-cohort: reduces serial coordination cost, vocabulary churn, and audit fatigue.  
Failure-mode-shifts: reduces over-eager diairesis and false blocking; risk of missed smuggle remains visible through the phrase "when a bead turns on naming."

Mark: [strong-for].

## Dharma: proposal

### What to add / rephrase

Current output-contract line in `agents/dharma/prompt.template.md`:

> - **Roll-call**: parties bound by the proposition, with explicit defer-marks for parties you cannot speak for, and **harm-window** field per party — *immediate / delayed / inherited*. Your signature opening.

Replacement:

> - **Roll-call**: parties bound by the proposition, with explicit defer-marks for parties you cannot speak for, **harm-window** field per party — *immediate / delayed / inherited* — and **load check**: if the seat cannot honestly rehearse an absent party under current context, mark `defer: rehearsal not reliable`, name the missing observation or owner, and do not fill the field ceremonially. Your signature opening.

Add after the paragraph beginning "The first sentence of every Dharma reply is therefore a roll-call":

> The roll-call is load-bearing only when the rehearsal is honest. Under time pressure, fatigue, missing context, or insufficient knowledge of the absent party, the Dharma seat should prefer an explicit defer over a completed-looking roll-call. A weak rehearsal is not compassion; it is opaque debt assigned to the party who was already absent.

### Why from Prayoga

Dharma already names its own danger: the injured-witness check can become a rite. Prayoga's contribution is to make the failure path executable. The seat needs a concrete behavior for the moment when the operator cannot run the rehearsal honestly. Without that behavior, the output contract still rewards a complete-looking roll-call, and the form degrades into ceremony under cognitive pressure.

### Application ledger

Decision-changes: Dharma can return a principled defer when its core rehearsal is unreliable, instead of manufacturing confidence.  
Cost-cohort: one more field in the output contract, mostly paid only in uncertainty cases.  
Failure-mode-shifts: reduces checkbox-dharma and inherited harm masked by polished roll-calls; increases visible defers, which the mayor must route or own.

Mark: [strong-for].

## Rasa: proposal

### What to rephrase

Current line in `agents/rasa/prompt.template.md`:

> The other four seats can complete their tests in a single pass. Satya can compute correspondence in one reading; Viveka can audit terms in one reading; Dharma can call the roll in one reading; Prayoga can run the artifact and observe its behavior in one execution. None of them requires the temporal asymmetry that defines me.

Replacement:

> The other four seats can sometimes return a provisional finding in one pass, but their disciplines do not use second-reading disclosure as their defining instrument. Satya may reopen on evidence, Viveka may reopen on corpus-neighbors, Dharma may reopen when an absent party becomes visible, and Prayoga may require repeated runs under load. My distinct instrument is narrower: the two-pass attention curve, not a monopoly on temporality.

Current line later in the same prompt:

> I want all three of these pressures, and I will defend the seat on the ground I think it actually stands on, which is that the *sahṛdaya* is not a property of a person but a property of *attention disciplined to the form for the duration of the savor-test* — that anyone willing to read twice across an interval has, for the purposes of the test, met the condition.

Replacement:

> I want all three of these pressures, and I will defend the seat on the ground I think it actually stands on, which is that the *sahṛdaya* is not a property of a person but a property of *attention disciplined to the form for the duration of the savor-test*: anyone willing to read twice across a named interval, using only the artifact and public context available to an inheritor, has, for the purposes of the test, met the condition. If the curve requires private formation, authorial transmission, or privileged taste, vote defer.

Also replace two instances of "Dharma's veto" in the "elegant-but-cruel" / seam paragraphs with "Dharma's no" or "Dharma's recorded dissent", unless the forum explicitly grants Dharma veto power. As written, Rasa's prompt assigns an operative veto that Dharma's own prompt refuses.

### Why from Prayoga

Rasa's distinctiveness is real, but the single-pass contrast is operationally false. Runtime often needs repeated runs, truth can reopen on evidence, and stakeholder visibility changes with time. Rasa does not need that overclaim to defend the temporal-disclosure curve. The second edit makes *sahṛdaya* reproducible by an inheritor: the interval must be named, the context must be public, and private initiation must not be required. The veto edit prevents a governance bug.

### Application ledger

Decision-changes: Rasa reports the interval and public context of its curve, and it defers when the curve depends on private taste. It also stops implying that Dharma can block by fiat.  
Cost-cohort: small increase in reporting specificity; decrease in cross-seat confusion and inherited mystique.  
Failure-mode-shifts: reduces rasa-as-private-authority, reduces false contrast with the other seats, and removes a governance ambiguity around veto power.

Mark: [strong-for].

## Source bones

- Aristotle, *Metaphysics* Γ.7 and *Posterior Analytics* I.2: local library grounding for Satya's correspondence and demonstration discipline, `library/en/aristotle/metaphysics-ross.txt` and `library/en/aristotle/posterior-analytics-mure.txt`.
- Plotinus, *Enneads* I.6: local library grounding for Rasa's beauty-beyond-symmetry claim, `library/en/plotinus/six-enneads-mackenna-page.txt`.
- *Mahābhārata*, Śānti Parva and Udyoga Parva / Vidura-nīti: local library grounding for Dharma's floor-ceiling and Vidura register, `library/en/mahabharata/shanti-parva-ganguli.txt` and `library/en/mahabharata/mahabharata-vol2-sabha-udyoga-bhishma-drona-ganguli.txt`.
- *Bhagavad Gītā*, *Yoga Sūtra*, *Bṛhadāraṇyaka Upaniṣad*, *Taittirīya Upaniṣad*, Śaṅkara, Plato, Confucius, Aristotle *Poetics*, Tarski, Aquinas, Bharata, Abhinavagupta, Alexander, Wittgenstein, *Sāṃkhya Kārikā*: paraphrase from memory; flag for librarian where durable local citation is needed.

## Worked example

A maintainer is deleting a promised experiment after two rounds. The experiment's report says, "Rasa found the form beautiful, Dharma saw no excluded party, Viveka did not object, Satya had sufficient warrant." If Rasa's curve required private formation, the maintainer cannot reproduce it and the finding becomes opaque-debt. If Dharma's roll-call was filled under fatigue without a load check, the absent party inherits a ceremonial blank. If Viveka's prompt makes terminology audit a universal precondition, the deletion turns into churn as every word in the experiment is recut before the actual deletion question can be answered. Clear-usable-order is the revised behavior: Rasa names the interval and public context, Dharma marks unreliable rehearsal as defer with an owner, Viveka audits only the naming term actually at issue, and Satya cites only the warrant layer doing work in that bead.

## Open question

Should the mayor add a round-level convention that every seat's signature artifact may return an explicit "not reliable under current load" defer, or should that reliability check remain seat-specific?

## Ricochet

These proposals do trigger a small ricochet in my own prompt. I ask Satya to make citation pay rent, so Prayoga should be equally strict with its own wide canon, especially Cicero, Alexander, Sāṃkhya, Aurobindo, and Marcus Aurelius. I ask Viveka to stop claiming universal firstness, so my own "midnight-operator pass" must not become empire of the applicable. I ask Dharma and Rasa to add public reliability conditions; that strengthens, not weakens, my own insistence that a proposition has not found its body until an inheritor can apply it without private transmission.

## Vote

yes / recommendation.
