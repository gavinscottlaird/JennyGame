# Pixel Problem Solver

**Working on this game? Start with [START HERE](docs/START_HERE.md).**
You can talk to Claude in everyday language; you do not need to know how to code.

- [Work together in the shared GitHub repo](docs/WORKING_TOGETHER.md) so both people can contribute to the same game.
- [Plan with Claude before building](docs/PLAN_WITH_CLAUDE.md) to avoid spending your time and usage on the wrong change.
- [Where we left off](docs/HANDOFF.md) gives the next chat the current state.
- [Instructions for Claude](CLAUDE.md) tell it how to plan, check, document, and save work.

For an independent version of the game, there is also an
[optional separate-repo guide](docs/YOUR_GITHUB_REPO.md).

The rest of this README describes the game for Claude and anyone who wants more detail.

A GameMaker (2024.14) game where a student builds a plan out of picture buttons,
writes down what they think will happen, and then watches what really happens.
XP is earned for steps that were both **done in the right order** and **named in
the written prediction**. Every decision is logged per player name for the
therapist.

Open `JennyGame.yyp` in GameMaker and press Run. No sprites or external assets
are needed — all art is pixel data in code, and the one font resource is in
`fonts/fnt_pix`.

---

## Screen flow

| Room | What happens |
|---|---|
| `rm_menu` | Title, **Play**, **See my score** |
| `rm_char` | Four avatars (robot, cat, kid, sauropod), then "What is your name?" |
| `rm_focus` | Four tags — School, Friends, Home, Food — or type a word |
| `rm_scene` | The game loop. Walk with arrows/WASD, tap round buttons, "Check what happens" |
| `rm_summary` | Total XP and the scrollable decision log, per player |

In `rm_scene`:

- **Round buttons** float above each object: 60px, `#FFD700`, white icon, tooltip
  underneath on hover. The icon is the object's own art drawn as a white
  silhouette, so buttons and objects always match.
- **The chain** builds along the top (`Shirt > Bag > Door`). The circle at the
  top right takes the last pick back.
- **"Check what happens"** is fixed at bottom centre. It opens the dark modal
  ("What will happen?"), which closes itself the moment Enter is pressed, and the
  animation starts straight away.
- **Bottom right**: the time-machine circle appears after the animation and
  rewinds the scene.
- **Bottom left**: the square arrow. On the play screen it ends the session and
  opens the score screen; on the other screens it steps back.

---

## How XP is decided

All of this lives in `scripts/scr_score/scr_score.gml`, which carries the same
rules as comments. The rules are strict on purpose, so two students who write the
same idea in different words get the same score.

1. **Ordered run.** The chain is compared with the scenario's `correct` list from
   the front. The run of steps that match in position is the only part that can
   earn anything. One step out of place ends the run, so nothing after a mistake
   scores. Extra buttons are never in the run.
2. **One XP per predicted step.** A step in that run earns 1 XP *only if the
   written prediction names it*, using any word on that step's synonym list
   (`step_words` in `scr_scenarios`). "Get dressed", "put on my shirt" and "wear
   clothes" all hit the same step — that is the partial credit for different
   wording. Words that are not on any list are minor detail and are ignored.
3. **Negation is respected.** The prediction is cut into clauses at *and, then,
   but*, commas and full stops. If the clause naming a step also holds a negation
   word (*not, never, forgot, without*…), that step earns nothing.
4. **Contradicting the outcome scores nothing.** This only fires when the student
   actually wrote an ending: it went well but they used only bad-ending words
   (*late, mess, nothing, broke*), or it went badly but they used only
   good-ending words (*works, ready, clean, happy*). Then the whole attempt is 0.
   A prediction that just lists steps is never zeroed by this rule.

