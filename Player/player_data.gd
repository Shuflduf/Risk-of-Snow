extends Node

signal equipped_item_changed(new_item: ItemData)

var inventory: Inventory
var equipped_item: ItemData:
	set(new_item):
		equipped_item = new_item
		equipped_item_changed.emit(new_item)
