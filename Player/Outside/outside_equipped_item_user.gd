extends Node3D

@export var ui: UI
@export var camera_raycast: RayCast3D
@export var player_raycast: RayCast3D

var equipped_item: EquippedItem


func _ready() -> void:
	_on_equipped_item_changed(PlayerData.equipped_item)
	PlayerData.equipped_item_changed.connect(_on_equipped_item_changed)


func _on_equipped_item_changed(new_item: ItemData) -> void:
	if new_item == null:
		if equipped_item:
			equipped_item.queue_free()
		return
	elif new_item.use_type == ItemData.Location.INSIDE:
		ui.blocked_item(new_item)
		return

	ui.set_display_name_text(new_item.display_name)
	ui.set_primary_action_text(new_item.primary_action)
	ui.set_secondary_action_text(new_item.secondary_action)
	equipped_item = new_item.equipped.instantiate()
	equipped_item.used_up.connect(_used_up)
	add_child(equipped_item)


func _used_up() -> void:
	PlayerData.equipped_item = null
	_on_equipped_item_changed(null)


func _unhandled_input(event: InputEvent) -> void:
	if equipped_item == null or not InventoryManager.none_shown():
		return
	if event.is_action_pressed(&"primary_interact"):
		equipped_item.primary_action()
	#elif event.is_action_pressed(&"secondary_interact"):
	#var interactable: Interactable = raycast.get_collider()
	#if interactable != null and interactable is Interactable:
	#interactable.secondary_action_used.emit(self)


func _physics_process(_delta: float) -> void:
	rotation.x = camera_raycast.global_rotation.x + PI
	rotation.z = PI
