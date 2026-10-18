extends Node3D

@export var pl: PlayerCharacter

@export var chair_scene: PackedScene

func _ready() -> void:
	var gs := GlobalState as CGLobalState
	
	if gs.holds_chair:
		%chair_preview_layer.show()
		%ChairPreview.preview_seed(gs.held_chair_seed)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact_chair"):
		var gs: CGLobalState = GlobalState
		if gs.holds_chair:
			var chair := chair_scene.instantiate() as Chair

			var offset := -pl.cam.global_basis.z * 1.0
			offset.y = 0

			gs.drop_chair()
			get_tree().current_scene.add_child(chair)
			chair.global_position = pl.cam.global_position + offset
			chair.restore_from_seed(gs.held_chair_seed)
			chair.apply_impulse(-pl.cam.global_basis.z * 5.0)
			%chair_preview_layer.hide()
		else:
			var c := _cast_chair()
			if c != null:
				gs.take_chair(c)
				c.queue_free()
				%chair_preview_layer.show()
				%ChairPreview.preview_seed(gs.held_chair_seed)

func _cast_chair() -> Chair:
	var n := pl.cam.project_ray_normal(get_viewport().get_visible_rect().size / 2.0)
	var p := pl.cam.global_position
	
	var ir := get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			p,
			p + n.normalized() * 2.0,
			1<<2,
		)
	)
	
	if ir.is_empty():
		return null
	
	var collider = ir[&"collider"]
	
	assert(collider is Chair)
	
	return collider
