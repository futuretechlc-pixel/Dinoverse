# Dinoverse Art & Animation Quality Gate

No expansion of quests, regions, or multiplayer until this gate is passed.

## Environment
- Layered foreground / midground / background foliage with readable silhouettes.
- Real tropical GLB tree assets, varied scale and rotation, and a clear river / ruins composition.
- Natural material breakup: bark, moss, leaf translucency, wet stones and soil.
- Directional sunlight, soft fill, controlled fog, stable shadows and water reflections.
- Stable target frame rate on representative Android hardware and desktop.

## Velociraptor gameplay asset
- GLB model with named articulated pivots integrated into Godot.
- Runtime idle, walk and run blending for legs, arms, neck, head and tail.
- Bite, roar and hit action hooks.
- No missing model nodes or broken GLB imports.

## Final hero-character gate (not yet passed)
- Production mesh with clean topology, UVs and PBR maps.
- Correct proportions, expressive head / eyes, articulated jaw, claws and tail.
- Skinned rig for spine, neck, head, jaw, tail chain, shoulders, hips, knees, ankles and toes.
- Authored idle, alert, walk, trot, sprint, turn, stop, attack, roar, hit, eat, sleep and death clips.
- Blended transitions, foot locking, root-motion policy, secondary tail / head motion and hit response.
- LODs suitable for mobile and desktop.

## Acceptance
- No visible foot sliding during walk / run cycles.
- No mesh intersections in core locomotion and attack poses.
- No camera clipping through companion or major environment pieces.
- Readable silhouette and clear value hierarchy at gameplay camera distance.
- Mobile quality tier maintains stable frame pacing without removing the scene's visual identity.

## Current state
The primitive raptor has been replaced in the project source by a real articulated GLB asset and a runtime controller. Tropical GLB trees are integrated into the environment scatter path. This is a concrete visual upgrade, but it is **not** a final hero-character pass: the model is low-poly and pivot-articulated, and the controller uses procedural motion rather than authored skeletal clips. The GitHub Actions visual gate must pass before this integration is considered engine-validated.
