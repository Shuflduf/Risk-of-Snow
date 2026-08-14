class_name InventoryDefinition
extends Resource

@export var display_name: String = ""
@export var size: Vector2i = Vector2i(1, 1)

func build() -> GridContainer:
	var root = GridContainer.new()
	root.columns = size.x
	for i in size.x * size.y:
		var tile = Panel.new()
		tile.custom_minimum_size = Vector2(Backpack.TILE_SIZE, Backpack.TILE_SIZE)
		root.add_child(tile)
	return root
