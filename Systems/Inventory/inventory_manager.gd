extends Control

const TILE_SIZE = InventoryView.TILE_SIZE


func open(inventory: Inventory):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var view = InventoryView.build(
		inventory,
		func(item: InventoryItem):
			item.picked_up.connect(item_picked_up.bind(item))
			item.moved.connect(item_moved.bind(item))
			item.dropped.connect(item_dropped.bind(item))
	)

	add_child(view)


func none_shown() -> bool:
	return get_child_count() == 0


func close_all() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for child in get_children():
		child.queue_free()


func show_held() -> void:
	add_child(preload("res://Systems/Inventory/held_item_slot.tscn").instantiate())


func dropped_items(items: Array[DroppedItem]) -> void:
	for drop in items:
		var item = drop.data.build()
		item.top_level = true
		item.position = Vector2.ZERO
		item.picked_up.connect(dropped_item_picked_up.bind(drop, item))
		item.picked_up.connect(item_picked_up.bind(item))
		item.moved.connect(item_moved.bind(item))
		item.dropped.connect(item_dropped.bind(item))
		add_child(item)


func item_picked_up(item: InventoryItem) -> void:
	var view = item.get_parent()
	if view is InventoryView:
		if view.inventory.can_pickup_item(item):
			view.inventory.items.erase(item.tile_position())
		else:
			item.being_dragged = false
			return
	item.top_level = true
	item.reparent(self)
	item.z_index = 10


func item_moved(mouse_pos: Vector2, item: InventoryItem) -> void:
	item.position = mouse_pos - Vector2(TILE_SIZE, TILE_SIZE) / 2.0
	for view in get_children():
		if view is not InventoryView:
			continue

		view.attempt_hover(item, mouse_pos)


func item_dropped(mouse_pos: Vector2, item: InventoryItem) -> void:
	for view in get_children():
		if view is not InventoryView:
			continue

		view.attempt_place(item, mouse_pos)


func dropped_item_picked_up(drop: DroppedItem, item: InventoryItem) -> void:
	if drop == null:
		return
	drop.queue_free()

	for conn in item.picked_up.get_connections():
		item.picked_up.disconnect(conn["callable"])
	item.picked_up.connect(item_picked_up.bind(item))
