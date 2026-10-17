extends Node3D

@export var allowed_materials: Array[Material]

func randomize(rng: RandomNumberGenerator):
	var mat := allowed_materials[rng.randi_range(0, allowed_materials.size()-1)]
	for c in get_children():
		c.material_override = mat
