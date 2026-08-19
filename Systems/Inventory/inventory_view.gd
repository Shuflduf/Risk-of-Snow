class_name InventoryView
extends Control

signal closed

const TILE_SIZE: int = 64

var inventory: Inventory


func _ready() -> void:
	closed.connect(inventory.closed.emit)


static func build(inv: Inventory, per_item: Callable) -> InventoryView:
	var new_self: InventoryView = InventoryView.new()
	new_self.inventory = inv

	new_self.custom_minimum_size = inv.size * TILE_SIZE
	for y: int in inv.size.y:
		for x: int in inv.size.x:
			var tile: Panel = Panel.new()
			tile.size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.position.x = x * TILE_SIZE
			tile.position.y = y * TILE_SIZE
			new_self.add_child(tile)

	for pos: Vector2i in inv.items.keys():
		var item_data: ItemData = inv.items[pos]
		var item: InventoryItem = item_data.build()
		item.set_placed()
		item.position = pos * TILE_SIZE
		per_item.call(item)
		new_self.add_child(item)

	return new_self


func attempt_hover(item: InventoryItem, mouse_pos: Vector2) -> void:
	reset_hovered()

	var tile_pos: Vector2i = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos: Variant = inventory.get_valid_position(item, tile_pos)
	if item_pos != null:
		for tile: Vector2i in item.data.tiles:
			panel_at(tile + item_pos).modulate = Color.RED


func attempt_place(item: InventoryItem, mouse_pos: Vector2) -> bool:
	reset_hovered()

	var tile_pos: Vector2i = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	var item_pos: Variant = inventory.get_valid_position(item, tile_pos)
	if item_pos != null:
		item.reparent(self)
		item.set_placed()
		item.position = item_pos * TILE_SIZE
		#custom_minimum_size = item.size
		inventory.items.set(item_pos, item.data)
		return true
	return false


func reset_hovered() -> void:
	var panels: Array[Node] = get_children().filter(func(child: Node) -> bool: return child is Panel)
	for panel: Panel in panels:
		panel.modulate = Color.WHITE


# Panel | null
func panel_at(pos: Vector2i) -> Panel:
	if not inventory.is_valid_position(pos):
		return null

	var panels: Array[Node] = get_children().filter(func(child: Node) -> bool: return child is Panel)
	var idx: int = pos.x + pos.y * inventory.size.x
	return panels[idx]
