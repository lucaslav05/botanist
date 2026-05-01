extends Node2D

var state = "no flower"
var player_in_area = false

#@export var seedTexture: Texture2D
#@export var flowerTexture: Texture2D


@export var item: InvItem

var crop_data : CropData
@onready var sprite : Sprite2D = $Sprite2D

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if state == "no flower":
		#$growth_timer.start()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if state == "no flower":
		##$Sprite2D.texture = seedTexture
		#sprite.texture = crop_data.growth_sprites[0]
		#
	#if state == "flower":
		##$Sprite2D.texture = flowerTexture
		#sprite.texture = crop_data.growth_sprites[0]
		#
		#if player_in_area:
			#if Input.is_action_just_pressed("e"):
				#state = "no flower"
				#drop_flower()
				#
#func drop_flower():
	#pass
		#
