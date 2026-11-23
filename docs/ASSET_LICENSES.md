# Dinoverse visual asset sources and licenses

The asset bootstrap script downloads four GLB files from Polyfork's public CDN:

| Project file | Source asset | Source page | Geometry / role |
|---|---|---|---|
| `assets/characters/velociraptor_base.glb` | Velociraptor | https://polyfork.dev/asset/velociraptor-base | 3,938 triangles, one material, named articulated pivots |
| `assets/environment/palm_tree.glb` | Palm Tree | https://polyfork.dev/asset/palm-tree-a307da | 645 triangles, tropical canopy silhouette |
| `assets/environment/palm_sapling.glb` | Palm Sapling | https://polyfork.dev/asset/palm-sapling-ef7ae4 | 599 triangles, foreground / understory prop |
| `assets/environment/broad_canopy_tree.glb` | Broad Canopy Shade Tree | https://polyfork.dev/asset/broad-canopy-shade-tree-e7c4a2 | 394 triangles, large canopy silhouette |\n| `assets/environment/fern.glb` | Fern Plant | https://polyfork.dev/asset/fern-plant-1559b8 | 626 triangles, understory foliage |\n| `assets/environment/round_bush.glb` | Round Bush | https://polyfork.dev/asset/round-bush-cd2ac0 | 512 triangles, low shrubs |\n| `assets/environment/small_rock.glb` | Small Rock | https://polyfork.dev/asset/small-rock-db33a7 | 202 triangles, shoreline scatter |\n| `assets/environment/medium_rock.glb` | Medium Rock | https://polyfork.dev/asset/medium-rock-e08405 | 173 triangles, larger ground scatter |\n| `assets/environment/grass_tuft.glb` | Grass Tuft | https://polyfork.dev/asset/grass-tuft-a40a08 | 368 triangles, ground cover |

Polyfork states that its assets may be used commercially in games and apps without attribution. The finished game may ship the models embedded inside the game. Do not redistribute the raw GLB files as a standalone asset pack or through a separate file-sharing service. If a raw free mesh is independently shared under CC BY 4.0, retain this credit:

- **Velociraptor**, **Palm Tree**, **Palm Sapling**, **Broad Canopy Shade Tree**, **Fern Plant**, **Round Bush**, **Small Rock**, **Medium Rock**, and **Grass Tuft** by Polyfork, https://polyfork.dev, CC BY 4.0 (only if independently sharing a raw mesh).
- License reference: https://polyfork.dev/asset/velociraptor-base and https://polyfork.dev/ (licensing FAQ).

Do not resell the raw files as standalone assets or redistribute Polyfork `.mjs` source programs. The bootstrap downloads only the GLB mesh files.

## Quality note

These are optimized, stylized, low-poly assets. The Velociraptor has 3,938 triangles and named articulated pivots; it is not a 135k-triangle cinematic creature or a hand-authored skinned rig with mocap-quality animation clips. Dinoverse drives the articulated pivots in Godot. A higher-detail hero creature with authored skeletal animation, secondary motion, and LODs remains a separate art-production upgrade.
