extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_font_size_override("font_size", 62)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var time_remaining: int = get_parent().get_parent().get_child(10).time_left
	var time_remaining: int = $"../../GameTimer".time_left
	
	var min = time_remaining/60
	var sec = time_remaining%60
	
	text = str("%02d:%02d" % [min, sec])
