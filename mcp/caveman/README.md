# caveman-mcp

MCP server that makes every agent talk short and plain: TLDR, KISS, readability first.
The style rules travel in the server's `instructions` field, so any MCP client that
injects server instructions (opencode, Claude Code, ...) applies them to all agents,
including subagents.

Tools: `caveman_off` / `caveman_on` switch the style for the current conversation.

## Install

```sh
npm install   # also builds dist/
```

opencode (`opencode.json`):

```json
"mcp": {
  "caveman": { "type": "local", "command": ["node", "/Users/nickvanunen/dotfiles/mcp/caveman/dist/index.js"], "enabled": true }
}
```

Claude Code:

```sh
claude mcp add caveman --scope user -- node ~/dotfiles/mcp/caveman/dist/index.js
```
