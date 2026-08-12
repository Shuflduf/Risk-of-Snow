extends Node3D

@onready var raycast: RayCast3D = %RayCast3D

func _physics_process(_delta: float) -> void:
	var interactable: Interactable = raycast.get_collider()
	if interactable != null and interactable is Interactable:
		print(interactable.primary_action)
		#interactable.primary_action_used.emit()
