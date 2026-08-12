extends Interactable

func _ready() -> void:
	primary_action_used.connect(enter_room)
	
func enter_room():
	print("hi!!")
