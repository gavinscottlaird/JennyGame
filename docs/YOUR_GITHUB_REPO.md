# Optional: create an independent GitHub copy

**For working on this game with Gavin, use [WORKING_TOGETHER.md](WORKING_TOGETHER.md)
instead.** You each need an account and a local copy, and both contribute to
the shared repo. The steps below are only for choosing a separate version that
will have its own history of future changes.

## Why this is worth doing once

A **repository**, or **repo**, is the game's folder plus its change history.
**Git** records that history. **GitHub** stores an uploaded copy online.

Your own repo gives you a place you control, checkpoints to recover from a bad
change, and a way to move to another computer or hand the game to someone else.
You can experiment independently. Changes in this separate repo do not
automatically reach the shared game, and shared-game updates do not
automatically reach this copy.

There are three different kinds of saving:

| What happens | What it means |
| --- | --- |
| Save a file | The changed file is on this computer. |
| Commit | Git records a named checkpoint on this computer. |
| Push | Those checkpoints are uploaded to GitHub. |

**A commit alone does not upload your work.** Claude should do both the commit
and the push after each completed change. The shared workflow also saves task
branches, then combines them through pull requests. GitHub stores the game project; the
game's player scores stay on the computer where the game was played.

## 1. Create an empty repo under your account

1. Sign in to [GitHub](https://github.com) or create your own account.
2. Open [Create a new repository](https://github.com/new).
3. Make sure **Owner** is your account. Choose a name, such as `MyJennyGame`.
4. Choose **Private** for your working copy unless you want the code visible to everyone.
5. Leave the options to add a README, a .gitignore, and a license **off**. This project already has files; the new repo should start empty.
6. Click **Create repository**. Copy its HTTPS address from the setup page. It will look like `https://github.com/YOUR-NAME/MyJennyGame.git`.

Keep passwords and sign-in codes in GitHub's sign-in window. Claude needs the
repo address, not your password.

## 2. Let Claude connect the game to it

Return to Claude Code with this game's folder open. Paste your real repo address
into a message like this:

> This is my new repository: PASTE THE ADDRESS HERE. Connect this game to it,
> preserve the starting game and any existing history, and upload it. From now
> on, commit and push each completed change to my repository, including the
> handoff notes. Do the technical steps for me and tell me if anything cannot
> be uploaded.

Claude should handle the Git commands. If Git is missing or sign-in is needed,
it should give you one setup step at a time. You may need to complete a browser
sign-in or approve an action in Claude's interface.

If you downloaded a ZIP, tell Claude. A ZIP contains the files but does not
include the Git history. Claude can start a new history from those files without
deleting your work.

## 3. Check that it worked

Ask Claude to open or link your repo. Refresh it on GitHub and check:

- The address starts with **your** account name.
- You can see `JennyGame.yyp`, `CLAUDE.md`, and the `docs` folder.
- You can see a recent commit containing the uploaded project or handoff setup.

You are ready when Claude confirms the upload succeeded and records your repo
address in `docs/HANDOFF.md`. You should not need to repeat this setup next time.

## Instructions for Claude during setup

Read these together with [CLAUDE.md](../CLAUDE.md):

- Use this procedure only after the user explicitly chooses an independent
  repo. Do not redirect a collaborator away from the shared repo by default.
- Inspect the working folder, Git status, branch, remotes, and existing local
  changes first. Verify the supplied destination belongs to the user or is one
  they explicitly authorized. Do not guess an account or create a second repo
  if the correct one is already connected.
- For a clone whose `origin` is Gavin's source, preserve that remote as
  `upstream` if the name is free, then connect the user's destination as
  `origin`. Inspect any existing `upstream` before changing remote names.
  Confirm both fetch and push URLs point where intended and set the branch's
  tracking destination to the user's repo when first pushing.
- Preserve existing Git history. For extracted files with no `.git` directory,
  initialize Git in the project root and commit the reviewed starting files.
  Never remove `.git` to fix setup. Check `.gitignore` and exclude generated
  output, credentials, and player logs from uploads.
- If the destination already contains work, inspect it before proceeding.
  Preserve both versions and explain any conflict. Do not force-push or replace
  remote history to make setup easier.
- Record the confirmed destination in `docs/HANDOFF.md`, commit the setup notes,
  and push. Verify the pushed branch matches its remote commit. Report the repo
  link and whether the upload actually succeeded.

Reference: GitHub's guides to
[creating a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
and [uploading an existing project](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github).
