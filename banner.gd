extends MeshInstance3D

@export var textures: Array[Texture2D]

func _ready() -> void:
	var tx = textures[(GlobalState.location_x * 3 + GlobalState.location_y * 7) % textures.size()]
	
	mesh = mesh.duplicate()
	var mat := mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.albedo_texture = tx
	mesh.surface_set_material(0, mat)
