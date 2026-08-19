extends Interactable

@export var inventory: Inventory

var is_open = false
@onready var anim: AnimationPlayer = $chest/AnimationPlayer


func _ready() -> void:
	await get_tree().physics_frame
	var existing_inventories = WorldData.inventories.get(WorldData.current_area.scene_file_path)
	if existing_inventories:
		var inv = existing_inventories.get(inventory.id)
		if inv:
			inventory = inv

	inventory.closed.connect(close)
	primary_action_used.connect(open)
	secondary_action_used.connect(pickup)


func _exit_tree() -> void:
	var existing_inventories: Dictionary[StringName, Inventory] = WorldData.inventories.get_or_add(
		WorldData.current_area.scene_file_path, {} as Dictionary[StringName, Inventory]
	)
	existing_inventories.set(inventory.id, inventory)


func placed_data() -> PlacedInteractableData:
	var placed_interactable_data = PlacedInteractableData.new()
	placed_interactable_data.scene = load(scene_file_path)
	placed_interactable_data.data.set(&"inventory", inventory)
	placed_interactable_data.position = position
	placed_interactable_data.rotation = rotation

	return placed_interactable_data


func open(caller: InteractionHandler):
	if is_open:
		return

	await get_tree().physics_frame
	is_open = true
	anim.queue(&"Open")

	caller.open_other_inventory(inventory)


func close():
	is_open = false

	anim.queue(&"Close")


func pickup(_caller: InteractionHandler):
	if is_open:
		InventoryManager.close_all()
	WorldData.placed_interactables[WorldData.current_area.scene_file_path].erase(id)
	PlayerData.equipped_item = load("res://Items/chest_item.tres")
	queue_free()