Each attempt is logged with a plain-words `why` line ("The guess said it would go
wrong, but it went right. No XP.") so the scoring is never a black box.

**The "core lesson" is the `step_words` lists.** To retune what counts as the
lesson for a scenario, edit those lists — nothing else needs touching.

---

## The decision log

Written to `%LOCALAPPDATA%\JennyGame\pps_log.json` **after every single action** —
name entered, focus picked, prediction submitted, outcome shown — not when the
arrow button is pressed. If the app is closed without warning, everything up to
the last action is already on disk. A damaged file is set aside as
`pps_log.json.bad` and the session starts clean rather than failing.

```jsonc
{ "version": 1,
  "players": {
    "Ada": { "name": "Ada", "avatar": "cat", "xp": 4, "plays": 2,
      "entries": [
        { "when": "...", "focus": "School", "goal": "Get ready for school.",
          "tier": 1, "tier_name": "Single-Focus Obsession",
          "chain": ["clothes","backpack","door"], "chain_words": "Shirt > Bag > Door",
          "guess": "i will put on my shirt and take my bag and go to school",
          "outcome": "win", "said": "You got dressed...",
          "xp": 3, "credit": "full", "why": "Right order and the guess told the whole plan. 3 XP." }
      ] } } }
```

The score screen shows one player at a time with `<` `>` to move between them,
so a therapist can look back over several students on the same machine.

---

## Content

12 scenarios: four focuses × three tiers. Tier names are kept for the therapist
(`tier_name`) and given a kid-friendly version on screen (`tier_kid`).

| | Tier 1 — Single-Focus Obsession | Tier 2 — Wrong Order | Tier 3 — Simultaneous Overload |
|---|---|---|---|
| **School** | Get ready for school | Do your school work | The bell rings soon |
| **Friends** | Say hi to a friend | Play with your friend | Your friend got hurt |
| **Home** | Clean your room | Feed the dog | Time for bed |
| **Food** | Make a snack | Make toast | Clean up after you eat |

Each ending has its own funny line and a matching visual gag: confetti for a win,
the same object stacked on your head for obsession, the character tumbling upside
down for wrong order, everything orbiting your head for overload.

All on-screen wording is kept below a 2nd-grade reading level — short words, short
sentences, and **"Try again"** rather than "Retry".

---

## The four flagged risks

1. **Partial credit consistency** — solved by the per-step synonym lists and the
   four written rules above, rather than a vague "close enough" judgement.
2. **Name tag overlap** — `scripts/scr_nametag`. The tag tries a list of spots in
   order and takes the first that is fully on screen and covers no action button
   (or its tooltip strip) and no object art. If every spot is blocked it drops
   below the feet. While an ending gag plays above the head it goes below the feet
   first. Verified in play: the tag moves itself when the character stands under a
   button or object.
3. **Save persistence** — see the decision log above.
4. **Sauropod shape** — every avatar is drawn on the same 16×20 grid
   (`CHAR_GRID_W/H`) and the sauropod's neck is curled *inside* that grid, so it
   cannot clip a ceiling or cover the buttons above the objects. Each avatar also
   carries a tight `hit` box of its visible body, and walking is clamped with that
   box, so all four stop at exactly the same screen edge.

---

## Changing things

- **Look and layout** — `scripts/scr_config`. Screen size, art scale, the 60px
  button radius, the gold `#FFD700`, where the fixed buttons sit. Nothing else
  hard-codes these numbers.
- **Art** — `scr_art_chars` (avatars, 16×20) and `scr_art_objects` (objects,
  16×16). Both are ASCII maps with a letter per colour and `.` for see-through,
  so a new object is just 16 lines of text plus a label.
- **Scenarios** — `scr_scenarios`. Add an entry with `spots`, `correct`,
  `step_words`, `obsess` and the five outcome lines. Object positions are worked
  out automatically (`layout_positions`), so buttons can never collide: up to four
  objects in one row, five or six across two rows.

## Not done

- No sound.
- The log is per machine; there is no cloud sync.
- Two students who type the same name share one record.
