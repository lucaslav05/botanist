extends Node2D

const Crop = preload("res://crop/crop.tscn")

@onready var tile_map = $WorldTileMap.get_used_cells_by_id(0, Vector2i(2, 0))
@export var tile_status = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in tile_map:
		tile_status[tile] = false

	print(tile_status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func plant_seed(v2i: Vector2i):
	
	# Create and Load textures
	var c = Crop.instantiate()
	c.seedTexture = load("res://crop/crop-growth-0001.png")
	c.flowerTexture = load("res://crop/crop-growth-0002.png")

	# Positioning
	c.position = $WorldTileMap.map_to_local(v2i)
	var tile_size = $WorldTileMap.tile_set.tile_size
	c.get_child(0).position += Vector2(0, tile_size.y*2)
	c.get_child(0).offset.y = -32
	
	$Plants.add_child(c)

# DEBUG FUNCTION
func fill_all_plots():
	for tile in tile_map:
		plant_seed(tile)
		
