extends RigidBody3D

@export var surface_scenes: Array[PackedScene]
@export var back_scenes: Array[PackedScene]
@export var feet_scenes: Array[PackedScene]

func _ready() -> void:
	self.randomize(RandomNumberGenerator.new())

func pick_scene(scenes: Array[PackedScene], target_node: Node3D, rng: RandomNumberGenerator):
	var scene := scenes[rng.randi_range(0, scenes.size()-1)]
	for child in target_node.get_children():
		target_node.remove_child(child)
	var instance := scene.instantiate()

	if instance.has_method(&"randomize"):
		instance.randomize(rng)

	target_node.add_child(instance)

func randomize(rng: RandomNumberGenerator):
	pick_scene(surface_scenes, $surface, rng)
	pick_scene(back_scenes, $back, rng)
	pick_scene(feet_scenes, $"feet-rf", rng)
	pick_scene(feet_scenes, $"feet-rb", rng)
	pick_scene(feet_scenes, $"feet-lf", rng)
	pick_scene(feet_scenes, $"feet-lb", rng)
