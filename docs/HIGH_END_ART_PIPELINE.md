# Dinoverse High-End Character Production Brief

This is the hand-off specification for replacing the interim Velociraptor GLB with the final hero creature. It is specific enough for a 3D generation / rigging service or a character artist to produce an importable asset.

## 1. Approved art direction

- Style: premium stylized 3D, readable and expressive, not photorealistic and not toy-like.
- Creature: agile feathered Velociraptor, athletic digitigrade anatomy, long counterbalancing tail, compact powerful torso, narrow intelligent head, articulated jaw, amber eyes, curved sickle claw on each foot, short feather fans on forearms and tail edge.
- Palette: deep forest-olive dorsal body, muted teal-green shadows, warm pale sand belly, darker moss dorsal stripe, amber eyes, charcoal claws.
- Silhouette: recognizable from gameplay camera distance; head, forearm feathers, raised sickle claws and tail remain readable against foliage.
- Avoid: generic lizard body, oversized crocodile head, human-like hands, stiff straight tail, excessive spikes, plastic gloss, noisy micro-detail.

## 2. Model-generation prompt

Create a complete game-ready stylized feathered Velociraptor, full body, neutral relaxed creature bind pose, facing local -Z, up +Y, origin at ground between the feet. Athletic bipedal dromaeosaur anatomy, long tapered counterbalancing tail, compact muscular torso, flexible S-curve neck, narrow expressive skull, separate lower jaw, amber eyes, visible nostrils, curved enlarged sickle claw on each inner toe, three-toed feet, short feather fans along forearms and tail edge, layered feather breakup on shoulders and hips. Deep forest olive and teal-green upper body, warm sand-colored underside, subtle dark dorsal stripe, dark keratin claws. Premium stylized game-art finish with clean large forms, controlled surface detail, clean topology, no base, no stand, no text, no scenery, no extra limbs, no fused toes. Deliver UV-unwrapped mesh and PBR maps (base color, normal, roughness, ambient occlusion / packed ORM), real-world scale in meters, exportable as GLB.

## 3. Geometry and texture targets

| Tier | Triangle budget | Texture target | Use |
|---|---:|---|---|
| Hero | 35k-60k | 2K PBR | Close camera, showcase / cutscene |
| Gameplay | 12k-25k | 2K PBR | Main PC presentation |
| Mobile | 5k-10k | 1K PBR or optimized atlas | Android gameplay |
| Far LOD | 1.5k-3k | shared 512-1K | Distant companion / crowd |

Use one main material where possible. Avoid excessive separate mesh parts and draw calls. Keep eyes, teeth, claws and jaw separate only where needed for animation.

## 4. Rig specification

A skinned deformation skeleton is required for the final hero model. Named pivot groups alone are not sufficient.

- Root / pelvis: root, hips.
- Spine: 3-4 spine bones and chest.
- Neck / head: 3 neck bones, head, jaw, optional eye aim controls.
- Tail: 8-12 tail bones with smooth taper and secondary follow-through.
- Forelimbs: left / right shoulder, upper arm, forearm, wrist / manus and claw controls.
- Hind limbs: left / right thigh, knee, hock, ankle / foot and toe controls.
- Optional: feather-control bones, eyelids and facial controls.
- Skin weights must be clean around shoulders, hips, knees, hocks, jaw and tail base.

## 5. Required animation clips

1. Idle breathing / alert scan (loop)
2. Walk forward (loop)
3. Trot (loop)
4. Sprint (loop)
5. Start / stop
6. Turn left / right
7. Bite attack
8. Lunge attack
9. Roar / call
10. Hit reaction
11. Stagger / recover
12. Eat / sniff ground
13. Drink
14. Sleep / lie down / get up
15. Death

Animation requirements: consistent root-motion policy, planted feet, no skating, no limb popping, tail and head secondary motion, smooth transitions and a stable rest pose. Clips must be exported in GLB with their skeleton and skin.

## 6. Tool route and hard requirements

### Shape and PBR generation

Tencent Hunyuan3D-2.1 is the preferred high-detail generation route because it generates 3D shape and PBR materials. Official project: https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1 and official Studio: https://3d.hunyuan.tencent.com/ . The official repository reports approximately 10 GB VRAM for shape generation, 21 GB VRAM for texture generation and 29 GB total for shape plus texture generation. The current ChatGPT execution container has no Blender, no Godot binary and no attached GPU inference runtime, so this generation cannot be run inside the current environment.

### Quadruped rigging / animation

Meshy documents automatic rigging for quadrupeds and a walk animation; its published animation library is humanoid-focused, so it does not automatically provide the complete dinosaur clip list above. Commercial-use rights depend on the plan; its free tier is for personal / evaluation use. See https://www.meshy.ai/animation-library .

For the final creature, use quadruped auto-rig as a starting point only. A manual Blender rig pass is still required for tail chain, jaw, sickle claws, foot locking and bespoke attack / idle clips.

## 7. Godot integration gate

- Import the final GLB in Godot 4.7.1.
- Verify skeleton hierarchy, rest pose, skin weights, material maps and animation names.
- Create AnimationTree state machine: Idle, Walk, Trot, Sprint, Turn, Attack, Hit, Roar, Eat, Sleep, Death.
- Use blend spaces for locomotion and one-shot transitions for attacks / reactions.
- Add foot locking / IK where needed, tail secondary motion and head look-at.
- Test the hero tier on PC and gameplay / mobile LOD on Android.
- Capture a real Godot screenshot and a short in-engine animation clip before approving the asset.

## 8. Interim asset versus final gate

The current Polyfork Velociraptor GLB is a lightweight, 3,938-triangle articulated-pivot model. It replaces the primitive placeholder and is suitable for an interim gameplay slice. It does not meet the skinned hero rig, PBR close-up, LOD and authored-animation requirements above. Do not label it the final Velociraptor.
