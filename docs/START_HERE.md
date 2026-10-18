# Start here: work on the game together

You decide what the game should do. Claude handles the code, the notes, and saving
the work. Talk to it like a person. You do not need special prompts.

## 1. Open the game folder in Claude Code

Use **Claude Code**, with this project's folder selected. In Claude Desktop,
choose the **Code** tab, **Local** environment, and this project folder. A
separate, ordinary AI chat does not automatically have access to these files.

The right folder contains `JennyGame.yyp`, `README.md`, and `CLAUDE.md` together.
If you downloaded a ZIP, extract it first. Keep the whole folder together.

If you need help installing or opening Claude Code, start with the
[official setup guide](https://code.claude.com/docs/en/quickstart).
For the desktop interface, see the
[official desktop guide](https://code.claude.com/docs/en/desktop).

Say this, or use your own words:

> I'm working on this game with Gavin and I don't code. Read CLAUDE.md and
> docs/HANDOFF.md. Help me connect to our shared repository and get up to date.
> Commit and push my work on its own task branch and open a pull request when
> it's ready. Don't merge it until I approve. Guide me one step at a time and
> do the technical parts for me.

## 2. Connect to the shared game

Follow [Work together](WORKING_TOGETHER.md) with Claude. You need your own
GitHub account and an invitation from Gavin to contribute to the shared repo.
You each keep a local copy on your own computer, connected to the same project
on GitHub. Claude handles downloading updates and uploading your work.

## 3. Try the starting game

Open `JennyGame.yyp` in GameMaker and press **Run**. The project records GameMaker
version **2024.14.4.222**. If you need help getting it running, tell Claude what
you see and let it walk you through setup.

Try **Play**, pick a character, enter a made-up name such as `TestPlayer`, choose
a focus, then choose some picture buttons. Press **Check what happens**, write
your guess, and press Enter. This shows you what you are starting from.

If an error appears, copy its text or show Claude a screenshot. You do not have
to explain the code. Claude may need you to click Run or check something on
screen; it should tell you exactly what to do.

## 4. Tell Claude what you want, then agree on the plan

Read [Plan with Claude before building](PLAN_WITH_CLAUDE.md). For example:

> I want the buttons to be easier for kids to understand. Let's plan it before
> changing anything. Read how the buttons work and tell me what you suggest.

Correct Claude if its explanation does not match your idea. Once it does, say
"Yes, build that." You choose the result; Claude works out how to make it.

## When you come back

Open the **same folder**, start a Claude Code chat, and say:

> Read CLAUDE.md and docs/HANDOFF.md, check our shared repo and any open work,
> and help me pick up where we left off.

You can also say "I'm done for today. Save our work and leave notes for next
time." Check Claude's final message for **saved on GitHub**, or a clear reason
it could not upload. Work saved on a task branch joins the shared `main` version
after review and merging. A chat saying "done" is not proof of either step.

These documents travel with the game. Old chats and Claude's personal memory
may not travel to a new computer, account, or helper, so Claude must keep the
handoff notes current.
