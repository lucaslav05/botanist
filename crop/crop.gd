extends Node2D

class_name Crop

var state = "no flower"
var player_in_area = false
var player = null
var harvested = false
var location : Vector2i

@export var seedTexture: Texture2D
@export var flowerTexture: Texture2D
@export var flower: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == "no flower":
		var growing_time: int = randi_range(20,30)
		$growth_timer.wait_time = growing_time
		print(growing_time)
		$growth_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if $growth_timer.time_left == 0:
		state = "flower"
	
	if state == "no flower":
		$Sprite2D.texture = seedTexture
	if state == "flower":
		$Sprite2D.texture = flowerTexture
		if player_in_area and not harvested:
			if Input.is_action_just_pressed("e"):
				print("SHOULD HARVEST")
				harvested = true
				state = "no flower"
				drop_flower()
				get_parent().get_parent().tile_status[location] = false

func drop_flower():
	await get_tree().create_timer(0.0).timeout
	var flower_instance = flower.instantiate()
	flower_instance.rotation = rotation
	flower_instance.global_position = $Marker2D.global_position
	get_parent().add_child(flower_instance)
	self.visible = false
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_harvest_body_entered(body):
	if body.name == "Player":
		print("Player entered")
		player_in_area = true
		player = body

func _on_harvest_body_exited(body):
	if body.name == "Player":
		print("Player exited")
		player_in_area = false
