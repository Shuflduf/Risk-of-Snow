class_name ItemPickupHandler
extends Area3D


func _ready() -> void:
	body_entered.connect(_dropped_item_entered)
	body_exited.connect(_dropped_item_exited)


func _dropped_item_entered(item: Node3D) -> void:
	item.set_in_range(true)


func _dropped_item_exited(item: Node3D) -> void:
	item.set_in_range(false)


func get_items() -> Array[DroppedItem]:
	var items: Array[DroppedItem]
	for body: Node3D in get_overlapping_bodies():
		items.append(body)
	return items
