extends Timer

@export var wait_range = [1, 1]
@export var timer_wait : int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("timer exists")
	var timer_wait = randi_range(wait_range[0], wait_range[1])
	print("initial wait: ", timer_wait)
	wait_time = timer_wait
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_left == 0:
		print("timer done")
		
		get_parent().spawn_portal_random()
		
		var timer_wait = randi_range(wait_range[0],wait_range[1])
		print("initial wait: ", timer_wait)
		wait_time = timer_wait
		start()
