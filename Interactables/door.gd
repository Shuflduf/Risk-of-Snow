extends Interactable

@export var door_id: StringName
@export_file("*.tscn") var target_scene: String
@export var target_door_id: StringName
@export var scene_root: Node
@onready var spawn_position: Marker3D = $SpawnPosition


func _ready() -> void:
	primary_action_used.connect(enter_room)


func enter_room(_caller: InteractionHandler) -> void:
	TransitionHandler.switch_to_scene(scene_root, target_scene, target_door_id)
