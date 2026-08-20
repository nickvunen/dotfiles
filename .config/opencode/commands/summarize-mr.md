---
description: Summarize current changes as an MR/PR description (raw markdown block)
---
Summarize the changes for a merge request. Extra scope/context from the user: $ARGUMENTS

If no context was given, inspect the changes first: `git status`, `git diff`, and the diff against the base branch.

Output ONLY a fenced `md` code block containing this exact template, filled in:

````md
## Summary of changes

{summary of changes IN SHORT — 1-3 sentences or bullet list, no fluff}

## Test instructions

{instructions on how to test it, SHORT and compact — commands + expected result}
````

Rules:
- Wrap the whole response in a ```` ```md ... ``` ```` fence so it renders as raw markdown source, not rendered markdown.
- No preamble, no explanation, no persona flourishes. Just the code block.
- Keep both sections tight. Drop rationale, background, alternative approaches — an MR description is not a design doc.
