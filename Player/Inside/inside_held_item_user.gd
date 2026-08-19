extends Node3D

@export var ui: UI
@export var raycast: RayCast3D

@onready var spring_arm: SpringArm3D = $SpringArm3D

var ghost: Node3D

func _ready() -> void:
	PlayerData.equipped_item_changed.connect(_on_equipped_item_changed)
	
func _on_equipped_item_changed(new_item: ItemData):
	if new_item == null or new_item.use_type == ItemData.InsideOrOutside.OUTSIDE:
		if ghost:
			ghost.queue_free()
		return
	print(new_item.primary_action)
	ui.set_display_name_text(new_item.display_name)
	ui.set_primary_action_text(new_item.primary_action)
	ui.set_secondary_action_text(new_item.secondary_action)
	ghost = new_item.make_ghost()
	ghost.rotation.y = PI
	spring_arm.add_child(ghost)
	
func _physics_process(delta: float) -> void:
	spring_arm.rotation.x = raycast.global_rotation.x + PI
	spring_arm.rotation.z = PI
	
