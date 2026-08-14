class_name InventoryManager
extends Control

@onready var other: Control = $Other

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
	visible = true
	
	var new_background = def.build()
	other.visible = true
	other.add_child(new_background)
