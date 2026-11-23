extends Node3D

const RAPTOR_SCRIPT = preload("res://scripts/raptor.gd")
const WATER_SHADER = preload("res://shaders/water.gdshader")

var rng := RandomNumberGenerator.new()
var player: CharacterBody3D
var camera: Camera3D
var raptor: Node3D
var yaw := 0.0
var pitch := -0.18
var mouse_look := false
var camera_offset := Vector3(0, 5.2, 9.5)

func _ready() -> void:
    rng.seed = 7412026
    build_environment()
    build_ground()
    build_water()
    build_ruins()
    build_forest()
    build_player()
    build_raptor()
    build_camera()
    build_hud()

func material(color: Color, rough := 0.8, metal := 0.0) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = rough
    m.metallic = metal
    return m

func add_mesh(parent: Node3D, mesh: Mesh, pos: Vector3, mat: Material, label := "Mesh") -> MeshInstance3D:
    var n := MeshInstance3D.new()
    n.name = label
    n.mesh = mesh
    n.position = pos
    n.material_override = mat
    parent.add_child(n)
    return n

func build_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color = Color(0.055, 0.17, 0.18)
    sky_mat.sky_horizon_color = Color(0.48, 0.58, 0.43)
    sky_mat.ground_bottom_color = Color(0.035, 0.075, 0.055)
    sky_mat.ground_horizon_color = Color(0.20, 0.29, 0.20)
    sky.sky_material = sky_mat
    env.sky = sky
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.47, 0.60, 0.49)
    env.ambient_light_energy = 0.62
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    env.tonemap_exposure = 1.08
    env.glow_enabled = true
    env.glow_intensity = 0.42
    env.glow_strength = 0.72
    env.fog_enabled = true
    env.fog_light_color = Color(0.39, 0.52, 0.40)
    env.fog_depth_begin = 12.0
    env.fog_depth_end = 68.0
    env.fog_depth_curve = 1.35
    env.fog_sky_affect = 0.6
    world.environment = env
    add_child(world)
    var sun := DirectionalLight3D.new()
    sun.name = "Canopy_Sun"
    sun.rotation_degrees = Vector3(-48, -32, 0)
    sun.light_color = Color(1.0, 0.83, 0.61)
    sun.light_energy = 1.55
    sun.shadow_enabled = true
    sun.directional_shadow_max_distance = 75.0
    sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
    add_child(sun)
    var fill := OmniLight3D.new()
    fill.position = Vector3(-2, 3.4, -2)
    fill.light_color = Color(0.20, 0.68, 0.48)
    fill.light_energy = 0.8
    fill.omni_range = 12.0
    add_child(fill)

func build_ground() -> void:
    var ground := PlaneMesh.new()
    ground.size = Vector2(100, 100)
    add_mesh(self, ground, Vector3(0, -0.18, 0), material(Color(0.12, 0.20, 0.105), 1.0), "Jungle_Floor")
    var floor_body := StaticBody3D.new()
    floor_body.name = "Ground_Collision"
    var floor_shape := CollisionShape3D.new()
    var floor_box := BoxShape3D.new()
    floor_box.size = Vector3(100, 0.35, 100)
    floor_shape.shape = floor_box
    floor_shape.position.y = -0.18
    floor_body.add_child(floor_shape)
    add_child(floor_body)
    for i in range(24):
        var rock := SphereMesh.new()
        rock.radius = rng.randf_range(0.45, 1.6)
        rock.height = rock.radius * 0.62
        var p := Vector3(rng.randf_range(-25, 25), -0.08, rng.randf_range(-24, 24))
        if Vector2(p.x, p.z).length() > 7.0:
            var mound := add_mesh(self, rock, p, material(Color(0.19, 0.16, 0.105), 1.0), "Mossy_Earth_Mound")
            mound.scale = Vector3(rng.randf_range(0.8, 1.5), 0.45, rng.randf_range(0.8, 1.5))

