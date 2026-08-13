class_name Backpack
extends Control

const TILE_SIZE = 60.0

var hovered_tiles: Array[Panel] = []
var taken_tiles: Dictionary[Vector2i, Variant] = {}

@onready var background: GridContainer = $Background

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"backpack"):
		visible = !visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
	for tile: Panel in background.get_children():
		tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
	
	_load_inventory()


func _save_inventory():
	PlayerData.inventory = {}
	for item: BackpackItem in get_tree().get_nodes_in_group(&"Item"):
		if !item.placed:
			continue
		
		PlayerData.inventory.set(item.tile_position, item.data)


func _load_inventory():
	for item_pos in PlayerData.inventory.keys():
		var item_data = PlayerData.inventory[item_pos]
		var item = item_data.build()
		add_child(item)
		for item_tile_pos in item.tiles():
			taken_tiles.set(item_tile_pos + item_pos, null)
			item.place(item_pos)



func hovering_over(item: BackpackItem, mouse: Vector2):
	reset_tiles()
	var desired_position: Vector2i = get_item_pos(mouse)
	var success = false
	var current_y = 0

	while can_place_item(item, Vector2i(desired_position.x, current_y)):
		success = true
		current_y += 1

	if !success or !can_place_item(item, desired_position):
		return

	for item_tile_pos in item.tiles():
		var tile_pos = item_tile_pos + Vector2i(desired_position.x, current_y - 1)
		var tile = tile_at(tile_pos)
		tile.modulate = Color.RED
		hovered_tiles.push_back(tile)


func tile_at(pos: Vector2i) -> Panel:  # Panel | null
	if (
		pos.x < 0
		or pos.x >= background.columns
		or pos.y < 0
		or pos.y >= float(background.get_child_count()) / background.columns
	):
		return null

	var idx = pos.y * background.columns + pos.x
	return background.get_child(idx)


func attempt_place(item: BackpackItem):
	var desired_pos: Vector2i = get_item_pos(get_global_mouse_position())
	var item_pos = valid_item_position(item, desired_pos)
	if item_pos == null or !can_place_item(item, desired_pos):
		return

	for item_tile_pos in item.tiles():
		taken_tiles.set(item_tile_pos + item_pos, null)
	item.place(item_pos)
	_save_inventory()


func valid_item_position(item: BackpackItem, target_position: Vector2i) -> Variant:  # Vector2i | null
	var success = false
	var current_y = 0
	
	
	while can_place_item(item, Vector2i(target_position.x, current_y)):
		success = true
		current_y += 1
	prints(success, current_y)
	if !success:
		return null
	
	return Vector2i(target_position.x, current_y - 1)


func can_place_item(item: BackpackItem, test_position: Vector2i) -> bool:
	for item_tile_pos in item.tiles():
		var tile_pos = item_tile_pos + test_position
		var tile = tile_at(tile_pos)
		if !tile or taken_tiles.has(tile_pos):
			return false
	return true


func start_drag_item(item: BackpackItem) -> bool:
	var temp_taken_tiles = taken_tiles.duplicate()
	for item_tile_pos in item.tiles():
		var tile_pos = item_tile_pos + item.tile_position
		taken_tiles.erase(tile_pos)

	for item_tile_pos in item.tiles():
		var current_offset = 0
		while item_tile_pos.y + item.tile_position.y - current_offset >= 0:
			var tile_pos = item_tile_pos + item.tile_position - Vector2i(0, current_offset)
			if !taken_tiles.has(tile_pos):
				current_offset += 1
			else:
				taken_tiles = temp_taken_tiles
				return false

	return true


func reset_tiles():
	for tile in hovered_tiles:
		tile.modulate = Color.WHITE
	hovered_tiles = []


func get_item_pos(mouse: Vector2) -> Vector2i:
	var offset_absolute: Vector2 = offset()
	var item_pos: Vector2i = Vector2i(
		floor((mouse.x - offset_absolute.x) / TILE_SIZE),
		floor((mouse.y - offset_absolute.y) / TILE_SIZE)
	)
	return item_pos


func offset() -> Vector2:
	return background.get_child(0).global_position
