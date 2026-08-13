class_name UI
extends Control

@onready var primary_action_label: Label = %PrimaryActionLabel
@onready var secondary_action_label: Label = %SecondaryActionLabel


func set_primary_action_text(new_text: String):
	primary_action_label.visible = new_text != ""
	primary_action_label.text = "%s [F]" % new_text


func set_secondary_action_text(new_text: String):
	secondary_action_label.visible = new_text != ""
	secondary_action_label.text = "%s [G]" % new_text
