extends InventoryView


func _ready() -> void:
	if not PlayerData.equipped_item:
		return

	build_background(PlayerData.equipped_item)
	var item: InventoryItem = PlayerData.equipped_item.build()
	item.set_placed()
	item.position = Vector2.ZERO
	item.picked_up.connect(item_picked_up.bind(item))
	item.moved.connect(get_parent().item_moved.bind(item))
	item.dropped.connect(get_parent().item_dropped.bind(item))

	add_child(item)


func attempt_hover(_item: InventoryItem, mouse_pos: Vector2) -> void:
	var tile_pos: Vector2i = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	if tile_pos == Vector2i(0, 0):
		modulate = Color.RED
	else:
		modulate = Color.WHITE


func attempt_place(item: InventoryItem, mouse_pos: Vector2) -> bool:
	var tile_pos: Vector2i = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	if tile_pos == Vector2i(0, 0):
		modulate = Color.WHITE
		PlayerData.equipped_item = item.data
		build_background(item.data)
		item.reparent(self)
		item.set_placed()
		item.position = Vector2.ZERO

		var old_signal: Callable
		for conn: Dictionary in item.picked_up.get_connections():
			old_signal = conn["callable"]
			item.picked_up.disconnect(old_signal)
		item.picked_up.connect(item_picked_up.bind(item))
		return true
	return false


func item_picked_up(item: InventoryItem) -> void:
	PlayerData.equipped_item = null
	build_background()
	item.reparent(get_parent())
	item.set_not_placed()
	for conn: Dictionary in item.picked_up.get_connections():
		item.picked_up.disconnect(conn["callable"])

	item.picked_up.connect(get_parent().item_picked_up.bind(item))


func build_background(data: ItemData = null) -> void:
	for panel in get_children():
		if panel is not Panel:
			continue

		panel.queue_free()

	if data == null:
		custom_minimum_size = Vector2.ONE * TILE_SIZE
		var panel: Panel = Panel.new()
		panel.size = Vector2(TILE_SIZE, TILE_SIZE)
		panel.position = Vector2.ZERO
		add_child(panel)
		return

	custom_minimum_size = data.bounds() * TILE_SIZE
	for tile in data.tiles:
		var panel: Panel = Panel.new()
		panel.size = Vector2(TILE_SIZE, TILE_SIZE)
		panel.position.x = tile.x * TILE_SIZE
		panel.position.y = tile.y * TILE_SIZE
		add_child(panel)

	#reset_hovered()
	#
	#var tile_pos = Vector2i(floor((mouse_pos - global_position) / TILE_SIZE))
	#var item_pos = inventory.get_valid_position(item, tile_pos)
	#if inventory.is_valid_position(tile_pos):
	#item.top_level = false
	#item.reparent(self)
	#item.z_index = 2
	#item.position = item_pos * TILE_SIZE
	#inventory.items.set(item_pos, item.data)
