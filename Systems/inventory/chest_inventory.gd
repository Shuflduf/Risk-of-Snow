class_name ChestInventory
extends ItemGrid

signal inventory_saved(items: Dictionary[Vector2i, ItemData])

func _save_inventory():
	var items: Dictionary[Vector2i, ItemData] = {}
	for item: InventoryItem in inventory.get_tree().get_nodes_in_group(&"Item"):
		if !item.placed or item.current_grid != self:
			continue
		
		items.set(item.tile_position, item.data)
	
	inventory_saved.emit(items)
	
func _load_inventory():
	return
