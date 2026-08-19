extends Node

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Array [
# 		PlacedInteractableData,
#	]
# ]
var placed_interactables: Dictionary[String, Array]

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		StringName, <-- storage.id
# 		Inventory
#	]
# ]
var inventories: Dictionary[String, Dictionary] = {}
var current_area: Node3D
