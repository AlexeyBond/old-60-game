extends Node3D

@export var chair_scene: PackedScene
@export var num_x: int = 100
@export var num_y: int = 100

@export var stride: float = 1.0

func _ready() -> void:
	fill.call_deferred()

func _spawn_chair(rng: RandomNumberGenerator, x: float, y: float, r: float = 0):
	var instance = chair_scene.instantiate() as Chair
	instance.randomize(rng)
	self.add_child(instance)
	instance.position = Vector3(x, 0.0, y)
	instance.rotate(Vector3.UP, r)

func fill_rect(rng: RandomNumberGenerator):
	for i_x in range(num_x):
		var x := stride * (i_x - num_x / 2.0)
		for i_y in range(num_y):
			var y := stride * (i_y - num_y / 2.0)
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
		var x := stride * (i_x - num_x / 2.0)
		for i_y in range(num_y):
			if rng.randf_range(0, 1.0) > 0.95:
				continue
			var y := stride * (i_y - num_y / 2.0)
			_spawn_chair(
				rng,
				x + randf_range(-stride/2, stride/2) * 0.8,
				y + randf_range(-stride/2, stride/2) * 0.8,
				rng.randf_range(-PI, PI),
			)

func fill_single(rng: RandomNumberGenerator):
	print("FSST=", rng.state)
	_spawn_chair(
		rng,
		0, 0, 0,
	)

func fill():
	var rng := RandomNumberGenerator.new()
	rng.state = GlobalState.get_room_seed()
	print("Fill seed=", rng.state)

	var mode := rng.randi_range(0, 4)

	#fill_single(rng)
	#return

	print("MODE=", mode)
	match mode:
		0, 1, 2:
			if rng.randf_range(0, 1) > 0.99:
				fill_single(rng)
			else:
				fill_rect(rng)
		3:
			fill_radial(rng)
		4:
			fill_randomized(rng)
