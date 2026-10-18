# Work together on the same game

**Use one shared GitHub repository:**
[gavinscottlaird/JennyGame](https://github.com/gavinscottlaird/JennyGame).
Gavin owns this repo and can invite another person to contribute. Each person
uses their own account and their own local copy of the game.

Think of GitHub as the shared project shelf. Claude gets the latest version
from the shelf before starting and puts your work back when it is ready. It
does not appear on the other person's computer until they download the update.

## One-time setup

1. **She creates a GitHub account** if she does not already have one, and gives Gavin her username.
2. **Gavin opens this repo on GitHub:** Settings > Collaborators > Add people. Select her account and send the invitation.
3. **She accepts the invitation** while signed in to her own account.
4. **Claude helps her clone the shared repo** onto her computer, then open that folder in Claude Code and `JennyGame.yyp` in GameMaker. "Clone" means download a working copy with its change history and connection to GitHub.

She can tell Claude:

> Gavin invited me to https://github.com/gavinscottlaird/JennyGame. Help me
> clone it and open it on my computer. Use that shared repo for this game.
> Commit and push my work on a separate task branch and open a pull request
> when it's ready. Don't merge it until I approve.

If she already has a clone of this repo, Claude should reuse it. If she has an
extracted ZIP or a separate repo with edits, tell Claude before continuing so
it can preserve those edits and bring them into the shared project.

Sign in through GitHub's own sign-in flow. You each use your own account;
passwords and sign-in codes do not belong in chat.

Source: GitHub's guides to
[inviting a collaborator](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/inviting-collaborators-to-a-personal-repository)
and [cloning a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

## The everyday routine

You can say: **"Get us up to date, then let's plan my change."** Claude should
handle the Git work and explain anything that needs a decision.

- **Start:** get the current shared version and read the handoff notes and open work.
- **Plan:** agree on the result before building, using [Plan mode](PLAN_WITH_CLAUDE.md).
- **Build and check:** work on a separate task branch and try the changed behavior.
- **Save:** commit and push the task, including its notes, and open a pull request.
- **Combine:** review the result, approve merging, and then get the updated shared version on both computers.

A **branch** is a place to work on one change without immediately changing the
shared `main` version. A **pull request** is the page where you review that
change before combining it into `main`. Claude should give you the link and a
plain explanation of what to try. You can ask your AI to help review it.

**"Saved on GitHub" and "merged into main" are different milestones.** An
uploaded branch is backed up and available for review. After it is merged, the
other person can pull the combined version into their local copy.

This routine follows [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow).

## If you both work at the same time

Work on different tasks and tell each other the area you are changing, such as
"I'm working on the buttons." Separate branches help keep the tasks apart, but
both people can still make changes that disagree when they are combined.

If both tasks need the same screen or file, finishing and merging one first is
often easier. If Git reports a **conflict**, Claude should inspect both changes
and preserve both people's intended work. If the ideas disagree, it should ask
you which behavior you want. It should never solve this by overwriting the
other person's work or force-pushing.

Source: GitHub's explanation of
[merge conflicts](https://docs.github.com/en/pull-requests/reference/merge-conflicts).

When you finish, say **"Save my work and leave notes for the next person."**
Claude should upload the task branch and report what still needs testing,
review, or merging. The other person can then continue from the same branch
or start a fresh task from the updated `main`.

## When would a separate repo make sense?

Use [the separate-repo guide](YOUR_GITHUB_REPO.md) only if you deliberately want
an independent version. For developing this game together, keep using the
shared repo. Creating another repo is not required for collaboration.
