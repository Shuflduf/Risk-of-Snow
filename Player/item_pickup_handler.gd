class_name ItemPickupHandler
extends Area3D


func get_items() -> Array[DroppedItem]:
	var items: Array[DroppedItem]
	for body: Node3D in get_overlapping_bodies():
		items.append(body)
	return items
