extends Node3D

@export var order_preview: Node

func _on_area_3d_body_entered(body: Node3D) -> void:
	var chair := body as Chair

	if chair == null:
		return

	var gs := GlobalState

	if chair.description == gs.order_desc:
		$yes_player.play()
		chair.queue_free()
		gs.commit_order(order_preview.get_chair())
	else:
		$no_player.play()
