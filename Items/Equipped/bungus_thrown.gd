extends RigidBody3D

@export var field: PackedScene


func _ready() -> void:
	body_entered.connect(_on_bounced)


func _on_bounced(_body: Node) -> void:
	linear_velocity /= 2.0
	if linear_velocity.length_squared() < 5.0:
		print("EXPLODE")
		var new_field: Area3D = field.instantiate()
		new_field.position = position
		WorldData.current_area.add_child(new_field)
		queue_free()
