class_name PlaceableGhost
extends Node3D

static func build(scene: PackedScene) -> PlaceableGhost:
	var new_self = PlaceableGhost.new()
	new_self.add_child(scene.instantiate())
	
	return new_self
