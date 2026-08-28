extends Node

signal equipped_item_changed(new_item: ItemData)
signal saturation_changed(new_saturation: int)
signal health_changed(new_health: int)

const MIN_RUN_SATURATION: int = 30
const BAR_LEVELS: Array[Dictionary] = [
	{&"min": 0, &"col": Color("7a213a")},
	{&"min": 10, &"col": Color("e14141")},
	{&"min": 30, &"col": Color("ffbf36")},
	{&"min": 50, &"col": Color("fff275")},
	{&"min": 70, &"col": Color("83e04c")},
	{&"min": 90, &"col": Color("39855a")},
]

var inventory: Inventory
var equipped_item: ItemData:
	set(new_item):
		equipped_item = new_item
		equipped_item_changed.emit(new_item)
var health: int = 100:
	set(new_val):
		health = new_val
		health_changed.emit(new_val)
var saturation: int = 100:
	set(new_val):
		saturation = new_val
		saturation_changed.emit(new_val)


func _ready() -> void:
	create_saturation_timer()


func _on_saturation_timer_timeout() -> void:
	#saturation -= 1
	pass


func create_saturation_timer() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(_on_saturation_timer_timeout)
	timer.start(10.0)


func can_run() -> bool:
	return saturation >= MIN_RUN_SATURATION
