class_name UI
extends Control

@onready var primary_action_label: Label = %PrimaryActionLabel
@onready var secondary_action_label: Label = %SecondaryActionLabel
@onready var display_name_label: Label = %DisplayNameLabel
@onready var equipped_item: TextureRect = %EquippedItem
@onready var saturation_bar: TextureProgressBar = %SaturationBar
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var death_message: VBoxContainer = $DeathMessage


func _ready() -> void:
	_equipped_item_changed(PlayerData.equipped_item)
	_saturation_changed(PlayerData.saturation)
	_health_changed(PlayerData.health)
	PlayerData.equipped_item_changed.connect(_equipped_item_changed)
	PlayerData.saturation_changed.connect(_saturation_changed)
	PlayerData.health_changed.connect(_health_changed)


func _equipped_item_changed(new_item: ItemData) -> void:
	if new_item != null:
		equipped_item.texture = new_item.sprite
	else:
		equipped_item.texture = null


func _saturation_changed(saturation: int) -> void:
	saturation_bar.value = saturation
	var bar_tint: Color = PlayerData.BAR_LEVELS[0][&"col"]
	for level: Dictionary[StringName, Variant] in PlayerData.BAR_LEVELS:
		if saturation > level[&"min"]:
			bar_tint = level[&"col"]
		else:
			break
	saturation_bar.tint_progress = bar_tint


func _health_changed(health: int) -> void:
	health_bar.value = health
	var bar_tint: Color = PlayerData.BAR_LEVELS[0][&"col"]
	for level: Dictionary[StringName, Variant] in PlayerData.BAR_LEVELS:
		if health > level[&"min"]:
			bar_tint = level[&"col"]
		else:
			break
	health_bar.tint_progress = bar_tint


func set_display_name_text(new_text: String) -> void:
	display_name_label.visible = new_text != ""
	display_name_label.text = new_text


func set_primary_action_text(new_text: String) -> void:
	primary_action_label.visible = new_text != ""
	primary_action_label.text = "%s [LMB]" % new_text


func set_secondary_action_text(new_text: String) -> void:
	secondary_action_label.visible = new_text != ""
	secondary_action_label.text = "%s [RMB]" % new_text


func blocked_item(item: ItemData) -> void:
	display_name_label.show()
	display_name_label.text = item.display_name
	primary_action_label.show()
	primary_action_label.text = "Can not be used here"


func die() -> void:
	death_message.show()
