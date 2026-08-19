extends Interactable

@export var inventory: Inventory

@onready var anim: AnimationPlayer = $chest/AnimationPlayer

var is_open = false

func _ready() -> void:
	await get_tree().physics_frame
	var existing_inventories = WorldData.inventories.get(WorldData.current_area.scene_file_path)
	if existing_inventories:
		var inv = existing_inventories.get(inventory.id)
		if inv:
			inventory = inv
	
	inventory.closed.connect(close)
	primary_action_used.connect(open)


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
	

func _exit_tree() -> void:
	var existing_inventories: Dictionary[StringName, Inventory] = WorldData.inventories.get_or_add(
		WorldData.current_area.scene_file_path, {} as Dictionary[StringName, Inventory]
	)
	existing_inventories.set(inventory.id, inventory)
