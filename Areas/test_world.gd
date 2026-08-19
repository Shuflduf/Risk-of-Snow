extends Node3D


func _ready() -> void:
	WorldData.current_area = self
	WorldData._on_transition_ended()
