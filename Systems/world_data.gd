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


func _on_transition_ended() -> void:
	if placed_interactables.has(current_area.scene_file_path):
		_remove_preplaced_interactables()
	else:
		placed_interactables.set(current_area.scene_file_path, {})
		_transition_preplaced_interactables()
		return

	for id: int in placed_interactables[current_area.scene_file_path]:
		var interactable: PlacedInteractableData = placed_interactables[
			current_area.scene_file_path
		][id]
		var new_int: Interactable = interactable.scene.instantiate()
		for key: StringName in interactable.data.keys():
			new_int.set(key, interactable.data[key])
		new_int.position = interactable.position
		new_int.rotation = interactable.rotation
		new_int.id = id
		current_area.add_child(new_int)


func _remove_preplaced_interactables() -> void:
	for interactable: Interactable in current_area.get_tree().get_nodes_in_group(
		&"PlaceableInteractable"
	):
		interactable.queue_free()


func _transition_preplaced_interactables() -> void:
	for interactable: Interactable in current_area.get_tree().get_nodes_in_group(
		&"PlaceableInteractable"
	):
		placed_interactables[current_area.scene_file_path][interactable.id] = (
			interactable.placed_data()
		)
