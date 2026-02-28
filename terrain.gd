extends Node3D

const CHUNK_SIZE = 16
var blocks = {}

# Beautiful block materials with PBR
var materials = {}

func _ready():
	# Create beautiful materials
	_create_materials()
	# Generate the world
	_generate_world()

func _create_materials():
	var mat_grass = StandardMaterial3D.new()
	mat_grass.albedo_color = Color(0.28, 0.58, 0.25)
	mat_grass.metallic = 0.0
	mat_grass.roughness = 0.85
	materials[1] = mat_grass
	
	var mat_dirt = StandardMaterial3D.new()
	mat_dirt.albedo_color = Color(0.35, 0.22, 0.12)
	mat_dirt.metallic = 0.0
	mat_dirt.roughness = 0.9
	materials[2] = mat_dirt
	
	var mat_stone = StandardMaterial3D.new()
	mat_stone.albedo_color = Color(0.45, 0.42, 0.38)
	mat_stone.metallic = 0.1
	mat_stone.roughness = 0.75
	materials[3] = mat_stone
	
	var mat_wood = StandardMaterial3D.new()
	mat_wood.albedo_color = Color(0.45, 0.28, 0.15)
	mat_wood.metallic = 0.0
	mat_wood.roughness = 0.8
	materials[4] = mat_wood
	
	var mat_leaves = StandardMaterial3D.new()
	mat_leaves.albedo_color = Color(0.2, 0.45, 0.18)
	mat_leaves.metallic = 0.0
	mat_leaves.roughness = 0.9
	materials[5] = mat_leaves
	
	var mat_water = StandardMaterial3D.new()
	mat_water.albedo_color = Color(0.15, 0.45, 0.7, 0.75)
	mat_water.metallic = 0.2
	mat_water.roughness = 0.1
	mat_water.transparency = 1
	materials[6] = mat_water

func _generate_world():
	var seed_val = randi()
	
	# Generate terrain with simplex-like noise
	for x in range(-15, 15):
		for z in range(-15, 15):
			# Create terrain height variation
			var height = _get_height(x, z, seed_val)
			
			# Generate column
			for y in range(-2, int(height) + 1):
				var block_type = _get_block_type(x, y, int(height))
				_set_block(x, y, z, block_type)
			
			# Add trees randomly
			if randf() < 0.08 and height > 0 and height < 3:
				_create_tree(x, int(height) + 1, z)
			
			# Add water in low areas
			if height < -0.5:
				for y in range(-1, 0):
					_set_block(x, y, z, 6)

func _get_height(x, z, seed_val):
	# Simple noise-like function
	var h = sin(x * 0.15 + seed_val * 0.01) * cos(z * 0.15 + seed_val * 0.01)
	h += sin(x * 0.08 + z * 0.12) * 0.5
	h += cos(x * 0.2 - z * 0.18) * 0.3
	return h * 2 + 1  # Range roughly -2 to 5

func _get_block_type(x, y, surface_y):
	if y < surface_y - 1:
		return 3  # Stone underground
	elif y < surface_y:
		return 2  # Dirt below grass
	return 1  # Grass on surface

func _set_block(x, y, z, block_type):
	if block_type == 0:
		return
		
	var key = Vector3(x, y, z)
	
	# Remove existing
	if blocks.has(key):
		blocks[key].queue_free()
	
	# Create new block with nice mesh
	var mesh_instance = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(1, 1, 1)
	mesh_instance.mesh = box
	
	if materials.has(block_type):
		mesh_instance.material_override = materials[block_type]
	
	mesh_instance.position = Vector3(x, y, z)
	mesh_instance.create_trimesh_collision()
	
	add_child(mesh_instance)
	blocks[key] = mesh_instance

func _create_tree(x, y, z):
	# Trunk
	_set_block(x, y, z, 4)
	_set_block(x, y + 1, z, 4)
	_set_block(x, y + 2, z, 4)
	
	# Leaves
	for lx in range(x - 1, x + 2):
		for lz in range(z - 1, z + 2):
			for ly in range(y + 2, y + 4):
				if abs(lx - x) + abs(lz - z) < 2:
					_set_block(lx, ly, lz, 5)

func set_block(x, y, z, block_type):
	_set_block(x, y, z, block_type)

func get_block(x, y, z):
	var key = Vector3(x, y, z)
	return blocks.has(key)
