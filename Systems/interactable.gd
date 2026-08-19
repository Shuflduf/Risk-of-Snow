class_name Interactable
extends Area3D

@warning_ignore("unused_signal")
signal primary_action_used(caller: InteractionHandler)
@warning_ignore("unused_signal")
signal secondary_action_used(caller: InteractionHandler)

@export var display_name: String = ""
@export var primary_action: String = ""
@export var secondary_action: String = ""

var id: int = ResourceUID.create_id()


func placed_data() -> PlacedInteractableData:
	return PlacedInteractableData.new()
