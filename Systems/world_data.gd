extends Node

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		int, <-- ResourceUID.create_id()
# 		PlacedInteractableData
#	]
# ]
var placed_interactables: Dictionary[String, Dictionary]

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		StringName, <-- storage.id
# 		Inventory
#	]
# ]
var inventories: Dictionary[String, Dictionary] = {}
var current_area: Node3D

func _ready() -> void:
	TransitionHandler.transition_ended.connect(_on_transition_ended)
	
func _on_transition_ended():
	if not placed_interactables.has(current_area.scene_file_path):
		placed_interactables.set(current_area.scene_file_path, {})
	
	for id: int in placed_interactables[current_area.scene_file_path]:
		var interactable: PlacedInteractableData = placed_interactables[current_area.scene_file_path][id]
		var new_int: Interactable = interactable.scene.instantiate()
		new_int.inventory = interactable.data[&"inventory"]
		new_int.position = interactable.position
		new_int.rotation = interactable.rotation
		new_int.id = id
		current_area.add_child(new_int)
		
