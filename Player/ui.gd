class_name UI
extends Control

@onready var primary_action_label: Label = %PrimaryActionLabel
@onready var secondary_action_label: Label = %SecondaryActionLabel
@onready var display_name_label: Label = %DisplayNameLabel
@onready var equipped_item: TextureRect = %EquippedItem


func _ready() -> void:
	_equipped_item_changed(PlayerData.equipped_item)
	PlayerData.equipped_item_changed.connect(_equipped_item_changed)


func _equipped_item_changed(new_item: ItemData) -> void:
	if new_item != null:
		equipped_item.texture = new_item.sprite
	else:
		equipped_item.texture = null


func set_display_name_text(new_text: String) -> void:
	display_name_label.visible = new_text != ""
	display_name_label.text = new_text


func set_primary_action_text(new_text: String) -> void:
	primary_action_label.visible = new_text != ""
	primary_action_label.text = "%s [LMB]" % new_text


func set_secondary_action_text(new_text: String) -> void:
	secondary_action_label.visible = new_text != ""
	secondary_action_label.text = "%s [RMB]" % new_text
