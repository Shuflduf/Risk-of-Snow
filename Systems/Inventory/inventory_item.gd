class_name InventoryItem
extends Control

signal picked_up
signal moved(mouse_pos: Vector2)
signal dropped(mouse_pos: Vector2)

@export var data: ItemData

var being_dragged = false


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		being_dragged = true
		picked_up.emit()
		if being_dragged:
			moved.emit(get_global_mouse_position())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and being_dragged:
		moved.emit(get_global_mouse_position())
	elif (
		event is InputEventMouseButton
		and being_dragged
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_released()
	):
		being_dragged = false
		dropped.emit(get_global_mouse_position())


func tile_position() -> Vector2i:
	return Vector2i(floor(position / InventoryView.TILE_SIZE))


func set_placed() -> void:
	top_level = false
	z_index = 2


func set_not_placed() -> void:
	top_level = true
	z_index = 10
