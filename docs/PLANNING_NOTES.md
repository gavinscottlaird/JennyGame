# Planning notes: Jenny's answers

This file logs Jenny's answers to planning questions, in her words where
possible. Claude adds to it each time she answers a question. Decisions
here are **not built yet** unless marked as built.

Status: **Level 1 approved and being built** (branch `jenny/level1-choices`).

---

## 2026-10-18: Learners and goals

**Q: Who are your learners?**
High school students.

**Q: What are you working on with them?**
Problem solving:
- choosing an option that fits the situation well
- matching their prediction with the outcome

The game must make it easy to understand what to do.

**Q: What should the player do?**
- Click the options **in order** to do the actions (as the game does now).
- Pick what they think will happen from a **menu of 4 options**, instead of
  typing a guess.
- The 4 options should **adjust to how well the student is doing**.

**Q: How should we work?**
Plan together first. Talk through options and ideas before building anything.

**How Jenny wants Claude to work:** Tell her when she isn't using Claude in
a cost-effective way, and warn her when something (like writing a list) would
be better for her to do herself.

**Q: What does Jenny want to customize?**
The situations. She wants to make them clearer, harder, or add whatever
scaffolding a student needs.

---

## 2026-10-19: Problems seen and the first situation

**What's wrong now (Jenny's words):** "As it stands right now, the game is
unplayable because it does not show the situation text nor what each button
means."

(Claude checked the code: it is *meant* to draw the situation at the top and a
label under each button on hover. So either all text is failing to show on
Jenny's computer, which would be a bug, or it is there but too small or unclear.
Not yet confirmed which.)

**Jenny's Level 1 situation:**
- Situation text: "[Character's name] is EXTREMELY hungry and tired."
- Objects: a fridge and a bed.
- A reminder appears: "Remember, your character has EXTREME outcomes!"
- Hovering over an object describes it:
  - Fridge: "Eat food from the fridge."
  - Bed: "Sleep in the bed."
- The student picks fridge then bed, bed then fridge, or just one of them.
- Then the student picks what they think will happen:
  1. You fall asleep eating then choke on your food.
  2. You sleep with a stomachache then wake up and raid the fridge.
  3. You sleep with a stomachache then wake up and the stomachache is even worse.
  4. You get well rested and well fed. (the "outlier")
- Then the student presses a button to say they are ready, and the outcome
  plays so they can see if it matches their prediction.

**Which ending plays (agreed 2026-10-19):** With an EXTREME character, ending 4
never plays; it is the too-good-to-be-true choice.

| Plan | Ending that plays |
|---|---|
| Fridge, then bed | 1. Falls asleep eating and chokes |
| Fridge only | 1. Falls asleep eating and chokes; the outcome screen says they fell asleep on the **floor** instead of the bed |
| Bed, then fridge | 2. Sleeps with a stomachache, then raids the fridge |
| Bed only | 3. Sleeps with a stomachache that gets worse |

So the outcome screen's wording can differ by plan even when the ending
(the prediction choice that is right) is the same.

**Jenny's scoring:**
- 2 points: the prediction matches the outcome.
- 1 point: wrong, but did not pick the outlier (4).
- 0 points: picked the outlier.

Jenny approved building this: "Update this and then make the game playable.
I'll open it myself."

**Jenny (2026-10-19):** "I still want to test a situation you create too. So I
gave you a situation, and you create one, and when you are ready I'll test it
out."

**Claude's Level 2 (for Jenny to test):** "[name] has a big test tomorrow and
is EXTREMELY tired." Desk ("Study for the test at the desk.") and bed ("Go to
sleep in the bed.").
1. You fall asleep on your book and wake up with words stuck on your face.
2. You sleep so long that you miss the test.
3. You study all night, then fall asleep during the test.
4. You study a little, sleep well, and do great on the test. (outlier)

| Plan | Ending that plays |
|---|---|
| Desk, then bed | 3. Studies all night, falls asleep in the test |
| Desk only | 1. Falls asleep on the book |
| Bed, then desk | 2. Misses the test (then studies for a test that is over) |
| Bed only | 2. Misses the test |

Meant to be a little harder than Level 1: the three bad endings are closer to
each other. After Level 1's result, **Next level** goes to Level 2; the
time-machine circle tries the same level again.

---

## 2026-10-19: Clicks must be clear, nothing blurry, full screen

**Jenny:** "After clicking an option, I want it to be extra clear what just
happened, and what should happen next. Include animations, help text, visual
helpers, etc. anything you think would solve this issue. Also, everything is
blurry. Change how visuals are done so nothing is blurry."

**Jenny:** "I also want the ability to go into fullscreen without it
affecting blur."

Claude chose the design (Jenny left it open). **Built 2026-10-23** on branch
`jenny/level1-choices`; see HANDOFF.md for what changed and the play check.

## 2026-10-27: More Level 1 scenarios, and how Jenny wants them built

**Jenny:** wants more scenarios at the **same level as her Level 1**, just
different situations. Her bus scenario ("thirsty + bus", cup and door) is
"PERFECT" and is the model.

**Design rules, from what Jenny said:**
1. Two variables only, taken from the situation (for example hungry and
   tired, or thirsty and a bus). The objects and every ending use only those.
   No extra variables such as "tired", "sloppy" or "self-control".
