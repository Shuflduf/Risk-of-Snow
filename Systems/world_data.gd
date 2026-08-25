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

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		int, <-- ResourceUID.create_id()
# 		EntityData
#	]
# ]
var entities: Dictionary[String, Dictionary]
var current_area: Node3D


func _ready() -> void:
	TransitionHandler.transition_ended.connect(_on_transition_ended)
	TransitionHandler.transition_started.connect(_on_transition_started)


func _on_transition_ended() -> void:
	_handle_interactables()
	_place_entities()

func _on_transition_started() -> void:
	_store_entities()

func _handle_interactables() -> void:
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


func _store_entities() -> void:
	if not entities.has(current_area.scene_file_path):
		entities.set(current_area.scene_file_path, {})
	_transition_preplaced_entities()


func _place_entities() -> void:
	if not entities.has(current_area.scene_file_path):
		return
	_remove_preplaced_entities()
	for id: int in entities[current_area.scene_file_path]:
		var data: EntityData = entities[
			current_area.scene_file_path
		][id]
		var new_enemy: CharacterBody3D = data.scene.instantiate()
		for key: StringName in data.data.keys():
			new_enemy.set(key, data.data[key])
		print(data.position)
		new_enemy.position = data.position
		new_enemy.rotation = data.rotation
		new_enemy.id = id
		current_area.add_child(new_enemy)

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


func _remove_preplaced_entities() -> void:
	for entity: CharacterBody3D in current_area.get_tree().get_nodes_in_group(
		&"Entity"
	):
		entity.queue_free()


func _transition_preplaced_entities() -> void:
	for entity: CharacterBody3D in current_area.get_tree().get_nodes_in_group(
		&"Entity"
	):
		entities[current_area.scene_file_path][entity.id] = (
			entity.entity_data()
		)
