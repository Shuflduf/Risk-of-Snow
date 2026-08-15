class_name ItemData
extends Resource

@export var display_name: String
@export var tiles: Array[Vector2i] = []

var data: Dictionary[StringName, Variant] = {}

func build() -> InventoryItem:
	var root = InventoryItem.new()
	root.data = self
	root.set_anchors_preset(Control.PRESET_CENTER)
	root.top_level = true
	for tile in tiles:
		var tex = TextureRect.new()
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.texture = preload("res://icon.svg")
		tex.size = Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE)
		tex.position = Vector2(tile) * Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE)
		root.add_child(tex)
	
	return root
