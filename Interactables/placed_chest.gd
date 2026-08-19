extends Interactable

@export var inventory: Inventory

var is_open: bool = false
@onready var anim: AnimationPlayer = $chest/AnimationPlayer


func _ready() -> void:
	await get_tree().physics_frame
	var existing_inventories: Variant = WorldData.inventories.get(WorldData.current_area.scene_file_path)
	if existing_inventories:
		var inv: Inventory = existing_inventories.get(inventory.id)
		if inv:
			inventory = inv

	inventory.closed.connect(close)
	primary_action_used.connect(open)
	secondary_action_used.connect(pickup)


func _exit_tree() -> void:
	var existing_inventories: Dictionary[int, Inventory] = WorldData.inventories.get_or_add(
		WorldData.current_area.scene_file_path, {} as Dictionary[int, Inventory]
	)
	existing_inventories.set(inventory.id, inventory)


func placed_data() -> PlacedInteractableData:
	var placed_interactable_data: PlacedInteractableData = PlacedInteractableData.new()
	placed_interactable_data.scene = load(scene_file_path)
	placed_interactable_data.data.set(&"inventory", inventory)
	placed_interactable_data.position = position
	placed_interactable_data.rotation = rotation

	return placed_interactable_data


func open(caller: InteractionHandler) -> void:
	if is_open:
		return

	await get_tree().physics_frame
	is_open = true
	anim.queue(&"Open")
	caller.open_other_inventory(inventory)


func close() -> void:
	is_open = false

	anim.queue(&"Close")


func pickup(_caller: InteractionHandler) -> void:
	if is_open:
		InventoryManager.close_all()
	
	for data: ItemData in inventory.items.values():
		var drop: DroppedItem = data.build_dropped()
		drop.position = position
		WorldData.current_area.add_child(drop)
		drop.apply_impulse(Vector3(1.0, 3.0, 0.0).rotated(Vector3.UP, randf_range(0, PI * 2.0)))
		drop.apply_torque_impulse(Vector3.UP * 0.1)
		
	WorldData.placed_interactables[WorldData.current_area.scene_file_path].erase(id)
	PlayerData.equipped_item = load("res://Items/chest_item.tres")
	queue_free()
