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

func hovering_over(mouse: Vector2, item_tiles: Array[Vector2i]):
	reset_tiles()
	var item_pos: Vector2i = get_item_pos(mouse)
	for item_tile_pos in item_tiles:
		var tile_pos = item_tile_pos + item_pos
		var tile = tile_at(tile_pos)
		if tile and not taken_tiles.has(tile_pos):
			tile.modulate = Color.RED
			hovered_tiles.push_back(tile)
		else:
			reset_tiles()
			break

func get_item_pos(mouse: Vector2) -> Vector2i:
	var offset_absolute: Vector2 = offset()
	var item_pos: Vector2i = Vector2i(
		floor((mouse.x - offset_absolute.x) / TILE_SIZE),
		floor((mouse.y - offset_absolute.y) / TILE_SIZE)
	)
	return item_pos


func tile_at(pos: Vector2i) -> Panel:
	if (
		pos.x < 0
		or pos.x >= background.columns 
		or pos.y < 0 
		or pos.y >= float(background.get_child_count()) / background.columns
	):
		return null

	var idx = pos.y * background.columns + pos.x
	return background.get_child(idx)

func reset_tiles():
	for tile in hovered_tiles:
		tile.modulate = Color.WHITE
	hovered_tiles = []

func attempt_place(item: BackpackItem):
	var item_pos: Vector2i = get_item_pos(get_global_mouse_position())
	for item_tile_pos in item.tiles:
		var tile_pos = item_tile_pos + item_pos
		var tile = tile_at(tile_pos)
		if !tile or taken_tiles.has(tile_pos):
			return
	
	for item_tile_pos in item.tiles:
		taken_tiles.set(item_tile_pos  + item_pos, null)
	item.place(item_pos)
	print(taken_tiles)

func offset() -> Vector2:
	return background.get_child(0).global_position
	
func start_drag_item(item: BackpackItem):
	for item_tile_pos in item.tiles:
		var tile_pos = item_tile_pos + item.tile_position
		taken_tiles.erase(tile_pos)
	print(taken_tiles)
