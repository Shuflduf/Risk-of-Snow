extends Node

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		int, <-- ResourceUID.create_id()
# 		PlacedInteractableData
#	]
# ]
var interactables: Dictionary[String, Dictionary]

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

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		int, <-- ResourceUID.create_id()
# 		DroppedItemData
#	]
# ]
var items: Dictionary[String, Dictionary]
var current_area: Node3D


func _ready() -> void:
	TransitionHandler.transition_started.connect(_on_transition_started)
	TransitionHandler.transition_ended.connect(_on_transition_ended)


func _on_transition_started() -> void:
	_store_interactables()
	_store_entities()
	_store_items()


func _on_transition_ended() -> void:
	_place_interactables()
	_place_entities()
	_place_items()



func _store_interactables() -> void:
	interactables.set(current_area.scene_file_path, {})
	
	for interactable: Interactable in current_area.get_tree().get_nodes_in_group(
		&"PlaceableInteractable"
	):
		interactables[current_area.scene_file_path][interactable.id] = (interactable.placed_data())


func _store_entities() -> void:
	entities.set(current_area.scene_file_path, {})
	
	for entity: CharacterBody3D in current_area.get_tree().get_nodes_in_group(&"Entity"):
		entities[current_area.scene_file_path][entity.id] = (entity.entity_data())


func _store_items() -> void:
	items.set(current_area.scene_file_path, {})
	
	for item: DroppedItem in current_area.get_tree().get_nodes_in_group(&"DroppedItem"):
		items[current_area.scene_file_path][item.id] = (item.drop_data())


func _place_interactables() -> void:
	if not interactables.has(current_area.scene_file_path):
		return
	
	for interactable: Interactable in current_area.get_tree().get_nodes_in_group(
		&"PlaceableInteractable"
	):
		interactable.queue_free()

	for id: int in interactables[current_area.scene_file_path]:
		var interactable: PlacedInteractableData = interactables[current_area.scene_file_path][id]
		var new_int: Interactable = interactable.scene.instantiate()
		for key: StringName in interactable.data.keys():
			new_int.set(key, interactable.data[key])
		new_int.position = interactable.position
		new_int.rotation = interactable.rotation
		new_int.id = id
		current_area.add_child(new_int)


func _place_entities() -> void:
	if not entities.has(current_area.scene_file_path):
		return
	
	for entity: CharacterBody3D in current_area.get_tree().get_nodes_in_group(&"Entity"):
		entity.queue_free()

	for id: int in entities[current_area.scene_file_path]:
		var data: EntityData = entities[current_area.scene_file_path][id]
		var new_enemy: CharacterBody3D = data.scene.instantiate()
		for key: StringName in data.data.keys():
			new_enemy.set(key, data.data[key])
		new_enemy.position = data.position
		new_enemy.rotation = data.rotation
		new_enemy.id = id
		current_area.add_child(new_enemy)


func _place_items() -> void:
	if not items.has(current_area.scene_file_path):
		return
	
	for item: DroppedItem in current_area.get_tree().get_nodes_in_group(&"DroppedItem"):
		item.queue_free()

	for id: int in items[current_area.scene_file_path]:
		var data: DroppedItemData = items[current_area.scene_file_path][id]
		var new_drop: DroppedItem = data.data.build_dropped()
		new_drop.position = data.position
		new_drop.rotation = data.rotation
		new_drop.id = id
		current_area.add_child(new_drop)
