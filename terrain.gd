extends Node3D

const CHUNK_SIZE = 16
var blocks = {}

# Minecraft-style block materials
var materials = {}

func _ready():
	_create_materials()
	_generate_world()

func _create_materials():
	# Grass (top)
	var mat_grass = StandardMaterial3D.new()
	mat_grass.albedo_color = Color(0.35, 0.7, 0.25)
	mat_grass.metallic = 0.0
	mat_grass.roughness = 0.95
	materials[1] = mat_grass
	
	# Dirt
	var mat_dirt = StandardMaterial3D.new()
	mat_dirt.albedo_color = Color(0.35, 0.22, 0.12)
	mat_dirt.metallic = 0.0
	mat_dirt.roughness = 0.95
	materials[2] = mat_dirt
	
	# Stone
	var mat_stone = StandardMaterial3D.new()
	mat_stone.albedo_color = Color(0.45, 0.45, 0.45)
	mat_stone.metallic = 0.1
	mat_stone.roughness = 0.9
	materials[3] = mat_stone
	
	# Cobblestone
	var mat_cobble = StandardMaterial3D.new()
	mat_cobble.albedo_color = Color(0.4, 0.38, 0.35)
	mat_cobble.metallic = 0.0
	mat_cobble.roughness = 0.95
	materials[4] = mat_cobble
	
	# Oak Wood
	var mat_wood = StandardMaterial3D.new()
	mat_wood.albedo_color = Color(0.45, 0.3, 0.18)
	mat_wood.metallic = 0.0
	mat_wood.roughness = 0.85
	materials[5] = mat_wood
	
	# Oak Leaves
	var mat_leaves = StandardMaterial3D.new()
	mat_leaves.albedo_color = Color(0.25, 0.5, 0.22)
	mat_leaves.metallic = 0.0
	mat_leaves.roughness = 0.9
	mat_leaves.transparency = 1
	materials[6] = mat_leaves
	
	# Water
	var mat_water = StandardMaterial3D.new()
	mat_water.albedo_color = Color(0.2, 0.4, 0.7, 0.6)
	mat_water.metallic = 0.1
	mat_water.roughness = 0.05
	mat_water.transparency = 1
	materials[7] = mat_water
	
	# Sand
	var mat_sand = StandardMaterial3D.new()
	mat_sand.albedo_color = Color(0.76, 0.7, 0.5)
	mat_sand.metallic = 0.0
	mat_sand.roughness = 0.95
	materials[8] = mat_sand
	
	# Bedrock
	var mat_bedrock = StandardMaterial3D.new()
	mat_bedrock.albedo_color = Color(0.12, 0.12, 0.12)
	mat_bedrock.metallic = 0.0
	mat_bedrock.roughness = 1.0
	materials[9] = mat_bedrock

func _generate_world():
	var seed_val = randi()
	
	# Generate terrain
	for x in range(-20, 20):
		for z in range(-20, 20):
			var height = _get_terrain_height(x, z, seed_val)
			
			# Generate column from bottom to top
			for y in range(-3, int(height) + 1):
				if y == -3:
					_set_block(x, y, z, 9)  # Bedrock
				elif y < int(height) - 3:
					_set_block(x, y, z, 3)  # Stone
				elif y < int(height):
					_set_block(x, y, z, 2)  # Dirt
				else:
					# Surface block
					if height < 0:
						_set_block(x, y, z, 8)  # Sand (beach)
					else:
						_set_block(x, y, z, 1)  # Grass
			
			# Add water
			if height < 0:
				for y in range(int(height), 0):
					_set_block(x, y, z, 7)  # Water
			
			# Add trees on grass
			if randf() < 0.05 and height > 0:
				_create_tree(x, int(height) + 1, z)

func _get_terrain_height(x, z, seed_val):
	# Multi-octave noise for more natural terrain
	var h = 0.0
	
	# Large hills
	h += sin(x * 0.05 + seed_val * 0.01) * cos(z * 0.05 + seed_val * 0.01) * 4
	
	# Medium variation
	h += sin(x * 0.1 + z * 0.08) * 2
	h += cos(x * 0.08 - z * 0.1) * 2
	
	# Small bumps
	h += sin(x * 0.2 + z * 0.2) * 0.5
	
	# Base height
	h += 2
	
	# Clamp to reasonable range
	return clamp(h, -2, 10)

func _set_block(x, y, z, block_type):
	if block_type == 0:
		# Remove block
		var key = Vector3(x, y, z)
		if blocks.has(key):
			blocks[key].queue_free()
			blocks.erase(key)
		return
		
	var key = Vector3(x, y, z)
	
	# Remove existing
	if blocks.has(key):
		blocks[key].queue_free()
	
	# Create block mesh
	var mesh_instance = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(1, 1, 1)
	mesh_instance.mesh = box
	
	if materials.has(block_type):
		mesh_instance.material_override = materials[block_type]
	
	mesh_instance.position = Vector3(x, y, z)
	mesh_instance.name = "Block_%d_%d_%d" % [x, y, z]
	
	# Create collision
	mesh_instance.create_trimesh_collision()
	
	add_child(mesh_instance)
	blocks[key] = mesh_instance

func _create_tree(x, y, z):
	# Check not too close to other trees
	for tx in range(x - 2, x + 3):
		for tz in range(z - 2, z + 3):
			for ty in range(y - 2, y + 5):
				if blocks.has(Vector3(tx, ty, tz)):
					return  # Too close
	
	# Trunk (3-5 blocks)
	var trunk_height = randi_range(3, 5)
	for i in range(trunk_height):
		_set_block(x, y + i, z, 5)
	
	# Leaves (sphere-ish)
	var leaf_start = y + trunk_height - 1
	for lx in range(x - 2, x + 3):
		for lz in range(z - 2, z + 3):
			for ly in range(leaf_start, leaf_start + 3):
				# Don't fill center
				if abs(lx - x) + abs(lz - z) < 3 and ly == leaf_start + 2:
					continue
				if abs(lx - x) < 3 and abs(lz - z) < 3:
					if not blocks.has(Vector3(lx, ly, lz)):
						_set_block(lx, ly, lz, 6)

func set_block(x, y, z, block_type):
	_set_block(x, y, z, block_type)

func get_block(x, y, z):
	return blocks.has(Vector3(x, y, z))
