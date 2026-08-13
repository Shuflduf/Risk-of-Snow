class_name Backpack
extends Control

const TILE_SIZE = 60.0

var hovered_tiles: Array[Panel] = []


@onready var background: GridContainer = $Background


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"backpack"):
		visible = !visible

func _ready() -> void:
	for tile: Panel in background.get_children():
		tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)

func hovering_over(pos: Vector2, item_tiles: Array[Vector2i]):
	reset_tiles()
	var offset_absolute: Vector2 = background.get_child(0).global_position	
	var tile_pos: Vector2i = Vector2i(
		floor((pos.x - offset_absolute.x) / TILE_SIZE),
		floor((pos.y - offset_absolute.y) / TILE_SIZE)
	)
	var tile = tile_at(tile_pos)
	if tile:
		tile.modulate = Color.RED
		hovered_tiles.push_back(tile)


func tile_at(pos: Vector2i) -> Panel:
	print(pos)
	if pos.x < 0 or pos.x >= background.columns or pos.y < 0 or pos.y >= background.get_child_count() / background.columns:
		return null
	var idx = pos.y * background.columns + pos.x
	
	return background.get_child(idx)

func reset_tiles():
	for tile in hovered_tiles:
		tile.modulate = Color.WHITE
