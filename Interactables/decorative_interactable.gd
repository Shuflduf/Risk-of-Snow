extends Interactable

@export_file("*.tres") var item_data: String


func _ready() -> void:
	secondary_action_used.connect(pickup)


func placed_data() -> PlacedInteractableData:
	var data: PlacedInteractableData = PlacedInteractableData.new()
	data.position = position
	data.rotation = rotation
	data.scene = load(scene_file_path)
	return data


func pickup(_caller: InteractionHandler) -> void:
	PlayerData.equipped_item = load(item_data)
	queue_free()
