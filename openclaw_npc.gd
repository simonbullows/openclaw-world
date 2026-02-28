extends CharacterBody3D

var speed = 2.0
var direction = Vector3.FORWARD
var change_direction_timer = 0.0
var name_tag = "OpenClaw"

func _ready():
	# Random starting direction
	direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	
	# Random color for this OpenClaw
	var mesh = $MeshInstance3D
	if mesh:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(randf(), randf(), randf())
		mesh.material_override = mat
	
	# Random name
	var names = ["Jeeves", "Pepper", "Researcher", "Writer", "Coder", "Sales"]
	name_tag = names[randi() % names.size()]

func _physics_process(delta):
	# Change direction randomly
	change_direction_timer -= delta
	if change_direction_timer <= 0:
		change_direction_timer = randf_range(2, 5)
		direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
		
		# Face direction
		if direction.x > 0:
			rotation_degrees.y = -90
		elif direction.x < 0:
			rotation_degrees.y = 90
		elif direction.z > 0:
			rotation_degrees.y = 180
		else:
			rotation_degrees.y = 0
	
	# Move
	velocity = direction * speed
	move_and_slide()
	
	# Keep on ground
	position.y = max(position.y, 1)

func _on_body_entered(body):
	# Bounce off obstacles
	direction = -direction
