extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	var dir := global_position.direction_to(body.global_position)
	dir.y = 0.2
	dir = dir.normalized()

	(body as Chair).apply_impulse(
		dir * 0.5 * (1.0 + 2.0 * max(0.0, get_parent().velocity.dot(dir))),
	)
