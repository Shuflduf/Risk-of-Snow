extends Interactable

@export var def: InventoryDefinition

func _ready() -> void:
	primary_action_used.connect(open_chest)
	
func open_chest(caller: InteractionHandler):
	prints("HIiii", caller)
	caller.open_other_inventory(def, {})
