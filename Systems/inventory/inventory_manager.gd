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
	
	add_child(root)


func none_shown() -> bool:
	return get_child_count() == 0


func close_all() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for child in get_children():
		child.queue_free()
