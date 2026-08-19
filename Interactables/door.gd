extends Interactable

@export var door_id: StringName
@export_file("*.tscn") var target_scene: String
@export var target_door_id: StringName
@onready var spawn_position: Marker3D = $SpawnPosition


func _ready() -> void:
	primary_action_used.connect(enter_room)

func enter_room(_caller: InteractionHandler):
	TransitionHandler.switch_to_scene(owner, target_scene, target_door_id)
