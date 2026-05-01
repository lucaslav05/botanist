extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var filled_tiles := get_used_cells()
	for filled_tile: Vector2i in filled_tiles:
		var neighbouring_tiles := get_surrounding_cells(filled_tile)
		for neighbour: Vector2i in neighbouring_tiles:
			if get_cell_source_id(neighbour) == -1:
				set_cell(neighbour, 0, Vector2i.ZERO)
				#
				#
	#tile_map = get_used_cells_by_id(0, Vector2i(2, 0))
	#for tile in tile_map:
		#plant_seed(tile)
		#print(tile)
#
#func plant_seed(v2i: Vector2i):
	#var c = Crop.instantiate()
	#
	#c.seedTexture = load("res://crop/crop-growth-0001.png")
	#c.flowerTexture = load("res://crop/crop-growth-0002.png")
#
	#c.position = map_to_local(v2i)
	##var tile_size = tile_set.tile_size
	##c.position += Vector2(0, tile_size.y*-1)
	#add_child(c)
