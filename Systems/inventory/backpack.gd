class_name BackpackInventory
extends ItemGrid


func _save_inventory():
	PlayerData.inventory = {}
	for item: InventoryItem in inventory.get_tree().get_nodes_in_group(&"Item"):
		if !item.placed:
			continue
		
		PlayerData.inventory.set(item.tile_position, item.data)


func _load_inventory():
	for item_pos in PlayerData.inventory.keys():
		var item_data = PlayerData.inventory[item_pos]
		var item = item_data.build()
		get_parent().add_child(item)
		for item_tile_pos in item.tiles():
			taken_tiles.set(item_tile_pos + item_pos, null)
			item.place(item_pos, self)
