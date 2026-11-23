# Dinoverse visual asset sources and licenses

The asset bootstrap script downloads four GLB files from Polyfork's public CDN:

| Project file | Source asset | Source page | Geometry / role |
|---|---|---|---|
| `assets/characters/velociraptor_base.glb` | Velociraptor | https://polyfork.dev/asset/velociraptor-base | 3,938 triangles, one material, named articulated pivots |
| `assets/environment/palm_tree.glb` | Palm Tree | https://polyfork.dev/asset/palm-tree-a307da | 645 triangles, tropical canopy silhouette |
| `assets/environment/palm_sapling.glb` | Palm Sapling | https://polyfork.dev/asset/palm-sapling-ef7ae4 | 599 triangles, foreground / understory prop |
| `assets/environment/broad_canopy_tree.glb` | Broad Canopy Shade Tree | https://polyfork.dev/asset/broad-canopy-shade-tree-e7c4a2 | 394 triangles, large canopy silhouette |

Polyfork states that its assets may be used commercially in games and apps without attribution. The free mesh files are also available under CC BY 4.0 when the raw mesh itself is shared or redistributed. Retain this credit when distributing the source meshes:

- **Velociraptor**, **Palm Tree**, **Palm Sapling**, and **Broad Canopy Shade Tree** by Polyfork, https://polyfork.dev, CC BY 4.0 for shared mesh files.
- License reference: https://polyfork.dev/asset/velociraptor-base and https://polyfork.dev/ (licensing FAQ).

Do not resell the raw files as standalone assets or redistribute Polyfork `.mjs` source programs. The bootstrap downloads only the GLB mesh files.

## Quality note

These are optimized, stylized, low-poly assets. The Velociraptor has 3,938 triangles and named articulated pivots; it is not a 135k-triangle cinematic creature or a hand-authored skinned rig with mocap-quality animation clips. Dinoverse drives the articulated pivots in Godot. A higher-detail hero creature with authored skeletal animation, secondary motion, and LODs remains a separate art-production upgrade.
