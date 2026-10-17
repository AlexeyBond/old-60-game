extends Node3D

@export var player_scene: PackedScene

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	if get_tree().get_first_node_in_group(&"player") == null:
		print("Spawning player...")
		add_child(player_scene.instantiate())
	else:
		print("Not spawning player again")
