extends Node3D

@export var allowed_materials: Array[Material]

func randomize(rng: RandomNumberGenerator) -> String:
	var mat_n := rng.randi_range(0, allowed_materials.size()-1)
	var mat := allowed_materials[mat_n]
	for c in get_children():
		c.material_override = mat

	return "M%d" % mat_n
