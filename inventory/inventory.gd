extends Resource

class_name Inv

signal update
signal use_item

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()
	
func removeSlot(inventorySlot: InvSlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	
	remove_at_index(index)
	
func remove_at_index(index: int):
	slots[index] = InvSlot.new()
	update.emit()

func insertSlot(index: int, inventorySlot: InvSlot):
	slots[index] = inventorySlot
	update.emit()

func use_item_at_index(index: int):
	if index < 0 or index >= slots.size() or !slots[index].item: return
	
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -= 1
		update.emit()
		return
		
	remove_at_index(index)
	
