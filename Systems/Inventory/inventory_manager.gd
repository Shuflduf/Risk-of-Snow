extends Control

const TILE_SIZE: int = InventoryView.TILE_SIZE

var player: Node3D
var second_last_mouse_pos: Vector2
var last_mouse_pos: Vector2

@onready var views: HBoxContainer = $Views
@onready var close_button: Button = $CloseButton

func _ready() -> void:
	close_button.pressed.connect(close_all)


func open(inventory: Inventory) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	close_button.show()
	var view: InventoryView = InventoryView.build(
		inventory,
		func(item: InventoryItem) -> void:
			item.picked_up.connect(item_picked_up.bind(item))
			item.moved.connect(item_moved.bind(item))
			item.dropped.connect(item_dropped.bind(item))
	)

	views.add_child(view)


func none_shown() -> bool:
	return views.get_child_count() == 0


func close_all() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	for view: InventoryView in views.get_children():
		view.closed.emit()
		view.queue_free()
	
	for item: Node in get_children():
		if item is InventoryItem:
			if item.being_dragged:
				item.being_dragged = false
				force_drop_item(last_mouse_pos, item)
			item.queue_free()
	
	close_button.hide()


func show_held() -> void:
	views.add_child(preload("res://Systems/Inventory/held_item_slot.tscn").instantiate())


func show_dropped_items(items: Array[DroppedItem]) -> void:
	for drop: DroppedItem in items:
		# gdformat fucked this up dont worry about it
		var relative_pos: Vector2 = (
			(
				(
					(
						Vector2(
							drop.position.x - player.position.x, drop.position.z - player.position.z
						)
						. rotated(player.rotation.y)
					)
					* 0.3
				)
				+ Vector2(0.5, 0.5)
			)
			. clamp(Vector2.ZERO, Vector2.ONE)
		)
		var screen_pos: Vector2 = (
			(relative_pos * get_window().get_viewport().get_visible_rect().size)
			. clamp(
				Vector2.ZERO,
				(
					get_window().get_viewport().get_visible_rect().size
					- Vector2(drop.data.bounds()) * TILE_SIZE
				)
			)
		)
		var item: InventoryItem = drop.data.build()
		item.set_not_placed()
		item.position = screen_pos
		item.picked_up.connect(dropped_item_picked_up.bind(drop, item))
		item.picked_up.connect(item_picked_up.bind(item))
		item.moved.connect(item_moved.bind(item))
		item.dropped.connect(item_dropped.bind(item))
		add_child(item)


func item_picked_up(item: InventoryItem) -> void:
	var view: Control = item.get_parent()
	if view is InventoryView:
		if view.inventory.can_pickup_item(item):
			view.inventory.items.erase(item.tile_position())
		else:
			item.being_dragged = false
			return
	item.reparent(self)
	item.move_to_front()
	item.set_not_placed()


func item_moved(mouse_pos: Vector2, item: InventoryItem) -> void:
	item.position = mouse_pos - Vector2(TILE_SIZE, TILE_SIZE) / 2.0
	second_last_mouse_pos = last_mouse_pos
	last_mouse_pos = mouse_pos
	for view: Node in views.get_children():
		if view is not InventoryView:
			continue

		view.attempt_hover(item, mouse_pos)


func item_dropped(mouse_pos: Vector2, item: InventoryItem) -> void:
	for view: Node in views.get_children():
		if view.attempt_place(item, mouse_pos):
			return

	force_drop_item(mouse_pos, item)


func force_drop_item(mouse_pos: Vector2, item: InventoryItem) -> void:
	var new_drop: DroppedItem = item.data.build_dropped()
	var relative_pos: Vector2 = (
		((mouse_pos / get_window().get_viewport().get_visible_rect().size) - Vector2(0.5, 0.5))
		* 2.0
	)
	relative_pos *= 1.7
	new_drop.position = (
		player.position
		+ Vector3(relative_pos.x, 0.0, relative_pos.y).rotated(Vector3.UP, player.rotation.y)
	)
	new_drop.rotation.y = randf_range(0.0, PI * 2.0)

	WorldData.current_area.add_child(new_drop)
	var strength: float = clamp(
		(second_last_mouse_pos.distance_to(mouse_pos) / get_process_delta_time()) * 0.001, 0.0, 5.0
	)
	if strength > 3.0:
		var dir: Vector2 = second_last_mouse_pos.direction_to(mouse_pos).rotated(-player.rotation.y)
		new_drop.apply_impulse(Vector3(dir.x, 1.0, dir.y) * strength)
		new_drop.apply_torque_impulse(Vector3.FORWARD * strength * 0.05)
	item.picked_up.connect(dropped_item_picked_up.bind(new_drop, item))


func dropped_item_picked_up(drop: DroppedItem, item: InventoryItem) -> void:
	if drop == null:
		return
	drop.queue_free()

	for conn: Dictionary in item.picked_up.get_connections():
		item.picked_up.disconnect(conn["callable"])
	item.picked_up.connect(item_picked_up.bind(item))
