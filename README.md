# Dinoverse | Godot 4.7.1

Dinoverse is a stylized 3D dinosaur action-adventure for PC and mobile. The approved first vertical slice is **Emerald Jungle**, with a third-person explorer and a Velociraptor companion. Visual quality and animation are the current production priority.

## Visual asset setup

The project now uses real GLB assets instead of presenting primitive blockouts as final characters. Before opening the project for the first time, run:

```bash
python tools/fetch_visual_assets.py
```

This downloads the Velociraptor and three tropical environment models into `assets/`. Then open `project.godot` with **Godot 4.7.1** and let the editor import the GLB files.

The bootstrap sources are free for commercial game use. Read `docs/ASSET_LICENSES.md` before redistributing the raw meshes.

## Controls

- `WASD`: move
- `Shift`: sprint
- Hold right mouse button and drag: orbit camera
- `Esc`: release mouse capture

## Current visual implementation

- Real GLB Velociraptor mesh with 3,938 triangles and named articulated pivots.
- Runtime controller blends idle, walk, and run motion through the model's neck, head, jaw, tail, arms, and hind-leg pivots.
- Bite, roar, and hit action hooks are available to gameplay code.
- Tropical GLB trees, ferns, shrubs, rocks, and ground-cover assets are fetched by the same bootstrap script and scattered through Emerald Jungle.
- Existing Godot environment, water shader, ruins, camera, and explorer foundation remain in place.

## Important quality boundary

The downloaded Velociraptor is a lightweight stylized gameplay asset, not a cinematic hero model. Its parts are articulated pivots rather than a skinned deformation skeleton, and the current animation controller is procedural. It replaces the primitive placeholder, but it does **not** yet satisfy the final hero-character gate for authored skeletal animation, secondary motion, and high-detail close-up presentation. That remaining gate is documented in `docs/ART_QUALITY_GATE.md`.

## Validation

The GitHub Actions workflow **Dinoverse Visual Gate** downloads the GLB assets, imports the project in Godot 4.7.1 headless mode, runs a startup smoke test, and packages the project as an artifact. A workflow pass is the first actual engine-side validation; local source edits alone are not treated as a successful build.
