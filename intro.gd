extends CanvasLayer

@export_file("*.tscn") var game_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%intro_text.visible_ratio = 0
	var tw := get_tree().create_tween()
	tw.tween_property(
		%intro_text,
		"visible_ratio",
		1.0,
		10.0
	)
	tw.tween_callback(_goto_game)
	tw.play()

func _goto_game():
	GlobalState.change_level(game_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
