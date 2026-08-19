extends Node

signal update_snow(body: Node3D)

var tracked_bodies: Dictionary[Node3D, Vector3]
var tmp_image: TextureRect


func _ready() -> void:
	tmp_image = TextureRect.new()
	TransitionHandler.transition_started.connect(_on_transition_started)
	add_child(tmp_image)


func _on_transition_started():
	tracked_bodies = {}


func _physics_process(_delta: float) -> void:
	for body: Node3D in tracked_bodies.keys():
		var old_pos = tracked_bodies[body]
		if body.position.distance_squared_to(old_pos) > 1.0:
			tracked_bodies[body] = body.position
			update_snow.emit(body)
