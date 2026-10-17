extends Node3D

@export var chair_scene: PackedScene
@export var num_x: int = 100
@export var num_y: int = 100

@export var stride: float = 1.0

func _ready() -> void:
	fill.call_deferred()

func fill():
	var rng := RandomNumberGenerator.new()
	rng.seed = GlobalState.get_room_seed()
	
	for i_x in range(num_x):
		var x := stride * (i_x - num_x / 2)
		for i_y in range(num_y):
			var y := stride * (i_y - num_y / 2)
			var instance = chair_scene.instantiate() as Node3D
			instance.randomize(rng)
			self.add_child(instance)
			instance.position = Vector3(x, 0.0, y)
