extends Node2D

const Crop = preload("res://crop.tscn")
var tile_map


# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = $WorldTileMap.get_used_cells_by_id(0, Vector2i(2, 0))
	
	for tile in tile_map:
		plant_seed(tile)
		print(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func plant_seed(v2i: Vector2i):
	var c = Crop.instantiate()
	c.seedTexture = load("res://crop/crop-growth-0001.png")
	c.flowerTexture = load("res://crop/crop-growth-0002.png")

	c.position = $WorldTileMap.map_to_local(v2i)
	
	var tile_size = $WorldTileMap.tile_set.tile_size
	c.get_child(0).position += Vector2(0, tile_size.y*2)
	c.get_child(0).offset.y = -32
	$Plants.add_child(c)