func build_water() -> void:
    var water := PlaneMesh.new()
    water.size = Vector2(38, 8)
    water.subdivide_width = 48
    water.subdivide_depth = 12
    var shader_mat := ShaderMaterial.new()
    shader_mat.shader = WATER_SHADER
    add_mesh(self, water, Vector3(2, 0.035, -12), shader_mat, "Emerald_Stream")
    var stone_mat := material(Color(0.24, 0.30, 0.22), 0.96)
    for side in [-1.0, 1.0]:
        for i in range(22):
            var stone_mesh := SphereMesh.new()
            stone_mesh.radius = rng.randf_range(0.18, 0.55)
            stone_mesh.height = stone_mesh.radius * 0.75
            var stone := add_mesh(self, stone_mesh, Vector3(rng.randf_range(-17, 20), 0.02, -12 + side * rng.randf_range(4.2, 5.0)), stone_mat, "Stream_Stone")
            stone.rotation.y = rng.randf_range(0, TAU)
            stone.scale = Vector3(1.4, 0.8, 1.0)

func build_ruins() -> void:
    var stone_mat := material(Color(0.38, 0.43, 0.32), 0.92)
    var dark_mat := material(Color(0.16, 0.23, 0.18), 0.98)
    for i in range(5):
        var x := -7.0 + i * 3.5
        var pillar := CylinderMesh.new()
        pillar.top_radius = 0.38
        pillar.bottom_radius = 0.52
        pillar.height = rng.randf_range(2.2, 3.4)
        pillar.radial_segments = 12
        add_mesh(self, pillar, Vector3(x, pillar.height * 0.5 - 0.08, -5.5), stone_mat, "Ancient_Ruin_Pillar")
        var cap := BoxMesh.new()
        cap.size = Vector3(1.25, 0.25, 1.15)
        add_mesh(self, cap, Vector3(x, pillar.height + 0.08, -5.5), dark_mat, "Weathered_Capital")
    var ring := TorusMesh.new()
    ring.inner_radius = 1.35
    ring.outer_radius = 1.62
    ring.rings = 24
    ring.ring_segments = 12
    var altar := add_mesh(self, ring, Vector3(0, 0.26, -4.0), material(Color(0.38, 0.56, 0.35), 0.52, 0.15), "Ancient_Signal_Ring")
    altar.rotation.x = deg_to_rad(90)
    var glow := OmniLight3D.new()
    glow.position = Vector3(0, 1.1, -4)
    glow.light_color = Color(0.22, 0.95, 0.58)
    glow.light_energy = 1.4
    glow.omni_range = 5.5
    add_child(glow)

func build_forest() -> void:
    if ResourceLoader.exists("res://assets/environment/palm_tree.glb") and ResourceLoader.exists("res://assets/environment/broad_canopy_tree.glb"):
        build_glb_forest()
        return
    var bark := material(Color(0.18, 0.105, 0.065), 0.96)
    var leaf_mats := [
        material(Color(0.075, 0.23, 0.105), 0.88),
        material(Color(0.11, 0.32, 0.13), 0.86),
        material(Color(0.20, 0.39, 0.17), 0.9),
        material(Color(0.045, 0.17, 0.12), 0.92)
    ]
    for i in range(36):
        var angle := rng.randf_range(0.0, TAU)
        var radius := rng.randf_range(11.0, 38.0)
        var x := cos(angle) * radius
        var z := sin(angle) * radius
        if absf(z + 12.0) < 6.0 and absf(x) < 20.0:
            continue
        make_tree(Vector3(x, 0, z), rng.randf_range(0.78, 1.55), bark, leaf_mats)
    for i in range(34):
        var x := rng.randf_range(-23, 23)
        var z := rng.randf_range(-24, 22)
        if Vector2(x, z).length() < 4.5 or (absf(z + 12.0) < 4.7 and absf(x) < 19.0):
            continue
        make_fern(Vector3(x, 0, z), rng.randf_range(0.65, 1.35), leaf_mats[rng.randi_range(0, 3)])

