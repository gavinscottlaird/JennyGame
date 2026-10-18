# Plan with Claude before building

**Make sure Claude understands what you want before it spends your time and
your limited Claude usage building it.** You can do that through an ordinary
conversation. You do not need to write a polished prompt or a technical plan.

## Why skipping this can cost you more time

"Make the game easier" could mean easier words, larger buttons, fewer choices,
or different scoring. If Claude guesses wrong, you wait for the wrong change,
try it, explain the mismatch, and wait for it to be redone. Each round uses more
of your time and Claude allowance.

A brief planning conversation catches that mismatch while it is still just
an idea. Planning also uses your allowance; it is not free and does not
guarantee lower usage. The aim is to avoid unnecessary rebuilding. Keep it
short and focus on one change at a time.

## Why do the planning here, with Claude?

Claude Code can read **this game's actual files**: how its buttons behave, how
it awards points, and what the last person changed. It needs to inspect them
first; it does not automatically know everything about the game.

A separate AI chat can help you brainstorm, but unless it has the current
project, it is planning from what you describe. Its suggestions may depend on
features the game does not have or miss a connection to scoring or saved data.
You then spend time explaining that plan to Claude and untangling the mismatch.

Bring your ideas straight to Claude Code and let it plan against the real game.
If you already have notes from another AI, paste them here as **ideas to check**,
then ask Claude to read the game and work out the plan with you before building.

## Turn on Plan mode

In Claude Code's desktop interface, choose **Plan** from the permission mode
selector. In the terminal interface, press **Shift+Tab** until the status shows
Plan mode. Labels can vary by version; ask Claude to help you find the control
if your screen differs.

Plan mode lets Claude inspect the project and propose an approach before
changing the game. Saying "let's plan first" is useful, but is not proof the
interface switched modes. Check the mode shown on screen.

Source: Claude's official guides to
[planning before editing](https://code.claude.com/docs/en/common-workflows#plan-before-editing)
and [desktop permission modes](https://code.claude.com/docs/en/desktop#choose-a-permission-mode).

## Have a short conversation

Say something like:

> I want it to be easier for kids to know which button to press. Read how the
> game works, then help me decide what to change. Explain your plan simply
> before you start building.

Claude should do the homework, explain what it thinks you mean, and ask only
the questions that change the result. You can reply "No, I mean..." or "Yes,
that's it." You do not have to tell it which code files to change.

Before building, you should be able to recognize these three things:

1. **The result:** what the player will see or do differently.
2. **The boundary:** what else, if anything, will change, such as points or saved scores.
3. **The check:** how you and Claude will tell whether it worked.

For example, "I'll make the picture buttons larger, keep the scoring rules,
and check that the buttons still fit and can be clicked" is a plan you can
agree to or correct. You do not need a long design document.

When it matches your idea, approve the plan in the interface and say **"Yes,
build that."** Leave Plan mode using the offered approval controls or mode
selector so Claude can edit. It should save the agreed plan in the handoff
notes, make the change, check it, and upload the work to a task branch in the
shared repo. It should open a pull request for review before the change is
merged into the shared `main` version. See [Work together](WORKING_TOGETHER.md).

## Keep it practical

Use Plan mode for new features, unclear requests, layout changes, or changes to
scoring and saving. A clear typo fix usually needs only a quick confirmation
of what will change, not a whole planning session.

If Claude has misunderstood, say "Pause. That's not what I meant. Let's fix the
plan first." If the result looks wrong, describe what you see. Claude should
work out the cause and update the plan with you when the intended result changes.

Your job is to say what feels right for the game. Claude's job is to turn that
into a workable plan and handle the technical work.
