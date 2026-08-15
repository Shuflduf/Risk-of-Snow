#@abstract class_name ItemGrid
#extends GridContainer
#
#const TILE_SIZE = 60.0
#
#var hovered_tiles: Array[Panel] = []
#var taken_tiles: Dictionary[Vector2i, Variant] = {}
#
#@onready var inventory = get_parent()
#
#@abstract func _save_inventory()
#@abstract func _load_inventory()
#
#func _ready() -> void:
	#for tile: Panel in get_children():
		#tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
	#
	##_load_inventory()
#
#func load_items():
	#_load_inventory()
#
#func hovering_over(item: InventoryItem, mouse: Vector2):
	#reset_hovered_tiles()
	#var desired_position: Vector2i = get_item_pos(mouse)
	#var success = false
	#var current_y = 0
#
	#while can_place_item(item, Vector2i(desired_position.x, current_y)):
		#success = true
		#current_y += 1
#
	#if !success or !can_place_item(item, desired_position):
		#return
#
	#for item_tile_pos in item.tiles():
		#var tile_pos = item_tile_pos + Vector2i(desired_position.x, current_y - 1)
		#var tile = tile_at(tile_pos)
		#tile.modulate = Color.RED
		#hovered_tiles.push_back(tile)
#
#
#func tile_at(pos: Vector2i) -> Panel:  # Panel | null
	#if (
		#pos.x < 0
		#or pos.x >= columns
		#or pos.y < 0
		#or pos.y >= float(get_child_count()) / columns
	#):
		#return null
#
	#var idx = pos.y * columns + pos.x
	#return get_child(idx)
#
#
#func attempt_place(item: InventoryItem):
	#var desired_pos: Vector2i = get_item_pos(get_global_mouse_position())
	#var item_pos = valid_item_position(item, desired_pos)
	#if item_pos == null or !can_place_item(item, desired_pos):
		#return
#
	#for item_tile_pos in item.tiles():
		#taken_tiles.set(item_tile_pos + item_pos, null)
	#item.place(item_pos, self)
	#_save_inventory()
#
#
#func valid_item_position(item: InventoryItem, target_position: Vector2i) -> Variant:  # Vector2i | null
	#var success = false
	#var current_y = 0
	#
	#while can_place_item(item, Vector2i(target_position.x, current_y)):
		#success = true
		#current_y += 1
	#if !success:
		#return null
	#
	#return Vector2i(target_position.x, current_y - 1)
#
#
#
#
#
#func start_drag_item(item: InventoryItem) -> bool:
	#var temp_taken_tiles = taken_tiles.duplicate()
	#for item_tile_pos in item.tiles():
		#var tile_pos = item_tile_pos + item.tile_position
		#taken_tiles.erase(tile_pos)
#
	#for item_tile_pos in item.tiles():
		#var current_offset = 0
		#while item_tile_pos.y + item.tile_position.y - current_offset >= 0:
			#var tile_pos = item_tile_pos + item.tile_position - Vector2i(0, current_offset)
			#if !taken_tiles.has(tile_pos):
				#current_offset += 1
			#else:
				#taken_tiles = temp_taken_tiles
				#return false
#
	#return true
#
#
#func reset_hovered_tiles():
	#for tile in hovered_tiles:
		#tile.modulate = Color.WHITE
	#hovered_tiles = []
#
#
#func get_item_pos(mouse: Vector2) -> Vector2i:
	#var offset_absolute: Vector2 = offset()
	#var item_pos: Vector2i = Vector2i(
		#floor((mouse.x - offset_absolute.x) / TILE_SIZE),
		#floor((mouse.y - offset_absolute.y) / TILE_SIZE)
	#)
	#return item_pos
#
#
#func offset() -> Vector2:
	#return get_child(0).global_position
