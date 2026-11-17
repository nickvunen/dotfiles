---
name: game-character-animation
description: Create or refine game characters and animations from an existing visual design using Meshy, Mixamo, and Blender, with GLB and sprite-sheet exports for mobile JavaScript games. Use for character reference sheets, modeling, rigging, animation polish, and exports; not general game rules or unrelated illustrations.
---

# Character & Animation Flow

## Context and boundaries

- Target: mobile game in plain JavaScript, no game engine; mostly 2D rendering, with 3D tactical fights. Inspect the current project before choosing integration details.
- Follow the existing character design. Do not invent a new style. Obtain the existing reference if missing.
- Ask before spending paid credits or changing the art style. Check current Meshy pricing, plan limits, licensing, and attribution before use; do not assume a paid plan is needed or authorized.
- Meshy: image-to-3D from reference views. Mixamo: humanoid auto-rigging and motion-capture clips, using the user's personal Adobe ID. Verify current service terms when needed.
- Blender is mandatory for cleanup, polish, and export. Use Blender MCP directly when available; otherwise provide complete runnable `bpy` scripts and explain the expected result.
- Keep replies short and clear. Do one character fully, including an early in-game phone test, before starting the next. If device testing needs the user, report that gate and wait for results before scaling production.

## Workflow

1. **Lock the look.** Produce a clean front/side/back reference sheet from the existing design, with the same neutral T-pose or A-pose and a plain background. Use the image-generation skill/tool when appropriate.
2. **Model from reference.** Use Meshy image-to-3D with those views, not text-only generation. Export FBX or GLB.
3. **Clean in Blender.** Fix topology and stray geometry, reduce polygon count for mobile, apply scale and rotation, place the origin at the feet, and unify materials across characters.
4. **Rig for reuse.** Rig humanoids with Mixamo and maintain a shared skeleton convention and bone names. Verify rest poses, proportions, weights, and clip compatibility; shared names alone do not guarantee animation reuse. Retarget or adjust where needed. Nonhumanoids need an appropriate Blender rig rather than Mixamo humanoid auto-rigging.
5. **Use real motion, then polish.** Download Mixamo FBX clips, using “in place” where offered. Import into Blender and fix seamless loops, timing, foot sliding, and jitter. Core clips: `idle`, `walk`, `attack`, `hit`, `death`; add others only when needed. Loop cyclic clips appropriately; preserve intentional one-shot endings for attack, hit, and death.
6. **Export both modes from the same model.**
   - 3D fights: one GLB per character containing mesh, rig, and all clips. Keep polygons and textures small; use compression supported by the game's loader.
   - 2D parts: render each clip to PNG sprite sheets with fixed camera and lighting, plus JSON containing frame size, frame count, and fps. Include layout information needed to locate frames.
7. **Test early in the game.** Check both relevant render modes on a real phone, at actual on-screen size. Assess appearance, animation playback, scale, loading, memory, and frame rate before producing the next character. Do not claim device verification without evidence.

## Consistency and integration

- Use the same skeleton convention, scale, camera, lighting, and naming across characters.
- Name clips/assets `charactername_clip`, lowercase, no spaces; example: `knight_idle`.
- Never overwrite source files. Save cleaned and exported versions separately.
- Diagnose quality problems at their source: reference, mesh, rig weights, or clip. Fix that stage instead of regenerating everything.
- Reuse the project's established JavaScript rendering patterns. For GLB, a glTF loader such as Three.js `GLTFLoader` plus `AnimationMixer` is suitable when consistent with the project. Play sprite sheets using their JSON frame metadata.
