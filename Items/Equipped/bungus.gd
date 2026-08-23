extends EquippedItem

@onready var bomb: RigidBody3D = $Bomb

func _physics_process(delta: float) -> void:
	print(global_rotation_degrees)
	
func primary_action() -> void:
	bomb.reparent(WorldData.current_area)
	bomb.show()
	bomb.freeze = false
	bomb.global_position = global_position
	var throw_vec: Vector3 = Vector3(
		sin(global_rotation.x),
		sin(global_rotation.y),
		cos(global_rotation.x),
	).normalized()
	print(throw_vec)
	bomb.apply_impulse(throw_vec * 15.0)
	#bomb.apply_torque_impulse(global_transform.basis.x.normalized() * 0.2)
	used_up.emit()
