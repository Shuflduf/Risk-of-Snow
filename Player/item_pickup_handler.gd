class_name ItemPickupHandler
extends Area3D


func get_items() -> Array[DroppedItem]:
	var items: Array[DroppedItem]
	for area in get_overlapping_areas():
		items.append(area)
	return items
