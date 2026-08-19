extends Node3D

@export var ui: UI
@export var raycast: RayCast3D

var equipped_item: EquippedItem


func _ready() -> void:
	_on_equipped_item_changed(PlayerData.equipped_item)
	PlayerData.equipped_item_changed.connect(_on_equipped_item_changed)


func _on_equipped_item_changed(new_item: ItemData):
	if new_item == null or new_item.use_type == ItemData.InsideOrOutside.OUTSIDE:
		if equipped_item:
			equipped_item.queue_free()
		return
	print(new_item.primary_action)
	ui.set_display_name_text(new_item.display_name)
	ui.set_primary_action_text(new_item.primary_action)
	ui.set_secondary_action_text(new_item.secondary_action)
	equipped_item = new_item.equipped.instantiate()
	equipped_item.used_up.connect(_used_up)
	add_child(equipped_item)


func _used_up():
	PlayerData.equipped_item = null
	_on_equipped_item_changed(null)


func _unhandled_key_input(event: InputEvent) -> void:
	if equipped_item == null:
		return
	if event.is_action_pressed(&"primary_interact"):
		equipped_item.primary_action()
	#elif event.is_action_pressed(&"secondary_interact"):
	#var interactable: Interactable = raycast.get_collider()
	#if interactable != null and interactable is Interactable:
	#interactable.secondary_action_used.emit(self)


func _physics_process(_delta: float) -> void:
	rotation.x = raycast.global_rotation.x + PI
	rotation.z = PI
