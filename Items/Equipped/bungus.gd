extends EquippedItem

@onready var bomb: RigidBody3D = $Bomb


func primary_action() -> void:
	bomb.reparent(WorldData.current_area)
	bomb.show()
	bomb.freeze = false
	bomb.global_position = global_position

	bomb.apply_impulse(Vector3(0.0, 5.0, 0.0))
	bomb.apply_torque_impulse(global_transform.basis.x.normalized() * 0.2)
	used_up.emit()
