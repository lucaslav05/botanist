extends CharacterBody2D

@export var inv: Inv
const SPEED = 70.0
var on_stairs: bool = false

@onready var tile_map_layer_ref: TileMapLayer = get_parent().get_node("WorldTileMap")

func cartesian_to_isometric(cartesian: Vector2):
	var iso: Vector2
	if  on_stairs:
		if  cartesian.x != 0:
			iso = Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)
		else:	
			iso = Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)*1.25)
	else:
		iso = Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)
	
	return iso

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	velocity = cartesian_to_isometric(velocity)
	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("e"):
		var tile_pos: Vector2i = tile_map_layer_ref.local_to_map(global_position)
		if tile_pos in get_parent().tile_status:
			get_parent().plant_seed(tile_pos)

func collect(item):
	inv.insert(item)

func _on_stair_box_body_entered(body: Node2D) -> void:
	if body == self:
		print("entered stair")
		on_stairs = !on_stairs

func _on_stair_box_body_exited(body: Node2D) -> void:
	if body == self:
		print("exited stair")
		on_stairs = !on_stairs
