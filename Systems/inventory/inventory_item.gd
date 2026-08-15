class_name InventoryItem
extends Control

signal picked_up
signal moved(mouse_pos: Vector2)
signal dropped(mouse_pos: Vector2)

@export var data: ItemData

var being_dragged = false
#var placed = false

#var current_grid: ItemGrid
##
##@onready var inventory: InventoryManager = get_parent()
#
#func _ready() -> void:
	#add_to_group(&"Item")
#
#
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			being_dragged = true
			picked_up.emit()
			moved.emit(get_global_mouse_position())
		else:
			being_dragged = false
			dropped.emit(get_global_mouse_position())
#
#
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and being_dragged:
		moved.emit(get_global_mouse_position())
#
#
#func start_drag():
	#if placed:
		##var can_move = current_grid.start_drag_item(self)
		#if !can_move:
			#return
	#get_parent().move_child(self, -1)
	#placed = false
	#being_dragged = true
	#continue_drag()
#
#
#func end_drag():
	#if !being_dragged:
		#return
	#being_dragged = false
	#inventory.attempt_place(self)
	#inventory.reset_hovered_tiles()
#
#
#func continue_drag():
	#var mouse_pos = get_global_mouse_position()
	#position = (
		#mouse_pos
		#+ (data.tiles[0] * -ItemGrid.TILE_SIZE)
		#- Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE) / 2.0
	#)
	#inventory.hovering(self, mouse_pos)
#
#
#func place(item_pos: Vector2i, grid: ItemGrid):
	#placed = true
	#tile_position = item_pos
	#current_grid = grid
	#position = (
		#grid.offset() + Vector2(item_pos) * Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE)
	#)
#
#
#func replace():
	#if placed and current_grid != null:
		#prints(tile_position, current_grid)
		#position = (
			#current_grid.offset() + Vector2(tile_position) * Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE)
		#)
		#print(position)
#
#func tiles() -> Array[Vector2i]:
	#return data.tiles
