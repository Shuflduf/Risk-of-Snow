extends Node

# Dictionary [
# 	String, <-- owner.scene_file_path
# 	Dictionary [
# 		StringName, <-- storage.id
# 		Dictionary[Vector2i, ItemDef] <-- items and their positions
#	]
# ]
var inventories: Dictionary[String, Dictionary] = {} 
