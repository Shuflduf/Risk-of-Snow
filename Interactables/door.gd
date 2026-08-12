extends Interactable

@export var room_scene: PackedScene

func _ready() -> void:
	primary_action_used.connect(enter_room)
	
func enter_room():
	TransitionHandler.switch_to_scene(room_scene)
