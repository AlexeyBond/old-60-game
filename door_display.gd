extends MeshInstance3D


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	var dd := $SubViewport/DoorDisplay
	dd.location_dx = $"..".location_dx
	dd.location_dy = $"..".location_dy
	dd.refresh()

	var svp := $SubViewport
	svp.size = Vector2i(256, 128)
	svp.render_target_update_mode = SubViewport.UpdateMode.UPDATE_WHEN_VISIBLE
	mesh = mesh.duplicate()
	var mat := mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.albedo_texture = svp.get_texture()
	mesh.surface_set_material(0, mat)


func _process(delta: float) -> void:
	pass
