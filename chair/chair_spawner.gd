extends Node3D

@export var chair_scene: PackedScene
@export var num_x: int = 100
@export var num_y: int = 100

@export var stride: float = 1.0

func _ready() -> void:
	fill.call_deferred()

func _spawn_chair(rng: RandomNumberGenerator, x: float, y: float, r: float = 0):
	var instance = chair_scene.instantiate() as Node3D
	instance.randomize(rng)
	self.add_child(instance)
	instance.position = Vector3(x, 0.0, y)
	instance.rotate(Vector3.UP, r)

func fill_rect(rng: RandomNumberGenerator):
	for i_x in range(num_x):
		var x := stride * (i_x - num_x / 2)
		for i_y in range(num_y):
			var y := stride * (i_y - num_y / 2)
			_spawn_chair(rng, x, y)

func fill_radial(rng: RandomNumberGenerator):
	var r: float = 0
	var max_r := minf(num_x, num_y) * stride / 2.0

	while true:
		r += stride
		if r > max_r:
			break

		var n = floor(2.0 * PI * r / stride)

		var a := rng.randf_range(0, PI)
		var da := 2.0 * PI / float(n)

		for i in range(n):
			_spawn_chair(
				rng,
				cos(a) * r,
				sin(a) * r,
				-a - PI * 0.5,
			)
			a += da

func fill_randomized(rng: RandomNumberGenerator):
	for i_x in range(num_x):
		var x := stride * (i_x - num_x / 2)
		for i_y in range(num_y):
			if rng.randf_range(0, 1.0) > 0.95:
				continue
			var y := stride * (i_y - num_y / 2)
			_spawn_chair(
				rng,
				x + randf_range(-stride/2, stride/2) * 0.8,
				y + randf_range(-stride/2, stride/2) * 0.8,
				rng.randf_range(-PI, PI),
			)

func fill():
	var rng := RandomNumberGenerator.new()
	rng.seed = GlobalState.get_room_seed()
	
	#fill_randomized(rng)
	#return

	var mode := rng.randi_range(0, 4)
	print("MODE=", mode)
	match mode:
		0, 1, 3:
			fill_rect(rng)
		2:
			fill_radial(rng)
		4:
			fill_randomized(rng)
