class_name SeedItem extends InvItem

@export var crop: PackedScene

func use(player: CharacterBody2D):
	var instantiated_crop: Crop = crop.instantiate()
	player.plant_seed(instantiated_crop)

func can_be_used(player: CharacterBody2D) -> bool:
	return player.can_plant()
