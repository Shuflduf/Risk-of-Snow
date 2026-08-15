extends Interactable

@export var def: InventoryDefinition

var inventory: Dictionary[Vector2i, ItemData] = {}

func _ready() -> void:
	primary_action_used.connect(open_chest)
	
func open_chest(caller: InteractionHandler):
	var item_grid: ChestInventory = caller.open_other_inventory(def, inventory)
	item_grid.inventory_saved.connect(save_items)

func save_items(items: Dictionary[Vector2i, ItemData]):
	print(items)
	inventory = items
