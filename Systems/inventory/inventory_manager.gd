extends Control

const TILE_SIZE = 60

func open(inventory: Inventory):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var root = Control.new()
	root.custom_minimum_size = inventory.size * TILE_SIZE
	for x in inventory.size.x:
		for y in inventory.size.y:
			var tile = Panel.new()
			tile.size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.position.x = x * TILE_SIZE
			tile.position.y = y * TILE_SIZE
			root.add_child(tile)
	
	for pos in inventory.items:
		var item_data: ItemData = inventory.items[pos]
		var item = item_data.build()
		item.position = pos * TILE_SIZE
		item.picked_up.connect(item_picked_up.bind(item))
		item.moved.connect(item_moved.bind(item))
		item.dropped.connect(item_dropped.bind(item))
		root.add_child(item)
	
	add_child(root)


func none_shown() -> bool:
	return get_child_count() == 0


func close_all() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for child in get_children():
		child.queue_free()


func item_picked_up(item: InventoryItem) -> void:
	item.top_level = true
	item.reparent(self)
	move_child(item, 0)


func item_moved(mouse_pos: Vector2, item: InventoryItem) -> void:
	item.position = mouse_pos - Vector2(TILE_SIZE, TILE_SIZE) / 2.0
	
func item_dropped(mouse_pos: Vector2, item: InventoryItem) -> void:
	#item.position = mouse_pos
	pass
	