func build_glb_forest() -> void:
    var palm_scene := load("res://assets/environment/palm_tree.glb") as PackedScene
    var canopy_scene := load("res://assets/environment/broad_canopy_tree.glb") as PackedScene
    var sapling_scene := load("res://assets/environment/palm_sapling.glb") as PackedScene
    var tree_scenes: Array[PackedScene] = [palm_scene, canopy_scene]
    for i in range(42):
        var angle := rng.randf_range(0.0, TAU)
        var radius := rng.randf_range(12.0, 39.0)
        var x := cos(angle) * radius
        var z := sin(angle) * radius
        if absf(z + 12.0) < 6.2 and absf(x) < 20.0:
            continue
        var source: PackedScene = tree_scenes[rng.randi_range(0, tree_scenes.size() - 1)]
        var tree := source.instantiate() as Node3D
        if tree == null:
            continue
        tree.name = "EmeraldJungle_ProductionTree_%02d" % i
        tree.position = Vector3(x, 0.0, z)
        tree.scale = Vector3.ONE * rng.randf_range(0.78, 1.22)
        tree.rotation.y = rng.randf_range(0.0, TAU)
        add_child(tree)
    if sapling_scene != null:
        for i in range(26):
            var x := rng.randf_range(-25.0, 25.0)
            var z := rng.randf_range(-24.0, 22.0)
            if Vector2(x, z).length() < 5.0 or (absf(z + 12.0) < 5.0 and absf(x) < 18.0):
                continue
            var sapling := sapling_scene.instantiate() as Node3D
            if sapling == null:
                continue
            sapling.name = "EmeraldJungle_Understory_%02d" % i
            sapling.position = Vector3(x, 0.0, z)
            sapling.scale = Vector3.ONE * rng.randf_range(0.75, 1.35)
            sapling.rotation.y = rng.randf_range(0.0, TAU)
            add_child(sapling)
    var fern_scene := load("res://assets/environment/fern.glb") as PackedScene
    var bush_scene := load("res://assets/environment/round_bush.glb") as PackedScene
    var small_rock_scene := load("res://assets/environment/small_rock.glb") as PackedScene
    var medium_rock_scene := load("res://assets/environment/medium_rock.glb") as PackedScene
    var grass_scene := load("res://assets/environment/grass_tuft.glb") as PackedScene
    var understory_scenes: Array[PackedScene] = [fern_scene, bush_scene]
    for i in range(54):
        var x := rng.randf_range(-26.0, 26.0)
        var z := rng.randf_range(-25.0, 24.0)
        if Vector2(x, z).length() < 5.5 or (absf(z + 12.0) < 4.8 and absf(x) < 19.0):
            continue
        var source: PackedScene = understory_scenes[rng.randi_range(0, understory_scenes.size() - 1)]
        var plant := source.instantiate() as Node3D
        if plant == null:
            continue
        plant.position = Vector3(x, 0.0, z)
        plant.scale = Vector3.ONE * rng.randf_range(0.72, 1.35)
        plant.rotation.y = rng.randf_range(0.0, TAU)
        add_child(plant)
    var rock_scenes: Array[PackedScene] = [small_rock_scene, medium_rock_scene]
    for i in range(38):
        var x := rng.randf_range(-27.0, 27.0)
        var z := rng.randf_range(-26.0, 24.0)
        if Vector2(x, z).length() < 4.5 or (absf(z + 12.0) < 4.5 and absf(x) < 20.0):
            continue
        var rock := rock_scenes[rng.randi_range(0, rock_scenes.size() - 1)].instantiate() as Node3D
        if rock == null:
            continue
        rock.position = Vector3(x, -0.02, z)
        rock.scale = Vector3.ONE * rng.randf_range(0.8, 1.5)
        rock.rotation.y = rng.randf_range(0.0, TAU)
        add_child(rock)
    if grass_scene != null:
        for i in range(70):
            var x := rng.randf_range(-25.0, 25.0)
            var z := rng.randf_range(-24.0, 22.0)
            if Vector2(x, z).length() < 4.5 or (absf(z + 12.0) < 4.3 and absf(x) < 18.0):
                continue
            var grass := grass_scene.instantiate() as Node3D
            if grass == null:
                continue
            grass.position = Vector3(x, 0.0, z)
            grass.scale = Vector3.ONE * rng.randf_range(0.7, 1.25)
            grass.rotation.y = rng.randf_range(0.0, TAU)
            add_child(grass)

