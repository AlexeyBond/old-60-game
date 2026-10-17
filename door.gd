extends Node3D
class_name Door

@export_file("*.tscn") var target_level: String
@export var player_scene: PackedScene

@export var location_dx: int = 0
@export var location_dy: int = 0

@export var next_entrance_direction: String = 'S'
@export var this_entrance_direction: String = 'N'

func _ready() -> void:
	print("Door %s ready" % [this_entrance_direction])
	if GlobalState.next_entrance_direction == this_entrance_direction:
		enter_player()


func _on_exit_area_body_entered(body: Node3D) -> void:
	transport()

func transport():
	GlobalState.apply_location_delta(location_dx, location_dy)
	GlobalState.next_entrance_direction = next_entrance_direction
	GlobalState.change_level.call_deferred(target_level)

func enter_player():
	print("Entering from door %s" % [this_entrance_direction])
	var player = player_scene.instantiate() as Node3D
	player.global_transform = $entrance.global_transform
	get_parent().add_child.call_deferred(player)
