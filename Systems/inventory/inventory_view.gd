class_name InventoryView
extends Control

const TILE_SIZE = 60

var inventory: Inventory

static func build(inv: Inventory, per_item: Callable) -> InventoryView:
	var new_self = InventoryView.new()
	new_self.inventory = inv
	
	new_self.custom_minimum_size = inv.size * TILE_SIZE
	for y in inv.size.y:
		for x in inv.size.x:
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


func attempt_hover(item: InventoryItem, mouse_pos: Vector2) -> void:
	reset_hovered()
	
	var tile_pos = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos = inventory.get_valid_position(item, tile_pos)
	if item_pos:
		for tile in item.data.tiles:
			print(tile + item_pos)
			panel_at(tile + item_pos).modulate = Color.RED



func attempt_place(item: InventoryItem, mouse_pos: Vector2) -> void:
	reset_hovered()
	
	var tile_pos = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos = inventory.get_valid_position(item, tile_pos)
	if item_pos:
		item.top_level = false
		item.reparent(self)
		item.position = item_pos * TILE_SIZE
		inventory.items.set(item_pos, item.data)
		
	prints(tile_pos, item_pos)


func reset_hovered():
	var panels = get_children().filter(func(child: Node): return child is Panel)
	for panel in panels:
		panel.modulate = Color.WHITE


# Panel | null
func panel_at(pos: Vector2i) -> Panel:
	if not inventory.is_valid_position(pos):
		return null
	
	var panels = get_children().filter(func(child: Node): return child is Panel)
	var idx = pos.x + pos.y * inventory.size.x
	return panels[idx]
	
	
	
	
