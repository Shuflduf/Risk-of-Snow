class_name Backpack
extends Node3D

@export var inventory: Inventory
@export var temp_item: ItemData
@export var item_pickup_handler: ItemPickupHandler

func _ready() -> void:
	if PlayerData.inventory:
		inventory = PlayerData.inventory
	else:
		inventory.items.set(Vector2i(0, 2), temp_item)

func _exit_tree() -> void:
	PlayerData.inventory = inventory

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"inventory"):
		if InventoryManager.none_shown():
			InventoryManager.show_held()
			InventoryManager.open(inventory)
			InventoryManager.dropped_items(item_pickup_handler.get_items())
		else:
			InventoryManager.close_all()
	elif event.is_action_pressed(&"debug"):
		inventory.items.set(Vector2i(0, 2), temp_item)
