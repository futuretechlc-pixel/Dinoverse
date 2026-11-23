# Dinoverse | Godot 4.7.1 Visual Foundation

The production engine is now **Godot 4.7.1**. This repository contains the first native Godot visual-foundation pass for the Emerald Jungle.

## Current visual foundation
- Stylized jungle composition with layered canopy clusters, tree trunks/branches, fern understory, mossy ground forms, riverbank stones and ancient ruins.
- Filmic environment setup, warm directional sunlight with cascaded shadows, green bounce fill, atmospheric fog and restrained glow.
- Procedural Velociraptor companion with articulated body sections, head/neck, tail segments, limbs, toes, claws and amber eyes.
- Explorer placeholder, third-person follow camera, mouse orbit, WASD movement and sprint.
- Animated water shader with moving wave displacement and specular highlights.

## Run
1. Install Godot **4.7.1**.
2. Import this folder in the Godot Project Manager.
3. Open `project.godot` and run the main scene.

Controls: WASD/arrows move, Shift sprint, hold right mouse and drag to orbit, Esc releases the mouse.

## Quality status
This is a visual improvement over the previous browser blockout, but it is **not final production art**. The dinosaur and explorer remain procedural stand-ins. Production assets still require authored meshes, UVs, PBR texture sets, a proper skeleton, high-quality animation clips, foot IK and facial rigging.

## Validation limitation
The current execution environment does not include the Godot editor/runtime. No editor import, runtime screenshot, Android export or FPS result is claimed. The first Godot 4.7.1 editor run is required to validate parser/import warnings and visual output.

See [docs/ART_QUALITY_GATE.md](docs/ART_QUALITY_GATE.md) for the non-negotiable visual and animation acceptance criteria.
