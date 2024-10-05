extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_tree().get_current_scene().get_global_mouse_position()
	$SubViewport/Camera2D.global_position = pos
	pos.y -= 130
	pos.x -= 130
	if (pos.x < 200):
		pos.x = 200
	if (pos.y < 50):
		pos.y = 50
	global_position = pos
