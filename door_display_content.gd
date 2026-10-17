extends CanvasLayer


var location_dx: int
var location_dy: int

func refresh():
	$Label.text = "ТЦ \"Вавилон\"\nСклад %03d-%03d" % [
		(GlobalState.location_x + location_dx + GlobalState.SIZE_X) % GlobalState.SIZE_X,
		(GlobalState.location_y + location_dy + GlobalState.SIZE_Y) % GlobalState.SIZE_Y,
	]
