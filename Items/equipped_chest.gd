extends EquippedItem


@export var chest_prop: PackedScene

@onready var model: Node3D = $SpringArm3D/chest

func primary_action():
	var new_chest: Interactable = chest_prop.instantiate()
	var new_inv = Inventory.new()
	new_inv.id = StringName(str(ResourceUID.create_id()))
	new_inv.size = Vector2i(4, 6)
	new_chest.inventory = new_inv
	WorldData.current_area.add_child(new_chest)
	new_chest.global_transform = model.global_transform
	
	var placed_interactable_data = new_chest.placed_data()
	WorldData.placed_interactables[WorldData.current_area.scene_file_path].set(new_chest.id, placed_interactable_data)
	
	used_up.emit()

func _physics_process(_delta: float) -> void:
	model.global_rotation.x = 0.0
