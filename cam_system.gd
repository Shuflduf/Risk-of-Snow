extends Node3D
@export var sensitivity = 0.005
@onready var cam: Camera3D = $Camera3D
@onready var player: CharacterBody3D = get_parent()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * sensitivity)
		cam.rotate_x(-event.relative.y * sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -PI/2.0, PI/2.0)
		
