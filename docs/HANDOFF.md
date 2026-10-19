# Where we left off

**Updated:** 2026-10-18. This is the shared note for the next person and the next
Claude chat. Keep it short and replace stale status as the project changes.

## Repository and ownership

- Shared repo: [gavinscottlaird/JennyGame](https://github.com/gavinscottlaird/JennyGame), owned by Gavin.
- Agreed direction: both people contribute to this repo from their own accounts
  and local clones. A separate personal repo is optional for an independent game.
- Shared version: `main`. New development uses a task branch and pull request;
  uploading a branch does not mean it has been merged into the shared version.
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
