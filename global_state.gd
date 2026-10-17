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

func get_entrance_door() -> Door:
	for door in get_tree().get_nodes_in_group(&"doors"):
		door = door as Door
		if door.this_entrance_direction == next_entrance_direction:
			return door

	assert(false, "No door for entrance %s among %d doors" % [next_entrance_direction, get_tree().get_node_count_in_group(&"doors")])
	return null

func change_level(next_level: String):
	print("change level to %s, location=(%d;%d)", next_level, location_x, location_y)
	var err := get_tree().change_scene_to_file(next_level)
	assert(err == OK)
