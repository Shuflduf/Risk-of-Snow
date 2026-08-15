class_name InventoryView
extends Control

const TILE_SIZE = 60

var inventory: Inventory

static func build(inv: Inventory, per_item: Callable) -> InventoryView:
	var new_self = InventoryView.new()
	new_self.inventory = inv
	
	new_self.custom_minimum_size = inv.size * TILE_SIZE
	for x in inv.size.x:
		for y in inv.size.y:
			var tile = Panel.new()
			tile.size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.position.x = x * TILE_SIZE
			tile.position.y = y * TILE_SIZE
			new_self.add_child(tile)
	
	for pos in inv.items:
		var item_data: ItemData = inv.items[pos]
		var item = item_data.build()
		item.position = pos * TILE_SIZE
		per_item.call(item)
		new_self.add_child(item)
		
	return new_self


func attempt_place(item: InventoryItem, mouse_pos: Vector2) -> void:
	var tile_pos = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos = inventory.get_valid_position(item, tile_pos)
	if item_pos:
		item.top_level = false
		item.reparent(self)
		item.position = item_pos * TILE_SIZE
		
	prints(tile_pos, item_pos)
