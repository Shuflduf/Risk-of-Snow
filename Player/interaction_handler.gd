class_name InteractionHandler
extends Node3D

@export var ui: UI
@export var backpack: Node3D
@onready var raycast: RayCast3D = %RayCast3D

var disabled = false:
	get():
		return PlayerData.equipped_item != null

func _physics_process(_delta: float) -> void:
	if disabled:
		return 
	var interactable: Interactable = raycast.get_collider()
	if interactable != null and interactable is Interactable:
		ui.set_display_name_text(interactable.display_name)
		ui.set_primary_action_text(interactable.primary_action)
		ui.set_secondary_action_text(interactable.secondary_action)
	else:
		ui.set_display_name_text("")
		ui.set_primary_action_text("")
		ui.set_secondary_action_text("")


func _unhandled_key_input(event: InputEvent) -> void:
	if disabled:
		return 
	if event.is_action_pressed(&"primary_interact"):
		var interactable: Interactable = raycast.get_collider()
		if interactable != null and interactable is Interactable:
			interactable.primary_action_used.emit(self)
	elif event.is_action_pressed(&"secondary_interact"):
		var interactable: Interactable = raycast.get_collider()
		if interactable != null and interactable is Interactable:
			interactable.secondary_action_used.emit(self)


func open_other_inventory(inventory: Inventory):
	InventoryManager.close_all()
	InventoryManager.show_held()
	InventoryManager.open(backpack.inventory)
	InventoryManager.open(inventory)
	InventoryManager.show_dropped_items(backpack.item_pickup_handler.get_items())
