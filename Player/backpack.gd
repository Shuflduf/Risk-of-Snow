extends Node3D

@export var inventory: Inventory
@export var temp_item: ItemData

func _ready() -> void:
	inventory.items.set(Vector2i(0, 2), temp_item)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"inventory"):
		if InventoryManager.none_shown():
			InventoryManager.open(inventory)
		else:
			InventoryManager.close_all()
