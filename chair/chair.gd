extends RigidBody3D
class_name Chair

@export var surface_scenes: Array[PackedScene]
@export var back_scenes: Array[PackedScene]
@export var feet_scenes: Array[PackedScene]

var chair_seed: int
var description: String

func pick_scene(
	scenes: Array[PackedScene],
	target_node: Node3D,
	rng: RandomNumberGenerator,
	desc_prefix: String,
) -> String:
	var scene_n := rng.randi_range(0, scenes.size()-1)
	var scene := scenes[scene_n]
	for child in target_node.get_children():
		target_node.remove_child(child)
	var instance := scene.instantiate()

	var sub_desc: String = &""

	if instance.has_method(&"randomize"):
		sub_desc = instance.randomize(rng)

	target_node.add_child(instance)

	return "%s:V%d,%s;\n" % [desc_prefix, scene_n, sub_desc]

func restore_from_seed(s: int):
	var rng := RandomNumberGenerator.new()
	rng.state = s
	self._randomize(rng)

func randomize(rng: RandomNumberGenerator):
	_randomize(rng)

	if GlobalState.holds_chair_with_seed(chair_seed):
		queue_free()
		return

func _randomize(rng: RandomNumberGenerator):
	chair_seed = rng.state
	#print("CS=", chair_seed)
	var desc: String = ""
	desc += pick_scene(surface_scenes, $surface, rng, "S")
	desc += pick_scene(back_scenes, $back, rng, "B")
	desc += pick_scene(feet_scenes, $"feet-rf", rng, "Frf")
	desc += pick_scene(feet_scenes, $"feet-rb", rng, "Frb")
	desc += pick_scene(feet_scenes, $"feet-lf", rng, "Flf")
	desc += pick_scene(feet_scenes, $"feet-lb", rng, "Flb")
	self.description = desc
	#print(chair_seed, desc)
