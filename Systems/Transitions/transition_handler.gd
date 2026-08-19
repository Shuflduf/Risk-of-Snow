extends Control

signal transition_started

@onready var panel: Panel = $Panel

func switch_to_scene(old_scene: Node, new_scene: String, door_id: StringName):
	transition_started.emit()
	old_scene.process_mode = Node.PROCESS_MODE_DISABLED

	var tween = get_tree().create_tween()
	tween.tween_property(panel, ^"modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await tween.finished

	old_scene.queue_free()
	old_scene.tree_exited.connect(load_next_scene.bind(new_scene, door_id))


func load_next_scene(new_scene: String, door_id: StringName):
	var new_area: Node3D = load(new_scene).instantiate()
	WorldData.current_area = new_area
	get_tree().root.add_child(new_area)
	WorldData.place_interactables()
	new_area.process_mode = Node.PROCESS_MODE_DISABLED

	for door in new_area.get_tree().get_nodes_in_group(&"Door"):
		if door.door_id == door_id:
			var player: Node3D = new_area.get_tree().get_first_node_in_group(&"Player")
			player.global_position = door.spawn_position.global_position
			player.set_cam_rotation(door.spawn_position.global_rotation)
	
	var tween = get_tree().create_tween()
	tween.tween_property(panel, ^"modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	await tween.finished

	new_area.process_mode = Node.PROCESS_MODE_INHERIT
	
