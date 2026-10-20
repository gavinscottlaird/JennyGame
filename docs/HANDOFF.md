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

**Planning in progress (2026-10-18):** Jenny is planning changes with Claude for
high school learners. Her answers are logged in [PLANNING_NOTES.md](PLANNING_NOTES.md).
Nothing is approved to build yet.

No new gameplay feature has been selected or approved. The next task is to help
the incoming collaborator accept access, clone the shared repo, and run the
starting game. Then plan their first change with them in Claude Code, using a
task branch and pull request. Before work, check for other open tasks/PRs.

For future work, replace this section with: the agreed player-visible result,
the small implementation plan, what else may change, the success check, and
whether it is planned, in progress, or complete, plus its branch/PR when known.
Record decisions here after leaving Plan mode so another chat can continue
without the old conversation.

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
