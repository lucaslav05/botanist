extends CharacterBody2D

@export var inv: Inv
const SPEED = 70.0
var on_stairs: bool = false
var current_direction
var prev_direction 

enum direction {
	UP,
	UP_RIGHT,
	UP_LEFT,
	DOWN,
	DOWN_RIGHT,
	DOWN_LEFT,
	LEFT,
	RIGHT,
	IDLE_UP,
	IDLE_UP_RIGHT,
	IDLE_UP_LEFT,
	IDLE_DOWN,
	IDLE_DOWN_RIGHT,
	IDLE_DOWN_LEFT,
	IDLE_LEFT,
	IDLE_RIGHT,
}

var KEY_UP = false
var KEY_DOWN = false
var KEY_LEFT = false
var KEY_RIGHT = false

@onready var tile_map_layer_ref: TileMapLayer = get_parent().get_node("WorldTileMap")


func _ready() -> void:
	inv.use_item.connect(use_item)
	
func _process(delta: float) -> void:
	get_input()
	set_direction()
	move()		
	
func get_input():
	if Input.is_action_pressed("ui_up"): KEY_UP = true
	else: KEY_UP = false
	
	if Input.is_action_pressed("ui_down"): KEY_DOWN = true
	else: KEY_DOWN = false
	
	if Input.is_action_pressed("ui_right"): KEY_RIGHT = true
	else: KEY_RIGHT = false
	
	if Input.is_action_pressed("ui_left"): KEY_LEFT = true
	else: KEY_LEFT = false

func set_direction():

	if KEY_UP:
		if KEY_LEFT:
			current_direction = direction.UP_LEFT
		elif KEY_RIGHT:
			current_direction = direction.UP_RIGHT
		else:
			current_direction = direction.UP
	elif KEY_DOWN:
		if KEY_LEFT:
			current_direction = direction.DOWN_LEFT
		elif KEY_RIGHT:
			current_direction = direction.DOWN_RIGHT
		else:
			current_direction = direction.DOWN
	elif KEY_LEFT:
			current_direction = direction.LEFT
	elif KEY_RIGHT:
			current_direction = direction.RIGHT
	else:
		match current_direction:
			direction.UP:
				current_direction = direction.IDLE_UP
			direction.UP_RIGHT: 
				current_direction = direction.IDLE_UP_RIGHT
			direction.UP_LEFT:
				current_direction = direction.IDLE_UP_LEFT
			direction.DOWN:
				current_direction = direction.IDLE_DOWN
			direction.DOWN_RIGHT:
				current_direction = direction.IDLE_DOWN_RIGHT
			direction.DOWN_LEFT:
				current_direction = direction.IDLE_DOWN_LEFT
			direction.LEFT:
				current_direction = direction.IDLE_LEFT
			direction.RIGHT:
				current_direction = direction.IDLE_RIGHT
			

func move():
	match current_direction:
		direction.UP: 
			$AnimatedSprite2D.play("up-walk")
		direction.UP_RIGHT: 
			$AnimatedSprite2D.play("up-right-walk")
		direction.UP_LEFT:
			$AnimatedSprite2D.play("up-left-walk")
		direction.DOWN:
			$AnimatedSprite2D.play("down-walk")
		direction.DOWN_RIGHT:
			$AnimatedSprite2D.play("down-right-walk")
		direction.DOWN_LEFT:
			$AnimatedSprite2D.play("down-left-walk")
		direction.LEFT:
			$AnimatedSprite2D.play("left-walk")
		direction.RIGHT:
			$AnimatedSprite2D.play("right-walk")
		direction.IDLE_UP: 
			$AnimatedSprite2D.play("up")
		direction.IDLE_UP_RIGHT: 
			$AnimatedSprite2D.play("up-right")
		direction.IDLE_UP_LEFT:
			$AnimatedSprite2D.play("up-left")
		direction.IDLE_DOWN:
			$AnimatedSprite2D.play("down")
		direction.IDLE_DOWN_RIGHT:
			$AnimatedSprite2D.play("down-right")
		direction.IDLE_DOWN_LEFT:
			$AnimatedSprite2D.play("down-left")
		direction.IDLE_LEFT:
			$AnimatedSprite2D.play("left")
		direction.IDLE_RIGHT:
			$AnimatedSprite2D.play("right")
		


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

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	velocity = cartesian_to_isometric(velocity)
	move_and_slide()

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
		
func plant_seed(crop: Crop):
	var tile_pos: Vector2i = tile_map_layer_ref.local_to_map(global_position)
	get_parent().plant_seed(tile_pos, crop)
	get_parent().tile_status[tile_pos] = true

func can_plant() -> bool:
	var tile_pos: Vector2i = tile_map_layer_ref.local_to_map(global_position)
	if tile_pos in get_parent().tile_status:
		if get_parent().tile_status[tile_pos] == false:
			return true
	return false


func use_item(item: InvItem):
	if !item.can_be_used(self): return
	item.use(self)
	inv.remove_last_used_item()
	
