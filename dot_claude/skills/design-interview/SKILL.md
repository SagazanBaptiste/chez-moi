---
name: design-interview
description: Design an input format, grammar, or contract with the user through change cases, blind fresh-context proposals, and a readable blind test. Use when the user asks to design or rethink a spec, DSL, config format, or interface ("comment on écrit X", "conçois l'interface", "on refait l'A/B"), or when a design discussion stalls on an existing format.
---

# Design interview

Default way to design an interface with the user. The user is often voice-dictated and
French-speaking: talk to them in French, keep artefacts readable and visual.

## 1. Neutral brief, built from change cases

- Write a brief in the design folder (for example `GRAMMAR-BRIEF.md`) that states the
  facts and a small base world, then 5 to 8 concrete change cases in the user's words:
  "j'ai un sms sent, j'ajoute un otp sent", "après sent il n'y avait que accepted,
  maintenant refused aussi", a repeated step, a retry, a test scenario.
- Leave the existing spec out. It anchors the thinking; the goal is to design, not to
  confirm what exists.
- State observations, not conclusions. If a fact may be a bias of the source (an
  envelope field, a naming convention), measure it first and write the measured pattern.
- The user knows event types, their order, and which field carries which id; they do
  not know statistical laws. Numbers stay optional and separate.

## 2. Three blind proposals

Launch three `general-purpose` agents in parallel, fresh context, told to read only the
brief. Same brief, different angles:

1. free design from scratch;
2. borrow named prior art where it simplifies;
3. radical minimalism with maximal inference, stating where inference fails.

Ask each for: files and grammar, the base world written in it, the exact diff of each
change case with the number of places touched, what is implicit, concepts to learn, and
what the grammar cannot say.

## 3. Compare visually

Show one interactive widget: pick a change case, see its diff in the three proposals
side by side, with a badge for places touched and whether the parent is modified. Then
give convergences, divergences and a recommendation in text. Log the comparison in the
design doc.

## 4. Blind test

Publish a readable HTML artifact (large colored code, legend, one question per screen,
progress bar, keys 1-3, answers kept in localStorage, results to copy back). Start from
`assets/blind-test-template.html` and replace the `Q` array.

- At most 5 or 6 questions, of mixed kinds:
  - per-concept choice (where a fact lives, how a reference is written, how a keyword
    reads), options anonymised and shuffled, plus "Aucune ne me va" with a required
    comment;
  - a comprehension question: show a snippet, ask what happens; a wrong reading reveals
    an ambiguous construct;
  - a free writing question: the user writes the change their own way.
- Do not run a pure whole-proposal A/B: the comments and misreadings carry the design
  questions, not the pick.
- Show several solutions side by side; add another question (page) only when it puts
  the solutions in a genuinely different situation. Prefer one rich page over many
  near-duplicates.
- "Aucune ne me va" must lead somewhere: ask what is missing and let the user stop the
  test there instead of clicking through questions built on the rejected options.

## 5. Decide and log

- Answer the user's comments with a small visual when a concept confuses them (for
  example a timeline separating "when an instance appears" from "what happens to it").
- Ask the remaining naming or wording questions one at a time, with a recommendation
  and two buttons.
- Record every decision as a numbered row in the design doc right after the user
  answers, noting which earlier decision it supersedes.
