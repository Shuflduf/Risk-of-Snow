class_name InventoryManager
extends Control

@onready var other: Control = $Other
@onready var backpack: ItemGrid = $Backpack


func _ready() -> void:
	var new_def: ItemData = ItemData.new()
	new_def.tiles = [Vector2i(0, 0), Vector2i(0, 1)]
	var temp_item = new_def.build()
	add_child(temp_item)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"inventory"):
		(close if visible else open).call()


func close():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	other.visible = false
	for child in other.get_children():
		child.queue_free()


func open():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func open_other(def: InventoryDefinition, items: Dictionary[Vector2i, ItemData]):
	if not visible:
		open()
	
	if not other.visible:
		var new_background = def.build()
		other.visible = true
		other.add_child(new_background)


func hovering(item: InventoryItem, mouse_pos: Vector2):
	backpack.hovering_over(item, mouse_pos)


func attempt_place(item: InventoryItem):
	backpack.attempt_place(item)


func reset_hovered_tiles():
	backpack.reset_hovered_tiles()
