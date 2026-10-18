extends Node
class_name CGLobalState

var location_x: int = 0
var location_y: int = 0
var next_entrance_direction: String = ''

const SIZE_X: int = 256
const SIZE_Y: int = 256

func apply_location_delta(dx: int, dy: int):
	location_x = (location_x + dx + SIZE_X) % SIZE_X
	location_y = (location_y + dy + SIZE_Y) % SIZE_Y

func get_room_seed() -> int:
	return location_x + location_y * SIZE_X

func get_entrance_door() -> Door:
	for door in get_tree().get_nodes_in_group(&"doors"):
		door = door as Door
		if door.this_entrance_direction == next_entrance_direction:
			return door

	assert(false, "No door for entrance %s among %d doors" % [next_entrance_direction, get_tree().get_node_count_in_group(&"doors")])
	return null

func _ready() -> void:
	$AnimationPlayer.play("fade-in")

@export_file("*.tscn") var restart_level: String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"restart"):
		change_level(restart_level)
		order_set = false
		holds_chair = false

var next_transition: String = ""

func change_level(next_level: String):
	next_transition = next_level
	$AnimationPlayer.play("fade-out")

func execute_transition():
	print("change level to %s, location=(%d;%d)" % [next_transition, location_x, location_y])
	var err := get_tree().change_scene_to_file(next_transition)
	assert(err == OK)
	$AnimationPlayer.play("fade-in")


var held_chair_seed: int
var holds_chair: bool

func take_chair(c: Chair):
	held_chair_seed = c.chair_seed
	holds_chair = true

func drop_chair():
	holds_chair = false

func holds_chair_with_seed(s: int) -> bool:
	return holds_chair and held_chair_seed == s

var order_set: bool = false
var order_desc: String = ""
var order_seed: int = 0

func sync_order(preview: Chair):
	if order_set:
		preview.restore_from_seed(order_seed)
		assert(preview.description == order_desc)
	else:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		preview.randomize(rng)
		order_set = true
		order_desc = preview.description
		order_seed = preview.chair_seed

func commit_order(preview: Chair):
	order_set = false
	sync_order(preview)
