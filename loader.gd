extends Node3D

@export_range(1.0, 100.0) var disappear_distance: float = 20.0
@export_range(1.0, 100.0) var appear_distance: float = 50.0

func _ready() -> void:
	#hide()
	pass


func _process(delta: float) -> void:
	var player := get_viewport().get_camera_3d()

	if player == null:
		return

	var distance_to_player := global_position.distance_to(player.global_position)
	#print("DST=", distance_to_player)

	if distance_to_player < disappear_distance:
		if visible:
			if $Timer.is_stopped():
				$Timer.start(0.2)
				print("HIDING(DST)")
			return
		else:
			return

	var a := Vector2(player.global_position.x, player.global_position.z).angle_to_point(Vector2(global_position.x, global_position.z))
	global_rotation = Vector3(0, -a + PI * 0.5, 0)

	var dp := (global_position - player.global_position).normalized().dot(
		-player.global_basis.z
	)

	#if dp < 0.9:
	if player.is_position_behind(global_position):
		if not visible:
			print("SHOWING(PB)")
			show()
	else:
		var p := player.unproject_position(global_position)
		var in_screen_center := get_viewport().get_visible_rect().grow(-100).has_point(p)
		if in_screen_center:
			if $Timer.is_stopped():
				$Timer.start(1.0)
				print("HIDING(R)")
		#else:
			#show()
			#print("SHOWING(R)")

func relocate():
	var chairs := get_tree().get_nodes_in_group(&"chairs")
	var chair = chairs[randi_range(0, chairs.size()-1)] as Node3D
	global_position = chair.global_position + Vector3.UP * 0.5

func _on_timer_timeout() -> void:
	hide()
	relocate()
