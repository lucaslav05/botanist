class_name SeedItem extends InvItem

@export var crop: PackedScene

func use(player: CharacterBody2D):
	var instantiated_crop: Crop = crop.instantiate()
	player.plant_seed(instantiated_crop)
