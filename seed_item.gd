class_name SeedItem extends InvItem

@export var crop: PackedScene

func use(player: CharacterBody2D):
	player.plant_seed()
