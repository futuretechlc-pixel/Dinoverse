extends Node3D
## Runtime controller for the production Velociraptor GLB.
## Drives the model's named articulated pivots with blended procedural locomotion.

const MODEL_PATH := "res://assets/characters/velociraptor_base.glb"
const MODEL_SCALE := 1.48

var model: Node3D
var rig: Dictionary = {}
var rest_rotations: Dictionary = {}
var clock := 0.0
var stride := 0.0
var last_position := Vector3.ZERO
var smoothed_speed := 0.0
var action_name := ""
var action_time := 0.0
var action_duration := 0.0

func _ready() -> void:
    if not ResourceLoader.exists(MODEL_PATH):
        push_error("Dinoverse: missing Velociraptor asset. Run: python tools/fetch_visual_assets.py")
        return
    var packed := load(MODEL_PATH) as PackedScene
    if packed == null:
        push_error("Dinoverse: Velociraptor GLB could not be imported as a PackedScene.")
        return
    model = packed.instantiate() as Node3D
    if model == null:
        push_error("Dinoverse: imported Velociraptor root is not Node3D.")
        return
    model.name = "Velociraptor_Production_Model"
    model.scale = Vector3.ONE * MODEL_SCALE
    add_child(model)
    cache_rig()
    last_position = global_position

func cache_rig() -> void:
    var names := [
        "Neck", "Head", "Jaw", "Tail", "TailMid", "TailTip",
        "LeftUpperArm", "LeftLowerArm", "LeftManus",
        "LeftHindUpLeg", "LeftHindLeg", "LeftHindHock", "LeftHindFoot",
        "RightUpperArm", "RightLowerArm", "RightManus",
        "RightHindUpLeg", "RightHindLeg", "RightHindHock", "RightHindFoot"
    ]
    for part_name in names:
        var node := model.find_child(part_name, true, false) as Node3D
        if node != null:
            rig[part_name] = node
            rest_rotations[part_name] = node.rotation
    for required_name in ["Head", "Jaw", "Tail", "LeftHindUpLeg", "RightHindUpLeg"]:
        if not rig.has(required_name):
            push_warning("Dinoverse: expected rig pivot not found: %s" % required_name)

func _process(delta: float) -> void:
    if model == null:
        return
    clock += delta
    var measured_speed := global_position.distance_to(last_position) / maxf(delta, 0.0001)
    last_position = global_position
    smoothed_speed = lerpf(smoothed_speed, measured_speed, clampf(delta * 5.0, 0.0, 1.0))
    var move_amount := clampf(smoothed_speed / 4.8, 0.0, 1.0)
    var running := smoothed_speed > 5.3
    stride += delta * lerpf(0.0, 7.2 if running else 4.7, move_amount)
    var gait := sin(stride)
    var stride_amount := lerpf(0.0, 0.48 if running else 0.30, move_amount)
    var knee_amount := lerpf(0.0, 0.56 if running else 0.34, move_amount)

    set_rotation_offset("Neck", Vector3(-0.025 + absf(gait) * 0.035, sin(clock * 0.72) * 0.035, 0.0))
    set_rotation_offset("Head", Vector3(sin(clock * 1.35) * 0.025, sin(clock * 0.85) * 0.055, 0.0))
    set_rotation_offset("Tail", Vector3(0.015 + gait * move_amount * 0.025, sin(clock * 1.1) * 0.105 - gait * move_amount * 0.10, 0.0))
    set_rotation_offset("TailMid", Vector3(0.0, sin(clock * 1.1 - 0.35) * 0.075 - gait * move_amount * 0.065, 0.0))
    set_rotation_offset("TailTip", Vector3(0.0, sin(clock * 1.1 - 0.7) * 0.09 - gait * move_amount * 0.04, 0.0))
    set_rotation_offset("Jaw", Vector3.ZERO)

    animate_leg("Left", gait, stride_amount, knee_amount)
    animate_leg("Right", -gait, stride_amount, knee_amount)
    set_rotation_offset("LeftUpperArm", Vector3(-0.08 - gait * move_amount * 0.12, 0.0, 0.035))
    set_rotation_offset("RightUpperArm", Vector3(-0.08 + gait * move_amount * 0.12, 0.0, -0.035))
    set_rotation_offset("LeftLowerArm", Vector3(0.10 + move_amount * 0.08, 0.0, 0.0))
    set_rotation_offset("RightLowerArm", Vector3(0.10 + move_amount * 0.08, 0.0, 0.0))
    set_rotation_offset("LeftManus", Vector3(0.0, 0.0, 0.08))
    set_rotation_offset("RightManus", Vector3(0.0, 0.0, -0.08))

    if action_name != "":
        action_time += delta
        apply_action()
        if action_time >= action_duration:
            action_name = ""
            action_time = 0.0
            action_duration = 0.0

func animate_leg(side: String, phase: float, stride_amount: float, knee_amount: float) -> void:
    set_rotation_offset(side + "HindUpLeg", Vector3(-phase * stride_amount, 0.0, 0.0))
    set_rotation_offset(side + "HindLeg", Vector3(maxf(0.0, phase) * knee_amount - 0.08, 0.0, 0.0))
    set_rotation_offset(side + "HindHock", Vector3(-maxf(0.0, -phase) * knee_amount * 0.42, 0.0, 0.0))
    set_rotation_offset(side + "HindFoot", Vector3(-maxf(0.0, phase) * 0.16, 0.0, 0.0))

func set_rotation_offset(part_name: String, offset: Vector3) -> void:
    if not rig.has(part_name):
        return
    var node := rig[part_name] as Node3D
    var base: Vector3 = rest_rotations[part_name]
    node.rotation = base + offset

func play_action(requested_action: String) -> void:
    var durations := {"bite": 0.72, "roar": 1.65, "hit": 0.48}
    if model == null or not durations.has(requested_action):
        return
    action_name = requested_action
    action_time = 0.0
    action_duration = durations[requested_action]

func apply_action() -> void:
    var t := clampf(action_time / maxf(action_duration, 0.001), 0.0, 1.0)
    var envelope := sin(t * PI)
    if action_name == "bite":
        set_rotation_offset("Jaw", Vector3(envelope * 0.72, 0.0, 0.0))
        set_rotation_offset("Head", Vector3(-envelope * 0.12, 0.0, 0.0))
    elif action_name == "roar":
        set_rotation_offset("Jaw", Vector3(envelope * 0.9, 0.0, 0.0))
        set_rotation_offset("Neck", Vector3(-0.20 * envelope, 0.0, 0.0))
        set_rotation_offset("Head", Vector3(-0.10 * envelope, 0.0, 0.0))
    elif action_name == "hit":
        set_rotation_offset("Neck", Vector3(0.16 * envelope, 0.0, 0.0))
        set_rotation_offset("Head", Vector3(0.22 * envelope, 0.0, 0.0))
