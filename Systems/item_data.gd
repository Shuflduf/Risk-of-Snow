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
		var tile= Control.new()
		tile.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		tile.size = Vector2(InventoryManager.TILE_SIZE, InventoryManager.TILE_SIZE)
		tile.position = Vector2(tile_pos) * Vector2(InventoryManager.TILE_SIZE, InventoryManager.TILE_SIZE)
		root.add_child(tile)
	
	var tex = TextureRect.new()
	tex.texture = sprite
	root.add_child(tex)
	
	return root