2. Each cost comes from how the action is done (gulp water, then run: cramp).
3. Order is cause and effect, so each order reads differently.
4. Each plan's outcome clearly differs and shows the consequence. Two plans
   share one menu choice only when the result really is the same (for
   example, both miss the bus), and their texts still name the cause.
5. The last menu choice (the outlier) is both problems solved with no cost.
   It never plays because of the situation itself, never because of a new rule.

**Three scenarios Jenny approved (Level 1):**

| Scenario | Objects | Menu choices (4 = outlier) |
|---|---|---|
| Picture day: EXTREMELY muddy, picture in 5 minutes | Tub, Door | 1 miss it; 2 on time, muddy; 3 on time, dripping wet; 4 clean with time to spare |
| Movie time: EXTREMELY hungry, movie in 5 minutes | Snack, Door | 1 miss it; 2 on time, still hungry; 3 on time, stomachache; 4 full and on time |
| Muddy and sleepy: EXTREMELY muddy and sleepy | Tub, Bed | 1 asleep in the tub; 2 muddy bed; 3 wash, then cannot sleep; 4 clean and rested |

Plans: picture: Tub and Door-then-Tub -> 1; Door -> 2; Tub-then-Door -> 3.
Movie: Snack and Door-then-Snack -> 1; Door -> 2; Snack-then-Door -> 3.
Muddy and sleepy: Tub and Tub-then-Bed -> 1; Bed -> 2; Bed-then-Tub -> 3.

**Built 2026-10-27** on `jenny/level1-choices`, not yet played. The game now
starts on a random Level 1 scenario (fridge and bed, or one of these three).
**Next level** goes to Level 2. A dropped idea: a "project and TV" scenario,
because its costs needed extra variables.

## 2026-11-08: New direction — animal characters and problem sets

**Jenny:** "I have decided that I don't like this version much. It's too
unrealistic." She wants animal problems: some distance from real life, but
students can connect to them and try to fix them.

**Rules for problems (Jenny's words and choices):**
- "I'm not interested in the solutions being something they can't do
  themselves." The fix must be something the **character itself** can do
  ("Buzz can't open the window").
- Wrong options must not be close to right: she rejected a goldfish scenario
  because two answers sounded plausible.

**Problem sets (Jenny named them):**
- **Set A:** simple, one step (like Buzz the Bee flying out the open door).
- **Set B:** a little harder, two steps, with a trap (like Kiko the Cat:
  chair first, then the floor).
- **Set C:** one step, involving an emotion — the character's own or someone
  they meet. Jenny: "I really like these."
- **Set D:** two steps, with one emotion. Jenny: "These are fantastic."

Claude's drafts of A–D (6 + 6 + 4 + 4 scenarios) are in the chat of
2026-11-08; they need to be rewritten around the chosen character (below).

**Characters:**
- The problems should be "based on the character the user chooses at the
  beginning and the different personified problems they perceive throughout
  their life."
- Characters should match the scenario animals, e.g. **Bao the Panda Cub**.
  Each has a **suggested name** that the student can change.
- A mix: keep some existing characters, add new ones. The dino stays the same
  dino, "just cuter" (it looks ugly now). All characters keep a pixel look.
- **6 scenarios per character per level**, with a button on each set to move
  up to the next level. Default: stay on the current level.

Status: Dot's look chosen (version 1, legs level with the belly).

## 2026-11-08: Dot test run

**Jenny:** "I want this to be the test run so leave everything else the same
and just switch out the dino with the 1 scenario per level so 4 levels total."
Scenarios must make sense for a long-necked dino.

**Cause and effect (Jenny's correction):** "This is CAUSE and EFFECT. The
consequences should match the specific actions the character does." Every
choice has a matching outcome; "there's no correct answer, there's just
corresponding situations and their outcomes." Each action always has the same
effect (the same action can't lead to two different results). With two
actions, both effects happen in order; order matters only when the first
changes the scene for the second.

**For set D:** Dot approaches others who have emotions.

**Picked (A1, B4, C3, D5):**

| Level | Situation | Objects |
|---|---|---|
| A | Dot is very thirsty. | River, Berry bush (sour) |
| B | Dot is tired; her nap spot is past a thorny bush. | Soft grass, Thorns |
| C | Dot is lonely; her herd is far away. | Hill (call out), Cave (hide) |
| D | A shy dino sits alone; a group is playing. | Shy dino, Group |

Each plan's ending (A as an example): River = thirst goes away; Berries =
mouth gets dry, still thirsty; River then Berries = thirst goes away, then
mouth dry again; Berries then River = mouth dry, then thirst goes away. Full
text for all four is in `scr_scenarios` (`dot_a`..`dot_d`).

**Scoring (Claude suggested, Jenny said go ahead):** 2 points for a matching
guess, 0 otherwise. No outlier in these levels.

**Built 2026-11-08** on `jenny/level1-choices`, not yet played.

## Open questions (to ask next, one at a time)

- Does any text show in the game on Jenny's computer (e.g. "Play" on the menu)?
- What situations fit high schoolers? (The current 12 are written for young
  children, at a 2nd-grade reading level.)
- How should the 4 prediction choices get easier or harder?
- How should Jenny change situations and scaffolding: inside the game, or by
  asking Claude to edit them?
