extends Interactable

@export var inventory: Inventory

func _ready() -> void:
	primary_action_used.connect(open)

func open(caller: InteractionHandler):
	caller.open_other_inventory(inventory)
