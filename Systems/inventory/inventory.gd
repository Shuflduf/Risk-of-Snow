class_name Inventory
extends Resource

@export var id: StringName
@export var size: Vector2i

var items: Dictionary[Vector2i, ItemData] = {}

# Vector2i | null
func get_valid_position(item: InventoryItem, desired_position: Vector2i) -> Variant: 
	if not can_place_item_at_pos(item.data, desired_position):
		return null
	var current_y = 0
	var can_be_placed = false
	
	while can_place_item_at_pos(item.data, Vector2i(desired_position.x, current_y)):
		can_be_placed = true
		current_y += 1
	
	if not can_be_placed:
		return null
	
	return Vector2i(desired_position.x, current_y - 1)


func can_place_item_at_pos(item: ItemData, pos: Vector2i) -> bool:
	for item_tile_pos in item.tiles:
		var tile_pos = item_tile_pos + pos
		if !is_valid_position(tile_pos) or taken_tiles().has(tile_pos):
			return false
	
	return true


func is_valid_position(tile_pos: Vector2i) -> bool:
	return (
		tile_pos.x >= 0 
		and tile_pos.x < size.x
		and tile_pos.y >= 0
		and tile_pos.y < size.y
	)
	

func taken_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for pos in items:
		var item = items[pos]
		tiles.append_array(item.tiles)
	
	return tiles
