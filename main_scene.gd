extends Node2D

#const Crop = preload("res://crop/evernight_crop.tscn")
const Portal = preload("res://portals/portal.tscn")

@onready var plot_tiles = $WorldTileMap.get_used_cells_by_id(0, Vector2i(2, 0))
@onready var portal_tiles = $WorldTileMap.get_used_cells_by_id(0, Vector2i(1, 0))

@onready var tile_size = $WorldTileMap.tile_set.tile_size

# stores Vector2i : bool (false if vacant, true if plant is there)
@export var tile_status = {}
@export var portal_tile_status = {}

var gameover: bool = false
var instructions_on_screen = false

const SAVEFILE = "user://savefile.save"
var highest_record = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameTimer.start(60)
	gameover = false
	$CanvasLayer/toggleInstructions.show
	$CanvasLayer/instructionBoard.hide()
	
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = load("res://maintheme.ogg")
	$AudioStreamPlayer.play()
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_out")
	
	for tile in plot_tiles:
		tile_status[tile] = false
	
	for tile in portal_tiles:
		portal_tile_status[tile] = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("toggle_instructions"):
		print("Y pressed")
	if Input.is_action_just_pressed("toggle_instructions") && instructions_on_screen == false:
		print("a")
		$CanvasLayer/instructionBoard.visible = true
		$CanvasLayer/toggleInstructions.visible = false
		instructions_on_screen = true
	
	elif Input.is_action_just_pressed("toggle_instructions") && instructions_on_screen == true:
		print("b")
		$CanvasLayer/instructionBoard.visible = false
		$CanvasLayer/toggleInstructions.visible = true
		instructions_on_screen = false
		
	if $GameTimer.time_left == 0 && gameover == false:
		gameover = true
		var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
		file.store_32(get_highest(Global.score))
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = load("res://game_over.wav")
		$AudioStreamPlayer.play()
		$CanvasLayer/Fade_transition.show()
		$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
		await $AudioStreamPlayer.finished
		
		
		get_tree().change_scene_to_file("res://main_menu.tscn")

func get_highest(score: int):
	if FileAccess.file_exists(SAVEFILE):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		var record = file.get_32()
		file.close()
		if score > record:
			highest_record = score
		else:
			highest_record = record
	else:
			highest_record = score


func plant_seed(v2i: Vector2i, c: Crop):
	
	# Positioning
	c.position = $WorldTileMap.map_to_local(v2i)
	
	c.get_child(0).position += Vector2(0, tile_size.y*2)
	c.get_child(0).offset.y = -32
	
	c.location = v2i
	$Plants.add_child(c)

func spawn_portal_random():
	var portal_plot = portal_tile_status.keys().pick_random()
	var portal_types = ["hell", "ice", "evernight"]
	
	#while 
	
	if portal_tile_status[portal_plot] == false:
		print("free portal slot found")
		print("placing at:", portal_plot)
		
		var p = Portal.instantiate()
		p.get_child(0).play(portal_types[randi_range(0,2)])
		portal_tile_status[portal_plot] = true
		
		var tile_pos: Vector2i = get_child(0).map_to_local(portal_plot)
		p.z_index = 1
		p.position = tile_pos
		p.local_pos = portal_plot
		
		p.get_child(0).position += Vector2(0, tile_size.y*2)
		p.get_child(0).offset.y = -32
		
		print("z index", p.z_index)
		print("y sort", p.y_sort_enabled)
		$Portals.add_child(p)



func _on_game_timer_timeout() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	get_highest(Global.score)
	file.store_32(highest_record)
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = load("res://game_over.wav")
	$AudioStreamPlayer.play()
	$CanvasLayer/Fade_transition.show()
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
	await $AudioStreamPlayer.finished
		
	get_tree().change_scene_to_file("res://main_menu.tscn")
