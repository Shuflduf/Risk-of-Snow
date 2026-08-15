class_name InventoryDefinition
extends Resource

@export var display_name: String = ""
@export var size: Vector2i = Vector2i(1, 1)
@export var chest: bool = false

func build() -> ItemGrid:
	var root: ItemGrid = BackpackInventory.new()
	if chest:
		root = ChestInventory.new()
	root.columns = size.x
	root.add_theme_constant_override(&"h_separation", 0)
	root.add_theme_constant_override(&"v_separation", 0)
	for i in size.x * size.y:
		var tile = Panel.new()
		tile.custom_minimum_size = Vector2(ItemGrid.TILE_SIZE, ItemGrid.TILE_SIZE)
		root.add_child(tile)
	return root
