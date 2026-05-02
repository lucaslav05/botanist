extends Node2D

const Crop = preload("res://crop/crop.tscn")
const Portal = preload("res://portals/portal.tscn")

@onready var plot_tiles = $WorldTileMap.get_used_cells_by_id(0, Vector2i(2, 0))
@onready var portal_tiles = $WorldTileMap.get_used_cells_by_id(0, Vector2i(1, 0))

# stores Vector2i : bool (false if vacant, true if plant is there)
@export var tile_status = {}
@export var portal_tile_status = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for tile in plot_tiles:
		tile_status[tile] = false
	
	for tile in portal_tiles:
		portal_tile_status[tile] = false

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
	
	c.location = v2i
	$Plants.add_child(c)

func spawn_portal_random():
	var portal_plot = portal_tile_status.keys().pick_random()
	var portal_types = ["hell", "ice", "evernight"]
	
	#while 
	
	if portal_tile_status[portal_plot] == false:
		print("free portal slot found")
		print("placing at:", portal_plot)
		
		var p = Portal.instantiate()
		p.get_child(0).play(portal_types[randi_range(0,2)])
		portal_tile_status[portal_plot] = true
		
		var tile_pos: Vector2i = get_child(0).map_to_local(portal_plot)
		p.z_index = 1
		p.position = tile_pos
		add_child(p)

# DEBUG FUNCTION
func fill_all_plots():
	for tile in plot_tiles:
		plant_seed(tile)
		
