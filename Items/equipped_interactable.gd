extends EquippedItem

@export var interactable: PackedScene

@onready var model: Node3D = %Model


func _ready() -> void:
	hide()
	await get_tree().physics_frame
	await get_tree().physics_frame
	show()


func primary_action() -> void:
	var new_interactable: Interactable = interactable.instantiate()
	WorldData.current_area.add_child(new_interactable)
	new_interactable.global_transform = model.global_transform


	used_up.emit()


func _physics_process(_delta: float) -> void:
	model.global_rotation.x = 0.0
