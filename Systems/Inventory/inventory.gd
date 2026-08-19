class_name Inventory
extends Resource

@warning_ignore("unused_signal")
signal closed

@export var size: Vector2i

var id: int = ResourceUID.create_id()
var items: Dictionary[Vector2i, ItemData] = {}


# Vector2i | null
func get_valid_position(item: InventoryItem, desired_position: Vector2i) -> Variant:
	if not can_place_item_at_pos(item.data, desired_position):
		return null
	var current_y: int = 0
	var can_be_placed: bool = false

	while can_place_item_at_pos(item.data, Vector2i(desired_position.x, current_y)):
		can_be_placed = true
		current_y += 1

	if not can_be_placed:
		return null

	return Vector2i(desired_position.x, current_y - 1)


func can_place_item_at_pos(item: ItemData, pos: Vector2i) -> bool:
	for item_tile_pos: Vector2i in item.tiles:
		var tile_pos: Vector2i = item_tile_pos + pos
		if !is_valid_position(tile_pos) or taken_tiles().has(tile_pos):
			return false

	return true


func can_pickup_item(item: InventoryItem) -> bool:
	var actual_items: Dictionary[Vector2i, ItemData] = items.duplicate()
	var item_pos: Vector2i = item.tile_position()
	items.erase(item_pos)
	for tile: Vector2i in item.data.tiles:
		var current_y: int = item_pos.y + tile.y
		while current_y >= 0:
			if Vector2i(tile.x + item_pos.x, current_y) in taken_tiles():
				items = actual_items
				return false

			current_y -= 1
			continue

	items = actual_items
	return true
	#for tile in item.data.tiles


func is_valid_position(tile_pos: Vector2i) -> bool:
	return tile_pos.x >= 0 and tile_pos.x < size.x and tile_pos.y >= 0 and tile_pos.y < size.y


func taken_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for pos: Vector2i in items.keys():
		var item: ItemData = items[pos]
		for tile: Vector2i in item.tiles:
			tiles.append(tile + pos)

	return tiles
