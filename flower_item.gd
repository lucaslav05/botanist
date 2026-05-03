class_name FlowerItem extends InvItem

@export var pointValue: int

func can_be_used(player: CharacterBody2D) -> bool:
	return false
