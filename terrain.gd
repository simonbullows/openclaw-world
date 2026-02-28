extends Node3D

const CHUNK_SIZE = 16
var blocks = {}  # Dictionary to store block positions

# Block colors
var block_colors = {
	0: Color(0, 0, 0, 0),  # Air - transparent
	1: Color(0.3, 0.8, 0.3),  # Grass - green
	2: Color(0.5, 0.5, 0.5),  # Stone - gray
	3: Color(0.6, 0.4, 0.2),  # Wood - brown
	4: Color(0.3, 0.3, 0.8),  # Water - blue
}

# Block materials
var materials = {}

func _ready():
	# Create materials for each block type
	for id in block_colors:
		if id > 0:
			var mat = StandardMaterial3D.new()
			mat.albedo_color = block_colors[id]
			materials[id] = mat

func set_block(x, y, z, block_type):
	var key = Vector3(x, y, z)
	
	# Remove existing block mesh if present
	if blocks.has(key):
		blocks[key].queue_free()
	
	# Add new block
	if block_type > 0:
		var mesh_instance = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(1, 1, 1)
		mesh_instance.mesh = box
		mesh_instance.material_override = materials[block_type]
		mesh_instance.position = Vector3(x, y, z)
		add_child(mesh_instance)
		blocks[key] = mesh_instance

func get_block(x, y, z):
	var key = Vector3(x, y, z)
	if blocks.has(key):
		return blocks[key]
	return null
