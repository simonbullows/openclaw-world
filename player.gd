extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 5.0
const GRAVITY = 15.0
const MOUSE_SENSITIVITY = 0.003

@onready var camera = $Camera3D

var world_seed = 12345
var selected_block = 1

# No clip collision shape for first person
func _ready():
	world_seed = randi()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Block interaction (left click)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		break_block()
	
	# Block interaction (right click)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		place_block()

	move_and_slide()

func break_block():
	# Cast ray from camera
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z) * 10
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var pos = result.position
		var block_pos = Vector3(round(pos.x), round(pos.y), round(pos.z))
		
		# Determine which block to break (neighbor of hit)
		var hit_normal = result.position - result.collider.global_position
		var break_pos = block_pos - hit_normal.snapped(Vector3.ONE)
		
		var terrain = get_node("/root/Main/Terrain")
		if terrain:
			terrain.set_block(int(break_pos.x), int(break_pos.y), int(break_pos.z), 0)

func place_block():
	# Cast ray from camera
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z) * 10
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var pos = result.position
		var hit_normal = result.position - result.collider.global_position
		
		# Place block adjacent to hit
		var place_pos = Vector3(round(pos.x), round(pos.y), round(pos.z))
		place_pos += hit_normal.snapped(Vector3.ONE)
		
		var terrain = get_node("/root/Main/Terrain")
		if terrain:
			terrain.set_block(int(place_pos.x), int(place_pos.y), int(place_pos.z), selected_block)
