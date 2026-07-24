// loom-question — opencode plugin
//
// Grants Loom (Weave's main orchestrator) access to the built-in `question`
// tool, which opencode otherwise gates to the plan agent.
//
// Weave registers Loom under the display name "Loom (Main Orchestrator)" via
// its own `config` hook. This plugin must run AFTER Weave, so it is listed
// after "@opencode_weave/weave" in opencode.json. The `config` hook mutates
// the already-merged agent map, adding `permission.question: "allow"`.
//
// Update-safe alternative to patching Weave's cached dist/index.js.

export default async () => ({
  config: async (config) => {
    const agents = config.agent;
    if (!agents) return;
    for (const [key, agent] of Object.entries(agents)) {
      if (!agent) continue;
      const isLoom = key === "loom" || key.toLowerCase().startsWith("loom");
      if (!isLoom) continue;
      agent.permission = { ...(agent.permission ?? {}), question: "allow" };
    }
  },
});
