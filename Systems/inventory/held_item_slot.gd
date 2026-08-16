extends InventoryView

func attempt_place(item: InventoryItem, mouse_pos: Vector2) -> void:
	reset_hovered()
	
	var tile_pos = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos = inventory.get_valid_position(item, tile_pos)
	if inventory.is_valid_position(tile_pos):
		item.top_level = false
		item.reparent(self)
		item.z_index = 2
		item.position = item_pos * TILE_SIZE
		inventory.items.set(item_pos, item.data)
		
