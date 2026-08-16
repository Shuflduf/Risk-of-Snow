extends Interactable

@export var inventory: Inventory

@onready var scene_path = owner.scene_file_path


func _ready() -> void:
	var existing_inventories = WorldData.inventories.get(scene_path)
	if existing_inventories:
		var inv = existing_inventories.get(inventory.id)
		if inv:
			inventory = inv

	primary_action_used.connect(open)


func open(caller: InteractionHandler):
	caller.open_other_inventory(inventory)


func _exit_tree() -> void:
	var existing_inventories: Dictionary[StringName, Inventory] = WorldData.inventories.get_or_add(
		scene_path, {} as Dictionary[StringName, Inventory]
	)
	existing_inventories.set(inventory.id, inventory)
