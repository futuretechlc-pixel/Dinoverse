extends Node3D
## Procedural visual stand-in. Replace with authored rigged dinosaur at the art gate.

var parts: Dictionary = {}
var clock := 0.0
var stride := 0.0
var last_position := Vector3.ZERO
var moving := false
var skin: StandardMaterial3D
var light_skin: StandardMaterial3D
var dark_skin: StandardMaterial3D
var eye_mat: StandardMaterial3D
var claw_mat: StandardMaterial3D

func _ready() -> void:
    skin = mat(Color(0.22, 0.39, 0.27), 0.82)
    light_skin = mat(Color(0.48, 0.56, 0.31), 0.9)
    dark_skin = mat(Color(0.075, 0.15, 0.12), 0.9)
    eye_mat = mat(Color(1.0, 0.56, 0.12), 0.24)
    eye_mat.emission_enabled = true
    eye_mat.emission = Color(0.55, 0.16, 0.015)
    claw_mat = mat(Color(0.10, 0.095, 0.075), 0.36)
    build_body()
    last_position = global_position

func mat(color: Color, rough: float) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = rough
    return m

func sphere(parent: Node3D, label: String, pos: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
    var mesh := SphereMesh.new()
    mesh.radius = 0.5
    mesh.height = 1.0
    mesh.radial_segments = 24
    mesh.rings = 16
    var node := MeshInstance3D.new()
    node.name = label
    node.mesh = mesh
    node.position = pos
    node.scale = size
    node.material_override = material
    parent.add_child(node)
    return node

func capsule(parent: Node3D, label: String, pos: Vector3, radius: float, height: float, material: Material) -> MeshInstance3D:
    var mesh := CapsuleMesh.new()
    mesh.radius = radius
    mesh.height = height
    mesh.radial_segments = 16
    mesh.rings = 8
    var node := MeshInstance3D.new()
    node.name = label
    node.mesh = mesh
    node.position = pos
    node.material_override = material
    parent.add_child(node)
    return node

func build_body() -> void:
    sphere(self, "Powerful_Hips", Vector3(0, 1.12, 0.42), Vector3(0.88, 0.88, 1.08), skin)
    sphere(self, "Ribcage", Vector3(0, 1.48, -0.22), Vector3(0.74, 0.78, 1.42), skin)
    sphere(self, "Belly", Vector3(0, 1.18, -0.18), Vector3(0.62, 0.36, 1.05), light_skin)
    parts.neck = capsule(self, "S_Curved_Neck", Vector3(0, 1.92, -0.88), 0.27, 1.2, skin)
    parts.neck.rotation.x = deg_to_rad(-28)
    parts.head = sphere(self, "Cranium", Vector3(0, 2.26, -1.36), Vector3(0.48, 0.42, 0.68), skin)
    sphere(self, "Upper_Snout", Vector3(0, 2.12, -1.77), Vector3(0.31, 0.22, 0.64), light_skin)
    sphere(self, "Lower_Jaw", Vector3(0, 1.98, -1.68), Vector3(0.27, 0.105, 0.54), dark_skin)
    for side in [-1.0, 1.0]:
        sphere(self, "Amber_Eye", Vector3(side * 0.235, 2.31, -1.55), Vector3(0.105, 0.11, 0.09), eye_mat)
        sphere(self, "Pupil", Vector3(side * 0.25, 2.31, -1.615), Vector3(0.035, 0.07, 0.025), dark_skin)
        sphere(self, "Nostril", Vector3(side * 0.16, 2.17, -2.03), Vector3(0.035, 0.026, 0.025), dark_skin)
        sphere(self, "Shoulder", Vector3(side * 0.39, 1.78, -0.72), Vector3(0.23, 0.25, 0.30), skin)
        var arm := capsule(self, "Forearm", Vector3(side * 0.49, 1.58, -0.92), 0.095, 0.48, light_skin)
        arm.rotation.z = side * deg_to_rad(-32)
        for finger in range(2):
            sphere(self, "Hand_Claw", Vector3(side * (0.55 + finger * 0.055), 1.39, -1.06), Vector3(0.035, 0.045, 0.14), claw_mat)
        var thigh := capsule(self, "Thigh", Vector3(side * 0.34, 0.91, 0.48), 0.22, 0.78, skin)
        thigh.rotation.x = deg_to_rad(-18)
        var shin := capsule(self, "Shin", Vector3(side * 0.34, 0.47, 0.22), 0.115, 0.66, light_skin)
        shin.rotation.x = deg_to_rad(20)
        var foot := sphere(self, "Three_Toed_Foot", Vector3(side * 0.34, 0.15, -0.02), Vector3(0.22, 0.12, 0.38), skin)
        for toe in range(3):
            sphere(self, "Toe_Claw", Vector3(side * 0.34 + (toe - 1) * 0.12, 0.12, -0.24), Vector3(0.055, 0.055, 0.19), claw_mat)
        parts["leg_%s" % side] = {"thigh": thigh, "shin": shin, "foot": foot}
    var tail := Node3D.new()
    tail.name = "Tail_Root_Pivot"
    tail.position = Vector3(0, 1.35, 0.94)
    add_child(tail)
    parts.tail = tail
    for i in range(6):
        var p := float(i)
        var segment := sphere(tail, "Tail_Segment_%d" % i, Vector3(0, -p * 0.035, 0.25 + p * 0.31), Vector3(0.48 - p * 0.052, 0.42 - p * 0.045, 0.66), skin if i < 3 else light_skin)
        segment.rotation.x = deg_to_rad(-8)
    for i in range(7):
        var z := -0.82 + i * 0.27
        var ridge := sphere(self, "Dorsal_Scute", Vector3(0, 1.92 - i * 0.045, z), Vector3(0.12, 0.18, 0.13), light_skin)
        ridge.rotation.x = deg_to_rad(25)

func _process(delta: float) -> void:
    clock += delta
    stride += delta * 5.2
    moving = global_position.distance_to(last_position) > 0.002
    last_position = global_position
    var gait := sin(stride) if moving else 0.0
    parts.tail.rotation.y = sin(clock * 1.45) * 0.12 + gait * 0.035
    parts.tail.rotation.x = sin(clock * 1.1) * 0.035
    for side in [-1.0, 1.0]:
        leg: Dictionary = parts["leg_%s" % side]
        leg.thigh.rotation.x = deg_to_rad(-18) + gait * side * 0.34
        leg.shin.rotation.x = deg_to_rad(20) + maxf(0.0, -gait * side) * 0.55
        leg.foot.rotation.x = -maxf(0.0, gait * side) * 0.22
    parts.head.rotation.x = sin(clock * 1.8) * 0.025
    parts.neck.rotation.z = sin(clock * 1.2) * 0.025
