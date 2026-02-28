extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

@onready var camera = $Camera3D

var world_seed = 12345
var selected_block = 1  # 1=grass, 2=stone, 3=wood

func _ready():
	# Random world seed
	world_seed = randi()
	generate_terrain()

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

	# Block interaction
	if Input.is_action_just_pressed("place_block"):
		place_block()
	if Input.is_action_just_pressed("break_block"):
		break_block()

	move_and_slide()

func generate_terrain():
	# Simple voxel terrain - flat with some variation
	var terrain = get_node("/root/Main/Terrain")
	if not terrain:
		return
	
	# Create ground
	for x in range(-10, 10):
		for z in range(-10, 10):
			var height = 0
			# Add some noise-like variation
			var noise = (sin(x * 0.5 + world_seed) + cos(z * 0.5 + world_seed)) * 0.5
			if noise > 0.3:
				height = 1
			if noise > 0.6:
				height = 2
			
			for y in range(-1, height + 1):
				var block_type = 1 if y == height else 2
				terrain.set_block(x, y, z, block_type)

func place_block():
	# Place block in front of player
	var forward = -global_transform.basis.z
	var target_pos = global_position + forward * 2
	target_pos = target_pos.snapped(Vector3(1, 1, 1))
	
	var terrain = get_node("/root/Main/Terrain")
	if terrain:
		terrain.set_block(int(target_pos.x), int(target_pos.y), int(target_pos.z), selected_block)

func break_block():
	# Break block in front of player
	var forward = -global_transform.basis.z
	var target_pos = global_position + forward * 2
	target_pos = target_pos.snapped(Vector3(1, 1, 1))
	
	var terrain = get_node("/root/Main/Terrain")
	if terrain:
		terrain.set_block(int(target_pos.x), int(target_pos.y), int(target_pos.z), 0)
