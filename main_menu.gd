extends Node2D

@onready var button_manager: Control = $Button_manager
@onready var options: Panel = $Options

var button_type = null
const SAVEFILE = "user://savefile.save"
var highest_record = 0

func _ready() -> void:
	load_score()
	$Highscore/ScoreCounter.text = str(highest_record)
	$AudioStreamPlayer.play()
	button_manager.visible = true
	options.visible = false
	
func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		highest_record = file.get_32()

func _on_start_pressed() -> void:
	$AudioStreamPlayer.stop()
	button_type = "start"
	$Fade_transition.show()
	$Fade_transition/Fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")

func _on_options_pressed() -> void:
	button_manager.visible = false
	options.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_back_pressed() -> void:
	button_manager.visible = true
	options.visible = false
