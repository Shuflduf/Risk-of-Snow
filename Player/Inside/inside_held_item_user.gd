extends Node3D

@export var ui: UI

func _ready() -> void:
	PlayerData.equipped_item_changed.connect(_on_equipped_item_changed)
	
func _on_equipped_item_changed(new_item: ItemData):
	if new_item == null or new_item.use_type == ItemData.InsideOrOutside.OUTSIDE:
		return
	print(new_item.primary_action)
	ui.set_display_name_text(new_item.display_name)
	ui.set_primary_action_text(new_item.primary_action)
	ui.set_secondary_action_text(new_item.secondary_action)
	
	add_child(new_item.make_ghost())
	
