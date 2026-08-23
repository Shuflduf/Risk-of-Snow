class_name CamSystem
extends Node3D

@export var sensitivity: float = 0.003
@export var look_margin: float

@export var trauma_reduction_rate: float= 1.0
@export var noise: FastNoiseLite
@export var noise_speed: float = 1.0

@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_z: float = 5.0

var trauma: float = 1.0
var time: float = 0.0

@onready var max_x_rotation:float = PI / 2.0 - look_margin
@onready var cam: Camera3D = %Camera3D
@onready var pivot: Node3D = $Pivot
@onready var player: CharacterBody3D = get_parent()

func _process(delta: float) -> void:
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	cam.rotation.x = deg_to_rad(max_x * _get_shake_intensity() * _get_noise_from_seed(0))
	cam.rotation.y = deg_to_rad(max_y * _get_shake_intensity() * _get_noise_from_seed(1))
	cam.rotation.z = deg_to_rad(max_z * _get_shake_intensity() * _get_noise_from_seed(2))

func set_cam_rotation(new_rot: Vector3) -> void:
	player.rotation.y = new_rot.y
	pivot.rotation.x = new_rot.x


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = (
			Input.MOUSE_MODE_CAPTURED
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE
			else Input.MOUSE_MODE_VISIBLE
		)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * sensitivity)
		pivot.rotate_x(-event.relative.y * sensitivity)
		pivot.rotation.x = clampf(pivot.rotation.x, -max_x_rotation, max_x_rotation)

func _get_shake_intensity() -> float:
	return trauma * trauma


func _get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)
