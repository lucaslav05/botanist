extends Panel

class_name ItemStackGui

@onready var itemSprite: Sprite2D = $item_display
@onready var amount_text: Label = $Label

var inventorySlot: InvSlot

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture
	
	if inventorySlot.amount > 1:
		amount_text.visible = true
		amount_text.text = str(inventorySlot.amount)
	else:
		amount_text.visible = false
