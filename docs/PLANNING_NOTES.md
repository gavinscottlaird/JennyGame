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

## Open questions (to ask next, one at a time)

- Does any text show in the game on Jenny's computer (e.g. "Play" on the menu)?
- What situations fit high schoolers? (The current 12 are written for young
  children, at a 2nd-grade reading level.)
- How should the 4 prediction choices get easier or harder?
- How should Jenny change situations and scaffolding: inside the game, or by
  asking Claude to edit them?
