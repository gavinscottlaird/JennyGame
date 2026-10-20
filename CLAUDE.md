# Working on JennyGame / Pixel Problem Solver

## Help the person, not just the code

The incoming collaborator is a beginner who wants to talk naturally and have
you do the technical work. Use short, plain explanations. Accept rough ideas and
ordinary language; do not require prompt templates, code knowledge, or a
technical specification. Ask one useful question at a time, offer a sensible
default when possible, and handle routine implementation choices yourself.

## Start each session

1. Read `docs/HANDOFF.md` for the current task, agreed decisions, verification
   gaps, and shared repository destination. Read relevant parts of `README.md`
   and inspect the actual game files before making claims about behavior.
2. Inspect Git status, the current branch and tracking branch, and remote fetch
   and push URLs. Preserve existing work. In editing mode, fetch the confirmed
   working remote when available; fast-forward only when clean and safe. In
   Plan mode, defer Git mutations until editing is enabled. Inspect open pull
   requests when accessible so you know what the other person is working on.
3. The agreed shared repo is `https://github.com/gavinscottlaird/JennyGame.git`,
   with `main` as the shared integration branch. Guide new collaborators through
   `docs/WORKING_TOGETHER.md`: their own account, an accepted invitation, and a
   local clone. Verify access; do not assume the invitation is already accepted.
   Reuse an existing clone and preserve local edits. Do not create a separate
   repo or redirect `origin` unless the user explicitly chooses independence.

Read other guides as needed; do not reread every document on each small task.
Treat handoff notes as context to verify, not proof of the current Git state.

## Get aligned before building

- For a feature, unclear request, or meaningful behavior/layout change, inspect
  the relevant code and plan with the user here in Claude Code. Explain the
  visible result, scope, and how you will check it in a few sentences.
- Recommend native Plan mode and help the user find it. Do not claim to enable
  a mode unless you can verify it. In Plan mode, keep project/Git mutations out
  of the planning phase; use its supported plan mechanism.
- Wait for agreement before implementing a new plan. Honor existing approval;
  do not repeatedly ask permission for the same agreed work. Keep clear, small
  fixes brief. Ask about a changed outcome, not every technical decision.
- Once approved and editing is enabled, save the agreed plan and success check
  in `docs/HANDOFF.md` before implementation. Keep it current if scope changes.
- Treat outside AI plans as suggestions. Check them against the current game,
  resolve mismatches in plain language, and agree on a feasible plan here.
- Keep planning proportional. Avoid speculative research, large rewrites, or
  long reports that spend the user's limited time and usage without benefit.

## Maintain the shared repository as part of doing the work

After the user authorizes ongoing commit/push and pull requests as described in
`docs/WORKING_TOGETHER.md`, treat that as standing authorization for ordinary
checkpoints, task-branch uploads, and pull requests there. Do not make the user
remember Git commands or repeat permission each time. Respect later changes
and tool permissions. Upload permission alone does not authorize merging.

For a new task, start a separate, clearly named branch from updated `main`
once editing is enabled. For an unfinished task, continue its existing branch
after checking the handoff and remote state. Do not put unrelated tasks on
another person's branch or routinely push feature work straight to `main`.

For each completed, coherent change:

1. Check the changed behavior with the tools available. For game changes, use
   GameMaker when available. If you cannot run it, say so and give the user a
   short, specific play check; never claim an unrun test passed.
2. Update `docs/HANDOFF.md` with the result, decisions, checks actually done,
   remaining issues, and the next action. Update the README or beginner guides
   when behavior or instructions change. Keep shared knowledge in tracked docs,
   not only chat, private plan files, or machine-local memory.
3. Review the diff and status. Stage the intended source and docs explicitly;
   keep unrelated user edits out unless asked to include them. Never upload
   credentials, real player logs, generated builds, or machine-specific files.
4. Commit the work and notes with a clear message. Push to the shared repo's
   task branch, preserving history. Verify the remote commit matches the local
   one, then open or update its pull request with a brief result and checks.
   If PR creation is unavailable, keep the uploaded branch and give the user a
   comparison link or the exact next step. Do not claim a PR exists if it failed.
5. Report briefly: what changed, what was checked or still needs checking,
   and whether it is **saved on GitHub**. Include the repo/commit link when
   available. Distinguish **saved on GitHub (task branch)** from **merged into
   main**, and mention any uncommitted work. Share the PR link for review.

Merge only under explicit user authorization or an already-agreed merge policy,
after appropriate review/checks and repository requirements. Include changes
from current `main` before merging when needed, resolve conflicts preserving
both people's intent, and recheck affected behavior. Do not blindly choose
"ours" or "theirs". Reconcile both people's handoff notes instead of discarding
one version. Get the updated `main` before starting the next independent task.
Before switching to another version while GameMaker is open, have the user save
and close/reload the project as needed so unsaved editor changes are preserved.

Do not force-push, discard work, rewrite shared history, or push to an
unconfirmed destination. If a push is rejected, fetch and inspect the cause;
resolve only when both versions can be preserved and intent is clear. For a
protected branch, follow its requirements and explain where the work is saved.
Do not bypass repository protections. A shared GitHub repo does not synchronize
another person's local files automatically; they need to fetch/pull updates.

If upload is blocked by sign-in, network access, or permissions, preserve the
work locally and commit if possible. Record the pending upload in the handoff
and include that note in a local commit if possible; say **saved locally; not
uploaded to GitHub**. Give the smallest next step. Retry pending uploads when
access returns. Do not promise background syncing after the session ends.

If stopping mid-task, preserve a clear checkpoint and mark unfinished work and
unrun checks honestly. Do not present an incomplete change as finished. A
planning-only conversation still needs its agreed decisions saved once editing
is enabled, without inventing a completed feature.

## Project constraints and verification

- This is GameMaker/GML. Open `JennyGame.yyp`; its recorded IDE version is
  `2024.14.4.222`. There is no checked-in automated test suite or build script.
  Do not invent a passing test command or silently upgrade project format.
- The README maps the screens, scoring rules, art, scenarios, and save behavior.
  Preserve the existing scoring/learning rules and player data unless the
  requested change requires otherwise; explain any proposed change to them.
- Keep player-facing wording short and simple, consistent with the existing
  second-grade reading-level goal. Art is drawn from code; the font is a resource.
- Keep `.yyp` and `.yy` resource references consistent when adding resources.
  GameMaker files can contain trailing commas; ordinary JSON parsing alone is
  not a valid GameMaker build check. Keep generated `output/` out of Git.
- Update `GAME_VERSION` in `scripts/scr_config` with every game change; the
  title screen shows it so testers can tell which copy they are running.
- Use made-up names for play checks. Player logs live outside the project in
  `%LOCALAPPDATA%\JennyGame\pps_log.json` on Windows; do not publish them.
- Scale checks to the change. For gameplay changes, the handoff has a baseline
  play checklist. For docs-only work, check paths, links, and consistency; a
  new game build is not required.

These are project instructions, not an automatic sync service or an enforcement
mechanism. Claude Code loads `CLAUDE.md` as project context; see
[the official memory guide](https://code.claude.com/docs/en/memory).
