class_name BackpackItem
extends TextureRect

var being_dragged = false
var placed = false
var tile_position: Vector2i

@onready var backpack: Backpack = get_parent()
@export var tiles: Array[Vector2i] = []

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			start_drag()
		else:
			end_drag()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and being_dragged:
		continue_drag()

func start_drag():
	if placed:
		var can_move = backpack.start_drag_item(self)
		if !can_move:
			return
	get_parent().move_child(self, -1)
	placed = false
	being_dragged = true
	continue_drag()

func end_drag():
	if !being_dragged:
		return
	being_dragged = false
	backpack.attempt_place(self)
	backpack.reset_tiles()

func continue_drag():
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos + (tiles[0] * -backpack.TILE_SIZE) - Vector2(backpack.TILE_SIZE, backpack.TILE_SIZE) / 2.0
	backpack.hovering_over(self, mouse_pos)

func place(item_pos: Vector2i):
	placed = true
	tile_position = item_pos
	position = backpack.offset() + Vector2(item_pos) * Vector2(backpack.TILE_SIZE, backpack.TILE_SIZE)
