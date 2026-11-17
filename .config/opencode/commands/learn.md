---
description: Save durable learnings from this session to basic-memory (propose, confirm, then write)
---
Capture what we learned in this session into basic-memory. Optional focus from the user: $ARGUMENTS

If a focus was given, capture ONLY that topic. Otherwise scan the whole session.

## 1. Pick the project
- Derive the basic-memory project from the current repo/cwd (`git rev-parse --show-toplevel`, repo name). Match it against `bm_project(command="list")`.
- Unclear or no match: ask which project to use, with a recommended option.

## 2. Extract candidates
Look for things worth knowing in a future session:
- **Decisions + why**: choices made and the reason behind them.
- **Gotchas / failed approaches**: what broke or wasted time, and what fixed it.
- **User preferences**: how Nick wants things done (style, workflow, tone).
- **Project facts**: commands, structure, env setup, where things live.

Skip: anything already obvious from the code or README, one-off task details, stable rules that belong in AGENTS.md (mention those separately as a suggestion instead).

## 3. Dedup
For each candidate, `bm_search` the project first. If a note on the same topic exists, plan an edit to it (`bm_read` then `bm_edit` with checksum), not a new note.

## 4. Propose, then confirm
Show a short numbered list, one line per learning:
`N. [new|update: <note path>] <title> — <one-line learning>`

Then ask (question tool): save all / pick which / edit. Do NOT write before confirmation.

## 5. Write
- One topic per note, titled `<project> - <topic>`. Keep notes short.
- Use basic-memory observation format, e.g. `- [decision] use X because Y`, `- [gotcha] ...`, `- [preference] ...`, `- [fact] ...`.
- Add relations to related existing notes when obvious.
- No dates, ticket numbers or session narration in the note body unless they are the learning itself.

## 6. Report
One line per written note: path + new/updated. Nothing else.