func make_tree(pos: Vector3, factor: float, bark: Material, leaf_mats: Array) -> void:
    var root := Node3D.new()
    root.position = pos
    add_child(root)
    var trunk := CylinderMesh.new()
    trunk.top_radius = 0.28 * factor
    trunk.bottom_radius = 0.58 * factor
    trunk.height = 5.2 * factor
    trunk.radial_segments = 10
    add_mesh(root, trunk, Vector3(0, trunk.height * 0.5, 0), bark, "Old_Tree_Trunk")
    for b in range(3):
        var branch := CylinderMesh.new()
        branch.top_radius = 0.08 * factor
        branch.bottom_radius = 0.17 * factor
        branch.height = 2.2 * factor
        var branch_node := add_mesh(root, branch, Vector3(0, 3.0 * factor, 0), bark, "Branch")
        branch_node.rotation_degrees = Vector3(rng.randf_range(-28, 28), b * 120, rng.randf_range(-42, 42))
        branch_node.position += Vector3(cos(b * TAU / 3.0) * factor, 0.6 * factor, sin(b * TAU / 3.0) * factor)
    for c in range(6):
        var crown := SphereMesh.new()
        crown.radius = rng.randf_range(1.25, 2.05) * factor
        crown.height = crown.radius * 1.15
        crown.radial_segments = 12
        crown.rings = 8
        var node := add_mesh(root, crown, Vector3(rng.randf_range(-1.4, 1.4), rng.randf_range(4.5, 6.3) * factor, rng.randf_range(-1.4, 1.4)), leaf_mats[rng.randi_range(0, leaf_mats.size() - 1)], "Layered_Canopy")
        node.scale = Vector3(1.25, 0.72, 1.1)

func make_fern(pos: Vector3, factor: float, leaf_material: Material) -> void:
    var root := Node3D.new()
    root.position = pos
    root.scale = Vector3.ONE * factor
    add_child(root)
    var stem_mat := material(Color(0.19, 0.31, 0.10), 0.9)
    for frond in range(6):
        var angle := TAU * float(frond) / 6.0
        var direction := Vector3(cos(angle), 0.0, sin(angle))
        var stem := CylinderMesh.new()
        stem.top_radius = 0.012
        stem.bottom_radius = 0.035
        stem.height = 1.25
        var stem_node := add_mesh(root, stem, direction * 0.34 + Vector3(0, 0.53, 0), stem_mat, "Fern_Rachis")
        stem_node.rotation = Vector3(deg_to_rad(-48), -angle, deg_to_rad(12))
        for leaf in range(3):
            var t := float(leaf) / 3.0
            var leaf_mesh := SphereMesh.new()
            leaf_mesh.radius = 0.20 * (1.0 - t * 0.45)
            leaf_mesh.height = leaf_mesh.radius * 0.36
            var leaf_node := add_mesh(root, leaf_mesh, direction * (0.35 + t * 0.76) + Vector3(0, 0.78 - t * 0.55, 0), leaf_material, "Fern_Leaflet")
            leaf_node.rotation.y = angle + (1.0 if leaf % 2 == 0 else -1.0) * 0.62
            leaf_node.scale = Vector3(1.8, 0.7, 0.8)

