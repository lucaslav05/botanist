extends Timer

@export var timer_wait : int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("timer exists")
	var timer_wait = randi_range(1,10)
	print("initial wait: ", timer_wait)
	wait_time = timer_wait
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_left == 0:
		print("timer done")
		
		get_parent().spawn_portal_random()
		
		var timer_wait = randi_range(1,10)
		print("initial wait: ", timer_wait)
		wait_time = timer_wait
		start()
