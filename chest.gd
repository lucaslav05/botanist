extends Node2D

@onready var inventory: Inv = preload("res://inventory/playerinv.tres")

var player_in_area = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_in_area:
			if Input.is_action_just_pressed("e"):
				remove_flowers()
				
func remove_flowers():
	var flowerSum: int = 0
	for slot in inventory.slots:
		if !slot:
			continue
		if !slot.item:
			continue
		if slot.item is FlowerItem:
			var flow: FlowerItem = slot.item
			inventory.removeSlot(slot)
			flowerSum += (slot.amount * flow.pointValue)
	Global.score += flowerSum
		


func _on_depot_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered Chest")
		player_in_area = true
		$Sprite2D.texture = "res://animations/chest_open.png"
		player = body


func _on_depot_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		print("Player exited Chest")
		player_in_area = false
		$Sprite2D.texture = "res://animations/chest.png"
