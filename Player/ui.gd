class_name UI
extends Control

@onready var primary_action_label: Label = %PrimaryActionLabel
@onready var secondary_action_label: Label = %SecondaryActionLabel
@onready var display_name_label: Label = %DisplayNameLabel
@onready var held_item: TextureRect = %HeldItem

func _ready() -> void:
	if PlayerData.equipped_item != null:
		held_item.texture = PlayerData.equipped_item.sprite
	PlayerData.equipped_item_changed.connect(_equipped_item_changed)

func _equipped_item_changed(new_item: ItemData) -> void:
	if new_item != null:
		held_item.texture = new_item.sprite
	else:
		held_item.texture = null


func set_display_name_text(new_text: String):
	display_name_label.visible = new_text != ""
	display_name_label.text = new_text


func set_primary_action_text(new_text: String):
	primary_action_label.visible = new_text != ""
	primary_action_label.text = "%s [F]" % new_text


func set_secondary_action_text(new_text: String):
	secondary_action_label.visible = new_text != ""
	secondary_action_label.text = "%s [G]" % new_text
