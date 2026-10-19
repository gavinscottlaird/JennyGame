# Planning notes: Jenny's answers

This file logs Jenny's answers to planning questions, in her words where
possible. Claude adds to it each time she answers a question. Decisions
here are **not built yet** unless marked as built.

Status: **planning, nothing approved to build yet.**

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

**Jenny's scoring:**
- 2 points: the prediction matches the outcome.
- 1 point: wrong, but did not pick the outlier (4).
- 0 points: picked the outlier.

---

## Open questions (to ask next, one at a time)

- Which ending plays for each plan (fridge then bed, bed then fridge, fridge
  only, bed only)?
- What situations fit high schoolers? (The current 12 are written for young
  children, at a 2nd-grade reading level.)
- How should the 4 prediction choices get easier or harder?
- How should Jenny change situations and scaffolding: inside the game, or by
  asking Claude to edit them?
