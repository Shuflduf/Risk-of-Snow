extends Node3D

@export var inventory: Inventory

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"inventory"):
		if InventoryManager.none_shown():
			InventoryManager.open(inventory)
		else:
			InventoryManager.close_all()
