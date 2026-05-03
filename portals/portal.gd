extends Node2D

@export var local_pos: Vector2i
@export var existence_time_range = [5, 10]

@onready var existence_timer_ref: Timer = get_child(2)
@onready var parent_ref: Node2D = get_parent().get_parent()

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
		queue_free()
	pass
