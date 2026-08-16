class_name ItemData
extends Resource

@export var display_name: String
@export var tiles: Array[Vector2i] = []
@export var sprite: Texture2D

var data: Dictionary[StringName, Variant] = {}


#
func build() -> InventoryItem:
	var root = InventoryItem.new()
	root.data = self
	root.z_index = 2
	#root.set_anchors_preset(Control.PRESET_CENTER)
	#root.top_level = true
	for tile_pos in tiles:
		var tile = Control.new()
		tile.size = Vector2(InventoryManager.TILE_SIZE, InventoryManager.TILE_SIZE)
		tile.position = (
			Vector2(tile_pos) * Vector2(InventoryManager.TILE_SIZE, InventoryManager.TILE_SIZE)
		)
		root.add_child(tile)

	var tex = TextureRect.new()
	tex.texture = sprite
	tex.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	root.add_child(tex)

	return root


func build_dropped() -> DroppedItem:
	var root: DroppedItem = preload("res://Systems/Inventory/dropped_item.tscn").instantiate()
	root.data = self
	
	return root


func bounds() -> Vector2i:
	var biggest = Vector2i(1, 1)
	for tile in tiles:
		if tile.x + 1 > biggest.x:
			biggest.x = tile.x + 1
		if tile.y + 1 > biggest.y:
			biggest.y = tile.y + 1
	return biggest
