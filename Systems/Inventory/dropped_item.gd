class_name DroppedItem
extends RigidBody3D

@export var data: ItemData
@onready var visuals: Node3D = $MeshInstance3D

func load_scene(scene: PackedScene) -> void:
	if not is_node_ready():
		await ready
	print(visuals)
	if visuals:
		visuals.free()
	visuals = scene.instantiate()
	add_child(visuals)

func scale_visuals(new_scale: Vector3) -> void:
	if not is_node_ready():
		await ready
	visuals.scale = new_scale
