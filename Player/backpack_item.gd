class_name BackpackItem
extends TextureRect

var being_dragged = false

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
	being_dragged = true

func end_drag():
	being_dragged = false
	backpack.attempt_place(self)

func continue_drag():
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos + (tiles[0] * -backpack.TILE_SIZE) - Vector2(backpack.TILE_SIZE, backpack.TILE_SIZE) / 2.0
	backpack.hovering_over(mouse_pos, tiles)
