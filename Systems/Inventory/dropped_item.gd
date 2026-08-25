class_name DroppedItem
extends RigidBody3D

@export var data: ItemData

var id: int = ResourceUID.create_id()

@onready var visuals: Node3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $Particles


func _ready() -> void:
	if data.dropped_mesh:
		visuals.free()
		visuals = data.dropped_mesh.instantiate()
		add_child(visuals)
		visuals.scale = data.dropped_mesh_scale


func set_in_range(in_range: bool) -> void:
	particles.emitting = in_range


func drop_data() -> DroppedItemData:
	var new_data: DroppedItemData = DroppedItemData.new()
	new_data.position = position
	new_data.rotation = rotation
	new_data.data = data
	return new_data
