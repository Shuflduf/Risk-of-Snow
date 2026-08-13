extends Node3D

const MAX_X_ROTATION = PI/2.0 - 0.5

@export var sensitivity = 0.003
@onready var cam: Camera3D = %Camera3D

@onready var pivot: Node3D = $Pivot
@onready var player: CharacterBody3D = get_parent()

func set_cam_rotation(new_rot: Vector3):
	player.rotation.y = new_rot.y
	pivot.rotation.x = new_rot.x

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * sensitivity)
		pivot.rotate_x(-event.relative.y * sensitivity)
		pivot.rotation.x = clampf(pivot.rotation.x, -MAX_X_ROTATION, MAX_X_ROTATION)
		
