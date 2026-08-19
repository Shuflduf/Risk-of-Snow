extends EquippedItem

signal used_up

@export var chest_prop: PackedScene

@onready var model: Node3D = $SpringArm3D/chest

func primary_action():
	var new_chest = chest_prop.instantiate()
	var new_inv = Inventory.new()
	new_inv.size = Vector2i(4, 6)
	new_chest.inventory = new_inv
	WorldData.current_area.add_child(new_chest)
	
	new_chest.global_transform = model.global_transform
	print("CHETS")

func _physics_process(delta: float) -> void:
	model.global_rotation.x = 0.0
