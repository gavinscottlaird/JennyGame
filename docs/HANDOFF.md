# Where we left off

**Updated:** 2026-10-18. This is the shared note for the next person and the next
Claude chat. Keep it short and replace stale status as the project changes.

## Repository and ownership

- Starting source: [gavinscottlaird/JennyGame](https://github.com/gavinscottlaird/JennyGame).
- Incoming owner's working repo: **not set up yet**. Follow
  [YOUR_GITHUB_REPO.md](YOUR_GITHUB_REPO.md), then replace this line with the
  confirmed repo URL, working branch, and ongoing commit/push authorization.
- The source checkout uses `main`. Inspect actual remotes and tracking before
  uploading; do not assume a new owner's copy already points to their account.

## Current state

The existing game is **Pixel Problem Solver**, a GameMaker project opened with
`JennyGame.yyp`. The recorded IDE version is `2024.14.4.222`.

The source contains five screens: menu, character/name, focus, play, and summary.
It has four avatars and 12 scenarios across School, Friends, Home, and Food.
Players arrange picture actions, write a prediction, watch an outcome, and earn
XP according to the ordering and prediction rules in the README.

The current handoff adds beginner setup/planning guides and `CLAUDE.md`
instructions for keeping the owner's repo and these notes current. It changes
documentation only. The starting game source is from commit `2e81f9c`.

## Agreed task and plan

No new gameplay feature has been selected or approved. The next task is to help
the incoming owner connect their own repo and run the starting game. Then plan
their first change with them in Claude Code.

For future work, replace this section with: the agreed player-visible result,
the small implementation plan, what else may change, the success check, and
whether it is planned, in progress, or complete. Record decisions here after
leaving Plan mode so another chat can continue without the old conversation.

## Verification and known limits

The handoff preparation reviewed the README, project metadata, and relevant
source files. Local Markdown links resolve; setup and Plan mode guidance were
checked against official Claude and GitHub documentation. The starting game
was **not built or played during this docs-only
update**. Existing README claims about past testing are historical, not a new
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
push these notes with the corresponding change under the owner's authorization.