func build_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Explorer"
    player.position = Vector3(0, 0.15, 3.0)
    add_child(player)
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.34
    shape.height = 1.75
    collision.shape = shape
    collision.position.y = 0.88
    player.add_child(collision)
    var suit := material(Color(0.16, 0.25, 0.23), 0.72)
    var leather := material(Color(0.32, 0.18, 0.09), 0.9)
    var skin := material(Color(0.66, 0.43, 0.28), 0.85)
    var body := CapsuleMesh.new()
    body.radius = 0.34
    body.height = 1.05
    add_mesh(player, body, Vector3(0, 1.02, 0), suit, "Explorer_Body")
    var head := SphereMesh.new()
    head.radius = 0.22
    head.height = 0.44
    add_mesh(player, head, Vector3(0, 1.72, -0.02), skin, "Explorer_Head")
    var pack := BoxMesh.new()
    pack.size = Vector3(0.48, 0.55, 0.22)
    add_mesh(player, pack, Vector3(0, 1.08, 0.31), leather, "Field_Pack")
    var shoulder := SphereMesh.new()
    shoulder.radius = 0.17
    shoulder.height = 0.32
    for side in [-1.0, 1.0]:
        add_mesh(player, shoulder, Vector3(side * 0.34, 1.35, 0), suit, "Shoulder_Guard")

func build_raptor() -> void:
    raptor = Node3D.new()
    raptor.name = "Velociraptor_Companion"
    raptor.set_script(RAPTOR_SCRIPT)
    raptor.position = Vector3(1.8, 0, 4.2)
    add_child(raptor)

func build_camera() -> void:
    camera = Camera3D.new()
    camera.name = "Follow_Camera"
    camera.current = true
    camera.fov = 66.0
    camera.near = 0.08
    camera.far = 160.0
    add_child(camera)
    update_camera(1.0)

func build_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var panel := PanelContainer.new()
    panel.position = Vector2(28, 24)
    panel.custom_minimum_size = Vector2(380, 98)
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.025, 0.075, 0.06, 0.78)
    style.border_color = Color(0.42, 0.72, 0.43, 0.7)
    style.set_border_width_all(1)
    style.set_corner_radius_all(10)
    style.content_margin_left = 16
    style.content_margin_top = 12
    style.content_margin_right = 16
    style.content_margin_bottom = 12
    panel.add_theme_stylebox_override("panel", style)
    layer.add_child(panel)
    var label := Label.new()
    label.text = "D I N O V E R S E   /   EMERALD JUNGLE\nWASD move   •   Shift sprint   •   Mouse drag orbit\nVisual target: premium stylized 3D environment"
    label.add_theme_color_override("font_color", Color(0.86, 0.94, 0.78))
    label.add_theme_font_size_override("font_size", 15)
    panel.add_child(label)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
        mouse_look = event.pressed
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_look else Input.MOUSE_MODE_VISIBLE
    elif event is InputEventMouseMotion and mouse_look:
        yaw -= event.relative.x * 0.003
        pitch = clampf(pitch - event.relative.y * 0.002, -0.55, 0.12)
    elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        mouse_look = false
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
    var input_vector := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
    )
    var basis := Basis(Vector3.UP, yaw)
    var direction := (basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
    var speed := 7.0 if Input.is_action_pressed("sprint") else 4.3
    player.velocity.x = direction.x * speed
    player.velocity.z = direction.z * speed
    if not player.is_on_floor():
        player.velocity.y -= 9.8 * delta
    else:
        player.velocity.y = -0.1
    player.move_and_slide()
    if direction.length() > 0.08:
        player.rotation.y = lerp_angle(player.rotation.y, atan2(-direction.x, -direction.z), delta * 9.0)
    var follow_target := player.global_position + Vector3(1.6, 0, 1.0)
    var follow_direction := follow_target - raptor.global_position
    raptor.global_position = raptor.global_position.lerp(follow_target, clampf(delta * 4.0, 0.0, 1.0))
    if follow_direction.length() > 0.12:
        raptor.look_at(raptor.global_position + Vector3(follow_direction.x, 0.0, follow_direction.z), Vector3.UP)
    else:
        raptor.look_at(Vector3(player.global_position.x, raptor.global_position.y + 0.7, player.global_position.z), Vector3.UP)
    update_camera(delta)

func update_camera(delta: float) -> void:
    if not is_instance_valid(player):
        return
    var target := player.global_position + Vector3(0, 1.35, 0)
    var rotation_basis := Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, pitch)
    var desired := target + rotation_basis * camera_offset
    camera.global_position = camera.global_position.lerp(desired, clampf(delta * 7.0, 0.0, 1.0))
    camera.look_at(target, Vector3.UP)
