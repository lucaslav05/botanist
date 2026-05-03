extends Node2D

@export var local_pos: Vector2i
@export var existence_time_range = [5, 10]

const evernight_seed = preload("res://inventory/items/evernight_seed_collectable.tscn")
const hell_seed = preload("res://inventory/items/hell_seed_collectable.tscn")
const ice_seed = preload("res://inventory/items/ice_seed_collectable.tscn")

@onready var existence_timer_ref: Timer = get_child(2)
@onready var parent_ref: Node2D = get_parent().get_parent()

var player_in_area: bool = false
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var existence_time = randi_range(existence_time_range[0], existence_time_range[1])
	print("Living for: ", existence_time)
	existence_timer_ref.wait_time = existence_time
	existence_timer_ref.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if existence_timer_ref.time_left == 0:
		parent_ref.portal_tile_status[local_pos] = false
		dismiss_portal()
		
	if player_in_area:
		print("portal type: ", $animation.animation)
	if player_in_area and Input.is_action_just_pressed("e"):
		print("portal: dropping seeds")
		
		var seed_drop_count: int = randi_range(2, 5)
		
		for x in range(seed_drop_count):
			drop_seeds()
		dismiss_portal()
		

func drop_seeds():
	await get_tree().create_timer(0.0).timeout
	
	var seed_instance
	if $animation.animation == "hell":
		seed_instance = hell_seed.instantiate()
	if $animation.animation == "ice":
		seed_instance = ice_seed.instantiate()
	if $animation.animation == "evernight":
		seed_instance = evernight_seed.instantiate()
		
	seed_instance.rotation = rotation
	seed_instance.global_position = $Marker2D.global_position
	get_parent().add_child(seed_instance)
	self.visible = false
	await get_tree().create_timer(3).timeout
	queue_free()
	
func dismiss_portal():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("Player entered: portal range")
		player_in_area = true

func _on_area_2d_body_exited(body):
	print("Player exited: portal range")
	player_in_area = false
