# Where we left off

**Updated:** 2026-11-08. This is the shared note for the next person and the next
Claude chat. Keep it short and replace stale status as the project changes.

## Repository and ownership

- Shared repo: [gavinscottlaird/JennyGame](https://github.com/gavinscottlaird/JennyGame), owned by Gavin.
- Agreed direction: both people contribute to this repo from their own accounts
  and local clones. A separate personal repo is optional for an independent game.
- Shared version: `main`. New development uses a task branch and pull request;
  uploading a branch does not mean it has been merged into the shared version.
  **Jenny (2026-11-08):** "I don't want any other branches." Keep `main` as the
  only lasting version; ask her before leaving a task branch open.
- Incoming collaborator: invitation/access **not verified**. Gavin needs her
  username to invite her through repo Settings > Collaborators > Add people;
  she accepts while signed in. Follow [WORKING_TOGETHER.md](WORKING_TOGETHER.md).
- Session authorization: Gavin requested committing/pushing the handoff docs.
  The incoming collaborator should authorize ongoing task-branch uploads and
  PR creation using the starter message. No standing automatic-merge policy
  has been agreed, and this docs update does not change GitHub access/settings.

## Current state

The existing game is **Pixel Problem Solver**, a GameMaker project opened with
`JennyGame.yyp`. The recorded IDE version is `2024.14.4.222`.

The source contains five screens: menu, character/name, focus, play, and summary.
It has four avatars and 12 scenarios across School, Friends, Home, and Food.
Players arrange picture actions, write a prediction, watch an outcome, and earn
XP according to the ordering and prediction rules in the README.

The current handoff includes beginner setup/planning guides and `CLAUDE.md`
instructions for shared development. The default setup now uses this shared
repo, with an optional guide for an independent copy. These updates change
documentation only. The starting game source is from commit `2e81f9c`.

## Agreed task and plan

**Current task (2026-10-19): Level 1 with a prediction menu.** Approved by
Jenny ("Update this and then make the game playable"). Branch
`jenny/level1-choices`. Her answers and the full design are in
[PLANNING_NOTES.md](PLANNING_NOTES.md).

What the player sees:
- After typing a name, the game goes straight to Level 1. (The focus screen
  and the 12 old scenarios are kept in the code but not reachable for now.)
- An intro card shows "[name] is EXTREMELY hungry and tired." and the reminder
  "Remember, your character has EXTREME outcomes!" The reminder stays on screen.
- Two objects, fridge and bed. Hovering shows "Eat food from the fridge." /
  "Sleep in the bed." Each can be picked once, in any order.
- "I'm ready to guess" opens 4 endings to choose from, then "Show me what
  happens" plays it out.
- Endings: fridge then bed, or fridge only (on the floor) -> 1 (choke);
  bed then fridge -> 2 (raid the fridge); bed only -> 3 (worse stomachache).
  Ending 4 (well rested and well fed) never happens; it is the outlier.
- Points: 2 for a matching guess, 1 for a wrong guess that is not the outlier,
  0 for the outlier. Logged to the score screen like before.

Boundary: the old typed-guess scoring code stays for the old scenarios. Save
file format is unchanged; Level 1 entries add a few extra fields.

Success check: Jenny plays all four plans in GameMaker and checks the text,
hover descriptions, the 4 choices, the ending shown, and the points.

Also added: Claude's **Level 2** (big test, desk and bed) for Jenny to test,
and a **Next level** button on the result screen (the time machine retries).

Status: **built, not yet played.** Claude could not run GameMaker (no
GameMaker in its workspace, and Jenny's computer was offline), so nothing has
been tested in the game yet. Jenny will open and play it. If GameMaker shows an
error, copy its text to Claude.

### Clearer clicks, sharp text, full screen (2026-10-23, built, not yet played)

Jenny asked (2026-10-19) and left the design to Claude ("anything you think
would solve this issue"):
1. After clicking an option, make it extra clear what just happened and what
   to do next: animations, help text, visual helpers.
2. "Everything is blurry." Make nothing blurry.
3. Full screen that does not make it blurry.

**Cause of the blur (found in the files):** `fnt_pix` is Arial size 8, and
`draw_txt` blew it up 2 to 6 times, so the soft edge pixels were magnified.

**What was built** (branch `jenny/level1-choices`, same PR #2):
- New `scripts/scr_screen`: the GUI is set to the real window size; layout
  stays in 1366x768 design units, mapped with a scale/offset matrix. Each
  text size is made with `font_add` from `datafiles/AtkinsonHyperlegible-*.ttf`
  at its exact on-screen pixel size and drawn 1:1. Fonts are remade when the
  window size settles. The whole window is painted (no bars). If the font
  files fail to load, `fnt_pix` is used and the title screen says "backup font".
- Full screen: F11, or the corner button on every screen. At start the window
  grows to fit the screen (1.2x on a 1080p screen). The title screen shows the
  window size, to help diagnose any remaining blur.
- Play screen (choice levels): help box under the reminder (what just
  happened + what to do next, pops/wiggles); Plan/Guess/Watch steps; captions
  under each object; burst + flying chip + hop + numbered badge on picking;
  "Take back" next to the plan; glow and bouncing arrows on the next thing to
  press; ticked "Your guess" in the menu; "Change my plan" button; "Watch step
  1 of 2" while it plays (longer speech bubbles: 80 frames); clearer ending
  panel (points, your guess vs what happened, why, what next), points float
  to the score box, confetti on a match, "Try again" always labelled. Hand
  pointer over clickable things. Small pops on the character screen.
- Changed flow: after the **last** level the big button says "See my score"
  (it used to restart the level; the time machine still does that). Enter
  works as a shortcut for the big button on choice levels.
- Scoring, levels, endings, and the save format are unchanged.

**Checks done:** brackets balanced in every GML file; every function called is
defined in the project or is a GameMaker built-in; the `.yyp` Included Files
entries copy the format of a real GameMaker 2024 project; text widths measured
with the real font against each layout; a rough mock-up of the plan, guess and
ending screens drawn from the same numbers showed no overlaps.
**Not run in GameMaker** (none in Claude's workspace). Unknowns to watch:
font_add sizing (code measures and corrects it), and whether Windows display
scaling still stretches the window (the title-screen window size will tell).

**Jenny's play check:** title screen shows "Version: Oct 23"; text is crisp;
F11 and the corner button go full screen and back, still crisp; on Level 1,
each click updates the help box and plays its animation; "Take back",
"Change my plan", and both ending buttons do what their words say.

### More Level 1 scenarios (2026-10-27, built, not yet played)

Jenny approved three new Level 1 scenarios, built on her bus-level pattern
(two variables only; see PLANNING_NOTES.md for her rules and the full tables):
`level_1_picture` (muddy, picture in 5 minutes; Tub, Door), `level_1_movie`
(hungry, movie in 5 minutes; Snack, Door), `level_1_muddy_sleepy` (Tub, Bed).
They are at the end of the `levels` list in `scr_scenarios`.

- The game now starts on a random Level 1 scenario (the fridge and bed one, or
  one of the new three). **Next level** picks a random scenario from the next
  level up, so Level 1 leads to Level 2. Code: `level_pool`,
  `pick_level_index`, `next_scenario`, `has_next_level` in `scr_scene_util`,
  and `set_focus` in `scr_state`. Scoring and the save format are unchanged.
- **Checks done:** brackets balanced in the three changed GML files; each
  plan key in each new scenario is one of the two objects (and the pair in the
  other order); every menu pick is 0, 1 or 2 with 3 as the outlier; objects
  and gags used already exist. **Not run in GameMaker.**
- **Jenny's play check:** start with a made-up name a few times and watch for
  different Level 1 scenarios. In each new one, try all four plans and check
  the ending matches the notes, then check points (2 right, 1 wrong, 0 for
  the outlier). Check Next level goes to Level 2, and the score screen lists
  the right scenarios.

### Dot test run: Levels A-D (2026-11-08, built, not yet played)

Jenny approved a small test of the new animal direction: swap the old dino for
**Dot** and build one scenario for each problem set, leaving everything else
the same. Her rules and picks are in PLANNING_NOTES.md (2026-11-08).

- **Dot:** the dino avatar now uses Jenny's chosen look (version 1, legs level
  with the belly). Its card says "Dot". `dino` in `scr_art_chars`.
- **Levels:** the five old levels (fridge and bed, test, picture, movie,
  muddy) were replaced by `dot_a`..`dot_d` in `scr_scenarios`: A = thirsty
  (River, Berries), B = tired (Soft grass, Thorns), C = lonely (Hill, Cave),
  D = shy dino and group (Shy dino, Group). Next level goes A > B > C > D.
- **Cause and effect:** each action always has the same effect. The four
  plans (one object, the other, or both in either order) each have their own
  ending, and the four menu guesses are exactly those four endings.
- **Scoring:** no outlier (`outlier : -1`). 2 points if the guess matches what
  the plan caused, 0 otherwise. Older levels with an outlier still score
  2/1/0. `score_choice` in `scr_score`.
- **New object art:** river, bush, grass, thorns, hill, cave, shy, group in
  `scr_art_objects`. Reminder line is now "Think: what will each action cause?"
- `GAME_VERSION`: "Version: Nov 8 - Dot test run (Levels A-D)".
- **Checks done:** brackets balanced in the changed GML files; every plan key
  matches the two objects; picks 0-3 match the menu order; object art 16x16
  and Dot 16x20; art previewed as a picture. **Not run in GameMaker.**
- **Known gaps:** the text names Dot, so it reads oddly if a student picks
  another avatar. The name box is still the student's own name (used for
  their saved score), so Dot cannot be renamed yet without mixing up logs; a
  separate character-name box is a later step. The room background is still
  the indoor room.
- **Jenny's play check:** pick Dot, type a made-up name. In each level try all
  four plans (each object alone, then both orders), and check the ending and
  the 2 or 0 points. Check Next level goes A > B > C > D, then See my score.
- **Next:** Jenny plays it; then add the other characters and more scenarios
  one at a time.

## Current task: smooth art in the game (2026-11-08)

**Asked by Jenny** (while away): "Put it all in the code and implement it."
Branch `jenny/smooth-art`, pull request open, **not merged** until Jenny checks
it (she wants `main` to stay the only lasting version, so the branch is deleted
after merging). Version label: "Version: Nov 8 - smooth art test".

What changed:
- New smooth pictures (approved style: one smooth outline, clear faces) are PNG
  files in `datafiles/` and drawn by `scripts/scr_smooth_art`.
- Avatar: **Dot the Dino** now uses the approved smooth Dot. Robot, cat and kid
  have no smooth version yet, so they still use pixel art (mixed look for now).
- Objects with smooth pictures: river, bush, thorns, cave, shy, group, grass,
  hill (all the Dot levels A-D). Older objects (bed, fridge, ...) stay pixel.
- The action buttons show the smooth picture as a white icon.
- The playing screen has a background picture chosen by its objects: Level A/B
  meadow, Level C hilltop sunset, Level D forest, the playground meadow, the rest
  a cozy room. Menu screens keep the old backdrop. A cave-inside background is
  included but unused.
- Extra character pictures (Bao the panda, Kiko the cat, Buzz the bee, Pip the
  penguin, Bun the bunny, with sad/angry/excited/scared/shy faces) are included
  as files only, ready for later. They are not in the game yet.
- The backgrounds in the game are a redrawn layout of the preview sheet: the
  ground starts higher so the objects (back row) and Dot (front) both stand on
  ground. Source: `tools/art/bgs_game.py`. Preview-only sheet: `tools/art/bgs2.py`.

Checks actually done: rendered all PNGs; made a mock-up of the playing screen
(same sizes and positions as the code) for each background to check that things
stand on the ground and do not cover the buttons. **Not run in GameMaker** (no
GameMaker in the cloud workspace), so nothing here is proven to build.

Play check for Jenny (about 5 minutes):
1. Get the branch (GitHub Desktop: Fetch, switch to `jenny/smooth-art`), open
   `JennyGame.yyp`, press Run. Title shows "Nov 8 - smooth art test".
2. Pick Dot. Dot should look smooth on the character screen (others pixel).
3. Play Levels A-D: each has a picture background, smooth objects, smooth Dot
   walking; tap the round buttons (white icons), finish a level, see the ending.
4. Look for: blurry or missing pictures, things floating, text hard to read.
5. If anything fails to build, the quick fix is `#macro SMOOTH_ART_ON false` in
   `scripts/scr_smooth_art` (back to pixel art), and tell Claude the error text.

Next decisions (Jenny): make smooth robot/cat/kid avatars, or swap them for the
new animal characters; redraw older objects; sizes if pictures look too small.

## One version only (2026-11-08)

Jenny asked for a single version: the Dot test run (Levels A-D) is now `main`,
and the other branches (`jenny/level1-choices`, `jenny/planning-notes`,
`jenny/backlog`) were merged in and deleted. Their history is kept in `main`.

## Ideas for later

Saved in [BACKLOG.md](BACKLOG.md). Added 2026-11-08: redo all art as clear,
kid-friendly video game sprites. Not planned or built yet.

## Jenny's copy of the game

**Update 2026-11-08:** Jenny now has a real Git clone at
`C:\Users\JenniferNagrant\GameMakerProjects\JennyGame`, signed in to GitHub
through Git Credential Manager (Git and GitHub CLI installed; `gh` itself is
not signed in). Claude can commit and push from there. The older note below
describes the downloaded `JennyGame-main` copy.

Jenny plays from `C:\Users\JenniferNagrant\GameMakerProjects\JennyGame-main`.
It is a downloaded copy, not a Git clone, so it does not update itself.
After each game change, Claude copies the changed files into that folder
(when her computer is connected) and updates `GAME_VERSION` in `scr_config`.
The title screen shows that version at the top left, so Jenny can check she is
running the newest copy. Other folders on her computer ("Problem Solver",
"Problem Solver 2", downloaded ZIP copies) are older and should not be used.

## Verification and known limits

The handoff preparation reviewed the README, project metadata, and relevant
source files. Local Markdown links resolve; setup and Plan mode guidance were
checked against official Claude and GitHub documentation. The starting game
was **not built or played during this docs-only update**. Existing README claims
about past testing are historical, not a new
verification. There is no checked-in automated test suite or build script.

Known product limits from the README: no sound, player logs stay on each
computer, and players who enter the same name share a record. No other current
bugs have been established in this handoff; that does not mean the game is
bug-free. Previous design documents or AI chats are not included in this repo.

## Baseline play check for the next gameplay change

Use a made-up player name. Ask the user to perform any steps you cannot run:

1. Open `JennyGame.yyp` in GameMaker and Run. Check menu, avatar/name, and focus selection.
2. Pick picture buttons. Check the action chain and undo button.
3. Press **Check what happens**, enter a prediction, and press Enter. Check that the prediction box closes and the outcome plays.
4. Try a correct sequence with a matching prediction, then a wrong order or repeated action. Check the XP and explanation against the README rules.
5. Check rewind and the score screen. Close and reopen the game with the same test name to check saved scores.
6. Check the specific change, including any affected layout or wording. Record which checks actually ran and their results.

## End-of-task update

Claude: replace outdated sections with the latest completed work, active plan,
checks and results, unresolved problems, and the next action. Record a pending
upload here if GitHub is unavailable, then clear it once verified. Check actual
Git state for upload status rather than treating this file as proof. Commit and
push these notes with the corresponding task under the user's authorization.
Keep both people's current work/decisions when reconciling notes. Report branch
upload and merge status separately, based on actual Git/GitHub state.
