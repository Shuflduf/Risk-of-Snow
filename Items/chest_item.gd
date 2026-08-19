class_name ChestItem
extends ItemData

func make_ghost():
	var new_ghost = PlaceableGhost.build(preload("res://Assets/Blender/chest.glb"))
	return new_ghost
