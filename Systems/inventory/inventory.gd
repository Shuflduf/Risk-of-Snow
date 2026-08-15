class_name Inventory
extends Resource

@export var id: StringName
@export var size: Vector2i

var items: Dictionary[Vector2i, ItemData] = {}

func can_place(item: InventoryItem, desired_position: Vector2i) -> bool:
	for item_tile_pos in item.tiles():
		var tile_pos = item_tile_pos + desired_position
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
