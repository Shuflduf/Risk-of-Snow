extends Interactable

func _ready() -> void:
	primary_action_used.connect(open_chest)
	
func open_chest():
	print("HIiii")
