extends Node

signal equipped_item_changed(new_item: ItemData)
signal saturation_changed(new_saturation: int)

var inventory: Inventory
var equipped_item: ItemData:
	set(new_item):
		equipped_item = new_item
		equipped_item_changed.emit(new_item)
var saturation: int = 100:
	set(new_val):
		saturation = new_val
		saturation_changed.emit(new_val)


func _ready() -> void:
	create_saturation_timer()


func _on_saturation_timer_timeout() -> void:
	saturation -= 1


func create_saturation_timer() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(_on_saturation_timer_timeout)
	timer.start(10.0)
	
